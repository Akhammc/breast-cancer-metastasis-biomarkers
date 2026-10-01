# Day 16: Final Expression Figure 2 — Specimen-level PCA
# Project: Breast Cancer Metastasis Biomarkers
# Dataset: GEO GSE316391
# Descriptive/exploratory figure only; no inferential tissue comparisons.

options(stringsAsFactors = FALSE)

library(ggplot2)

output_dir <- "results/day16/figure2"
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
  stop("Expected 16 specimen columns.")
}

if (!setequal(specimen_ids, meta$specimen_id)) {
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
# 2. Select top 500 most variable genes across specimens
# ------------------------------------------------------------

gene_variance <- apply(
  expr_values,
  1,
  var
)

if (anyNA(gene_variance)) {
  stop("Gene variance calculation produced missing values.")
}

top_n <- min(500, length(gene_variance))

top_gene_indices <- order(
  gene_variance,
  decreasing = TRUE
)[seq_len(top_n)]

pca_matrix <- expr_values[top_gene_indices, , drop = FALSE]

# ------------------------------------------------------------
# 3. PCA
#    Established exploratory convention:
#    centered = TRUE, scaled = FALSE
# ------------------------------------------------------------

pca <- prcomp(
  t(pca_matrix),
  center = TRUE,
  scale. = FALSE
)

percent_variance <- 100 * (pca$sdev^2 / sum(pca$sdev^2))

pca_coordinates <- data.frame(
  specimen_id = rownames(pca$x),
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2],
  stringsAsFactors = FALSE
)

pca_coordinates <- merge(
  pca_coordinates,
  meta[, c("specimen_id", "Patient #", "Tissue Site")],
  by = "specimen_id",
  all.x = TRUE,
  sort = FALSE
)

pca_coordinates$specimen_id <- factor(
  pca_coordinates$specimen_id,
  levels = specimen_ids
)

# ------------------------------------------------------------
# 4. Figure 2 — PCA
# ------------------------------------------------------------

figure2 <- ggplot(
  pca_coordinates,
aes(
    x = PC1,
    y = PC2,
    shape = `Tissue Site`
  )
) +
  geom_point(size = 3) +
geom_text(
    aes(label = `Patient #`),
    vjust = -0.8,
    size = 3
  ) +
  labs(
    title = "Specimen-Level Principal Component Analysis",
    subtitle = paste0(
      "Top ", top_n,
      " most variable genes; centered, unscaled PCA"
    ),
    x = paste0("PC1 (", round(percent_variance[1], 1), "%)"),
    y = paste0("PC2 (", round(percent_variance[2], 1), "%)"),
    shape = "Tissue Site"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 9),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 9),
    legend.title = element_text(size = 9),
    legend.text = element_text(size = 8)
  )

ggsave(
  filename = file.path(
    output_dir,
    "day16_figure2_specimen_pca.png"
  ),
  plot = figure2,
  width = 9,
  height = 7,
  dpi = 300
)

# ------------------------------------------------------------
# 5. Save PCA coordinates and variance
# ------------------------------------------------------------

write.csv(
  pca_coordinates,
  file.path(
    output_dir,
    "day16_figure2_pca_coordinates.csv"
  ),
  row.names = FALSE
)

pca_variance <- data.frame(
  PC = paste0("PC", seq_along(percent_variance)),
  standard_deviation = pca$sdev,
  variance_percent = percent_variance
)

write.csv(
  pca_variance,
  file.path(
    output_dir,
    "day16_figure2_pca_variance.csv"
  ),
  row.names = FALSE
)

top_variable_genes <- data.frame(
  Geneid = expr$Geneid[top_gene_indices],
  gene_name = expr$gene_name[top_gene_indices],
  variance_logCPM = gene_variance[top_gene_indices],
  stringsAsFactors = FALSE
)

write.csv(
  top_variable_genes,
  file.path(
    output_dir,
    "day16_figure2_top500_variable_genes.csv"
  ),
  row.names = FALSE
)

# ------------------------------------------------------------
# 6. Session information
# ------------------------------------------------------------

capture.output(
  sessionInfo(),
  file = file.path(
    output_dir,
    "day16_figure2_session_info.txt"
  )
)

# ------------------------------------------------------------
# 7. Completion message
# ------------------------------------------------------------

cat("Day 16 Figure 2 completed.\n")
cat("Genes:", nrow(expr), "\n")
cat("Specimens:", length(specimen_ids), "\n")
cat("Variable genes:", top_n, "\n")
cat(
  "PC1 variance:",
  round(percent_variance[1], 3),
  "%\n"
)
cat(
  "PC2 variance:",
  round(percent_variance[2], 3),
  "%\n"
)
cat(
  "Figure:",
  file.path(
    output_dir,
    "day16_figure2_specimen_pca.png"
  ),
  "\n"
)
cat("Outputs written to:", output_dir, "\n")