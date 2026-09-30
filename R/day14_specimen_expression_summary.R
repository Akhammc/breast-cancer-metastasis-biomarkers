# Day 14 - Final specimen-level descriptive expression summary
#
# Purpose:
#   Implement the frozen Day 13 specimen-level descriptive aggregation.
#
# Scope:
#   Descriptive/exploratory only. No inferential tissue comparison,
#   differential-expression testing, or population-level inference.

suppressPackageStartupMessages({
  library(edgeR)
  library(readxl)
})

# 1. Paths
counts_file <- "data/raw/GSE316391_counts_PE.csv.gz"
metadata_file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"
out_dir <- "results/day14"

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 2. Read and validate the PE count matrix
counts <- read.csv(
  counts_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

stopifnot(ncol(counts) == 39)
stopifnot(nrow(counts) == 62703)
stopifnot(!anyDuplicated(counts$Geneid))

library_ids <- colnames(counts)[8:39]
count_matrix <- as.matrix(counts[, library_ids, drop = FALSE])
rownames(count_matrix) <- counts$Geneid

stopifnot(ncol(count_matrix) == 32)
stopifnot(all(vapply(
  as.data.frame(count_matrix),
  is.numeric,
  logical(1)
)))

# 3. Read and validate RNA-seq metadata
meta <- read_excel(metadata_file, sheet = "RNA-seq")

meta$matrix_id <- gsub("-", "_", meta[["RNA-seq name"]])

meta$specimen_id <- paste(
  meta[["Patient #"]],
  meta[["Tissue Site"]],
  meta[["Container ID"]],
  meta[["Internal Case ID"]],
  sep = "|"
)

stopifnot(nrow(meta) == 32)
stopifnot(!anyDuplicated(meta$matrix_id))
stopifnot(setequal(library_ids, meta$matrix_id))

meta <- meta[match(library_ids, meta$matrix_id), , drop = FALSE]

stopifnot(identical(meta$matrix_id, library_ids))
stopifnot(length(unique(meta$specimen_id)) == 16)

# 4. Established Day 4/D009 preprocessing
y <- DGEList(counts = count_matrix)

keep <- rowSums(cpm(y) > 1) >= 2
stopifnot(any(keep))

y <- y[keep, , keep.lib.sizes = FALSE]

y <- calcNormFactors(y, method = "TMM")

log_cpm <- cpm(
  y,
  log = TRUE,
  prior.count = 2,
  normalized.lib.sizes = TRUE
)

stopifnot(nrow(log_cpm) == 26892)
stopifnot(ncol(log_cpm) == 32)

# 5. Final specimen-level descriptive aggregation
#
# Arithmetic mean of normalized logCPM across libraries belonging
# to the same specimen. This is descriptive only.

specimen_ids <- unique(meta$specimen_id)

specimen_matrix <- sapply(
  specimen_ids,
  function(id) {
    cols <- which(meta$specimen_id == id)
    rowMeans(log_cpm[, cols, drop = FALSE])
  }
)

specimen_matrix <- as.matrix(specimen_matrix)

rownames(specimen_matrix) <- rownames(log_cpm)

stopifnot(nrow(specimen_matrix) == 26892)
stopifnot(ncol(specimen_matrix) == 16)

# 6. Gene annotation
gene_annotation <- data.frame(
  Geneid = rownames(specimen_matrix),
  gene_name = counts$gene_name[match(
    rownames(specimen_matrix),
    counts$Geneid
  )],
  stringsAsFactors = FALSE
)

stopifnot(identical(gene_annotation$Geneid, rownames(specimen_matrix)))

# 7. Specimen metadata
specimen_metadata <- meta[
  !duplicated(meta$specimen_id),
  c(
    "specimen_id",
    "Patient #",
    "Tissue Site",
    "Container ID",
    "Internal Case ID",
    "Histology"
  ),
  drop = FALSE
]

specimen_metadata$n_libraries <- vapply(
  specimen_metadata$specimen_id,
  function(id) sum(meta$specimen_id == id),
  integer(1)
)

rownames(specimen_metadata) <- specimen_metadata$specimen_id

stopifnot(nrow(specimen_metadata) == 16)
stopifnot(sum(specimen_metadata$n_libraries) == 32)

# 8. Write outputs
specimen_expression_output <- data.frame(
  Geneid = rownames(specimen_matrix),
  gene_name = gene_annotation$gene_name,
  specimen_matrix,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

write.csv(
  specimen_expression_output,
  file.path(out_dir, "day14_specimen_mean_logCPM.csv"),
  row.names = FALSE
)

write.csv(
  specimen_metadata,
  file.path(out_dir, "day14_specimen_metadata.csv"),
  row.names = FALSE
)

write.csv(
  data.frame(
    Geneid = rownames(log_cpm),
    mean_logCPM_across_specimens =
      rowMeans(specimen_matrix),
    variance_logCPM_across_specimens =
      apply(specimen_matrix, 1, var),
    stringsAsFactors = FALSE
  ),
  file.path(out_dir, "day14_specimen_expression_summary.csv"),
  row.names = FALSE
)

writeLines(
  capture.output(sessionInfo()),
  con = file.path(out_dir, "day14_session_info.txt")
)

cat("Day 14 specimen-level descriptive expression summary completed.\n")
cat("Libraries:", ncol(log_cpm), "\n")
cat("Specimens:", ncol(specimen_matrix), "\n")
cat("Genes retained:", nrow(specimen_matrix), "\n")
cat("Outputs written to:", out_dir, "\n")