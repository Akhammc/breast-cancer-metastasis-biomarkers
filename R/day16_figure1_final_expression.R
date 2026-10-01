# Day 16: Final Expression Figures
# Project: Breast Cancer Metastasis Biomarkers
# Dataset: GEO GSE316391
# Descriptive/exploratory figures only; no inferential tissue comparisons.

options(stringsAsFactors = FALSE)

library(ggplot2)

output_dir <- "results/day16/figure1"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

expression_file <- "results/day14/day14_specimen_mean_logCPM.csv"
metadata_file <- "results/day14/day14_specimen_metadata.csv"

# ------------------------------------------------------------
# 1. Read and validate finalized Day 14 inputs
# ------------------------------------------------------------

expr <- read.csv(
  expression_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

meta <- read.csv(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

if (!all(c("Geneid", "gene_name") %in% colnames(expr))) {
  stop("Expression matrix must contain Geneid and gene_name columns.")
}

if (nrow(expr) != 26892) {
  stop("Unexpected number of genes in Day 14 expression matrix.")
}

specimen_ids <- setdiff(colnames(expr), c("Geneid", "gene_name"))

if (length(specimen_ids) != 16) {
  stop("Expected 16 specimen columns in Day 14 expression matrix.")
}

if (!all(specimen_ids %in% meta$specimen_id) ||
    !all(meta$specimen_id %in% specimen_ids)) {
  stop("Expression matrix and metadata specimen IDs do not match.")
}

expr_values <- as.matrix(expr[, specimen_ids, drop = FALSE])

if (anyNA(expr_values)) {
  stop("Expression matrix contains missing values.")
}

if (any(!is.finite(expr_values))) {
  stop("Expression matrix contains non-finite values.")
}

# ------------------------------------------------------------
# 2. Figure 1 — Specimen-level expression distributions
# ------------------------------------------------------------

distribution_rows <- lapply(specimen_ids, function(specimen_id) {
  data.frame(
    specimen_id = specimen_id,
    logCPM = expr_values[, specimen_id],
    stringsAsFactors = FALSE
  )
})

distribution_data <- do.call(rbind, distribution_rows)

distribution_data <- merge(
  distribution_data,
  meta[, c("specimen_id", "Patient #", "Tissue Site")],
  by = "specimen_id",
  all.x = TRUE,
  sort = FALSE
)

distribution_data$specimen_label <- factor(
  distribution_data$specimen_id,
  levels = specimen_ids
)

figure1 <- ggplot(
  distribution_data,
  aes(x = logCPM)
) +
  geom_density() +
  facet_wrap(
    ~ specimen_label,
    ncol = 4,
    scales = "free_y"
  ) +
  labs(
    title = "Normalized Expression Distributions Across Specimens",
    x = "Normalized logCPM",
    y = "Density"
  ) +
  theme_bw() +
  theme(
    strip.text = element_text(size = 8),
    axis.text = element_text(size = 8),
    axis.title = element_text(size = 10),
    plot.title = element_text(size = 12)
  )

ggsave(
  filename = file.path(
    output_dir,
    "day16_figure1_specimen_expression_distributions.png"
  ),
  plot = figure1,
  width = 12,
  height = 9,
  dpi = 300
)

# ------------------------------------------------------------
# 3. Save plotting data for reproducibility
# ------------------------------------------------------------

write.csv(
  distribution_data,
  file.path(
    output_dir,
    "day16_figure1_distribution_data.csv"
  ),
  row.names = FALSE
)

# ------------------------------------------------------------
# 4. Session information
# ------------------------------------------------------------

capture.output(
  sessionInfo(),
  file = file.path(output_dir, "day16_session_info.txt")
)

# ------------------------------------------------------------
# 5. Completion message
# ------------------------------------------------------------

cat("Day 16 Figure 1 completed.\n")
cat("Genes:", nrow(expr), "\n")
cat("Specimens:", length(specimen_ids), "\n")
cat(
  "Figure:",
  file.path(
    output_dir,
    "day16_figure1_specimen_expression_distributions.png"
  ),
  "\n"
)
cat("Outputs written to:", output_dir, "\n")