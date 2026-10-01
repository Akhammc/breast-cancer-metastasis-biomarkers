# Day 15: Patient/specimen-aware descriptive analysis
# Uses finalized Day 14 specimen-level expression matrix and metadata.
# Descriptive only; no inferential tissue comparisons.

options(stringsAsFactors = FALSE)

output_dir <- "results/day15"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

metadata_file <- "results/day14/day14_specimen_metadata.csv"
expression_file <- "results/day14/day14_specimen_mean_logCPM.csv"

# -------------------------------------------------------------------------
# 1. Read and validate finalized Day 14 inputs
# -------------------------------------------------------------------------

meta <- read.csv(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

expr <- read.csv(
  expression_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

required_meta_cols <- c(
  "specimen_id",
  "Patient #",
  "Tissue Site",
  "Container ID",
  "Internal Case ID",
  "Histology",
  "n_libraries"
)

missing_meta_cols <- setdiff(required_meta_cols, colnames(meta))

if (length(missing_meta_cols) > 0) {
  stop(
    "Missing required metadata columns: ",
    paste(missing_meta_cols, collapse = ", ")
  )
}

if (nrow(meta) != 16) {
  stop("Expected 16 specimens; found ", nrow(meta))
}

if (anyDuplicated(meta$specimen_id) > 0) {
  stop("Specimen IDs are not unique.")
}

if (!all(c("Geneid", "gene_name") %in% colnames(expr))) {
  stop("Expression matrix must contain Geneid and gene_name columns.")
}

expr_specimen_ids <- setdiff(colnames(expr), c("Geneid", "gene_name"))

if (length(expr_specimen_ids) != 16) {
  stop(
    "Expected 16 specimen expression columns; found ",
    length(expr_specimen_ids)
  )
}

if (!setequal(expr_specimen_ids, meta$specimen_id)) {
  stop("Expression specimen IDs and metadata specimen IDs do not match.")
}

meta$Patient <- as.integer(meta[["Patient #"]])
meta$n_libraries <- as.integer(meta$n_libraries)

if (any(is.na(meta$Patient))) {
  stop("Patient identifiers could not be converted to integers.")
}

if (any(is.na(meta$n_libraries))) {
  stop("Library counts contain missing or invalid values.")
}

expr_values <- as.matrix(expr[, expr_specimen_ids, drop = FALSE])

if (anyNA(expr_values)) {
  stop("Expression matrix contains missing values.")
}

if (any(!is.finite(expr_values)) ) {
  stop("Expression matrix contains non-finite values.")
}

# -------------------------------------------------------------------------
# 2. Patient/specimen structure
# -------------------------------------------------------------------------

patient_ids <- sort(unique(meta$Patient))

patient_rows <- lapply(patient_ids, function(patient_id) {

  x <- meta[meta$Patient == patient_id, , drop = FALSE]

  tissue_sites <- sort(unique(x[["Tissue Site"]]))

  data.frame(
    Patient = patient_id,
    n_specimens = nrow(x),
    n_tissue_sites = length(tissue_sites),
    tissue_sites = paste(tissue_sites, collapse = "; "),
    total_libraries = sum(x$n_libraries),
    stringsAsFactors = FALSE
  )
})

patient_structure <- do.call(rbind, patient_rows)

write.csv(
  patient_structure,
  file.path(output_dir, "day15_patient_specimen_structure.csv"),
  row.names = FALSE,
  na = ""
)

# -------------------------------------------------------------------------
# 3. Matched-tissue structure
# -------------------------------------------------------------------------

tissue_presence <- data.frame(
  Patient = patient_ids,
  Breast = sapply(
    patient_ids,
    function(p) any(
      meta$Patient == p &
        meta[["Tissue Site"]] == "Breast"
    )
  ),
  Liver_Bile_Duct = sapply(
    patient_ids,
    function(p) any(
      meta$Patient == p &
        meta[["Tissue Site"]] == "Liver/Bile Duct"
    )
  ),
  Lung = sapply(
    patient_ids,
    function(p) any(
      meta$Patient == p &
        meta[["Tissue Site"]] == "Lung"
    )
  ),
  stringsAsFactors = FALSE
)

tissue_presence$Breast_Liver <-
  tissue_presence$Breast &
  tissue_presence$Liver_Bile_Duct

tissue_presence$Breast_Lung <-
  tissue_presence$Breast &
  tissue_presence$Lung

tissue_presence$Liver_Lung <-
  tissue_presence$Liver_Bile_Duct &
  tissue_presence$Lung

write.csv(
  tissue_presence,
  file.path(output_dir, "day15_matched_tissue_summary.csv"),
  row.names = FALSE,
  na = ""
)

# -------------------------------------------------------------------------
# 4. Specimen-level descriptive expression summaries
# -------------------------------------------------------------------------

expression_summary_rows <- lapply(seq_len(nrow(meta)), function(i) {

  specimen_id <- meta$specimen_id[i]
  values <- expr_values[, specimen_id]

  data.frame(
    Patient = meta$Patient[i],
    Tissue_Site = meta[["Tissue Site"]][i],
    specimen_id = specimen_id,
    n_libraries = meta$n_libraries[i],
    Histology = meta$Histology[i],
    n_genes = length(values),
    mean_logCPM = mean(values),
    median_logCPM = median(values),
    sd_logCPM = sd(values),
    variance_logCPM = var(values),
    min_logCPM = min(values),
    max_logCPM = max(values),
    stringsAsFactors = FALSE
  )
})

specimen_expression_summary <- do.call(
  rbind,
  expression_summary_rows
)

write.csv(
  specimen_expression_summary,
  file.path(
    output_dir,
    "day15_specimen_expression_summary.csv"
  ),
  row.names = FALSE,
  na = ""
)

# -------------------------------------------------------------------------
# 5. Session information
# -------------------------------------------------------------------------

capture.output(
  sessionInfo(),
  file = file.path(output_dir, "day15_session_info.txt")
)

# -------------------------------------------------------------------------
# 6. Validation messages
# -------------------------------------------------------------------------

cat("Day 15 patient/specimen analysis completed.\n")
cat("Patients:", length(patient_ids), "\n")
cat("Specimens:", nrow(meta), "\n")
cat("Total libraries:", sum(meta$n_libraries), "\n")
cat(
  "Expression genes:",
  nrow(expr),
  "\n"
)
cat(
  "Breast-Liver matched patients:",
  sum(tissue_presence$Breast_Liver),
  "\n"
)
cat(
  "Breast-Lung matched patients:",
  sum(tissue_presence$Breast_Lung),
  "\n"
)
cat(
  "Liver-Lung matched patients:",
  sum(tissue_presence$Liver_Lung),
  "\n"
)
cat(
  "Specimen expression summaries:",
  nrow(specimen_expression_summary),
  "\n"
)
cat(
  "Outputs written to:",
  output_dir,
  "\n"
)