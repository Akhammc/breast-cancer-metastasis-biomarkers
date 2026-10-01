# ============================================================
# Day 16 - Figure 4: Final Variable-Gene Heatmap
# ============================================================

options(stringsAsFactors = FALSE)

library(ggplot2)

# ------------------------------------------------------------
# 1. Paths
# ------------------------------------------------------------

expression_file <- "results/day14/day14_specimen_mean_logCPM.csv"
metadata_file <- "results/day14/day14_specimen_metadata.csv"

output_dir <- "results/day16/figure4"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Read finalized Day 14 specimen-level data
# ------------------------------------------------------------

expression <- read.csv(
  expression_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

metadata <- read.csv(
  metadata_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# ------------------------------------------------------------
# 3. Validate inputs
# ------------------------------------------------------------

stopifnot("Geneid" %in% colnames(expression))
stopifnot("gene_name" %in% colnames(expression))
stopifnot("specimen_id" %in% colnames(metadata))

specimen_columns <- setdiff(
  colnames(expression),
  c("Geneid", "gene_name")
)

if (length(specimen_columns) != 16) {
  stop("Expected 16 specimen columns; found ", length(specimen_columns))
}

if (nrow(expression) != 26892) {
  stop("Expected 26,892 genes; found ", nrow(expression))
}

if (nrow(metadata) != 16) {
  stop("Expected 16 specimens in metadata; found ", nrow(metadata))
}

if (length(unique(expression$Geneid)) != nrow(expression)) {
  stop("Geneid values are not unique.")
}

if (!setequal(specimen_columns, metadata$specimen_id)) {
  stop("Expression specimen IDs and metadata specimen IDs do not match.")
}

expression_matrix <- as.matrix(
  expression[, specimen_columns, drop = FALSE]
)

storage.mode(expression_matrix) <- "numeric"

if (anyNA(expression_matrix)) {
  stop("Expression matrix contains missing values.")
}

if (any(!is.finite(expression_matrix))) {
  stop("Expression matrix contains non-finite values.")
}

# ------------------------------------------------------------
# 4. Calculate gene-wise variance across 16 specimens
# ------------------------------------------------------------

gene_variance <- apply(
  expression_matrix,
  1,
  var
)

if (anyNA(gene_variance)) {
  stop("Gene variance calculation produced missing values.")
}

# Select top 500 most variable genes
top_n <- min(500, length(gene_variance))

top_indices <- order(
  gene_variance,
  decreasing = TRUE
)[seq_len(top_n)]

top_genes <- expression[top_indices, c("Geneid", "gene_name")]

top_genes$variance_logCPM <- gene_variance[top_indices]

# ------------------------------------------------------------
# 5. Create top-500 expression matrix
# ------------------------------------------------------------

heatmap_matrix <- expression_matrix[top_indices, , drop = FALSE]

# Z-score each gene across the 16 specimens
heatmap_z <- t(
  scale(t(heatmap_matrix), center = TRUE, scale = TRUE)
)

rownames(heatmap_z) <- expression$gene_name[top_indices]

# Make duplicated/empty gene names identifiable
gene_labels <- expression$gene_name[top_indices]

missing_names <- is.na(gene_labels) | gene_labels == ""

gene_labels[missing_names] <- expression$Geneid[top_indices][missing_names]

gene_labels <- make.unique(gene_labels)

rownames(heatmap_z) <- gene_labels

# ------------------------------------------------------------
# 6. Order specimens by patient and tissue site
# ------------------------------------------------------------

metadata_ordered <- metadata[
  match(specimen_columns, metadata$specimen_id),
  ,
  drop = FALSE
]

if (anyNA(metadata_ordered$specimen_id)) {
  stop("Failed to match specimen metadata.")
}

patient_order <- order(
  metadata_ordered$`Patient #`,
  metadata_ordered$`Tissue Site`,
  metadata_ordered$specimen_id
)

metadata_ordered <- metadata_ordered[patient_order, , drop = FALSE]

heatmap_z <- heatmap_z[, metadata_ordered$specimen_id, drop = FALSE]

# ------------------------------------------------------------
# 7. Save top-500 gene table
# ------------------------------------------------------------

write.csv(
  top_genes,
  file.path(output_dir, "day16_figure4_top500_variable_genes.csv"),
  row.names = FALSE
)

# ------------------------------------------------------------
# 8. Save heatmap matrix
# ------------------------------------------------------------

heatmap_output <- data.frame(
  Geneid = expression$Geneid[top_indices],
  gene_name = gene_labels,
  heatmap_z,
  check.names = FALSE
)

write.csv(
  heatmap_output,
  file.path(output_dir, "day16_figure4_heatmap_matrix.csv"),
  row.names = FALSE
)

# ------------------------------------------------------------
# 9. Save specimen annotation
# ------------------------------------------------------------

write.csv(
  metadata_ordered,
  file.path(output_dir, "day16_figure4_specimen_annotation.csv"),
  row.names = FALSE
)

# ------------------------------------------------------------
# 10. Create heatmap
# ------------------------------------------------------------

heatmap_long <- as.data.frame(heatmap_z)

heatmap_long$gene_name <- rownames(heatmap_long)

heatmap_long <- reshape(
  heatmap_long,
  varying = metadata_ordered$specimen_id,
  v.names = "z_score",
  timevar = "specimen_id",
  times = metadata_ordered$specimen_id,
  direction = "long"
)

heatmap_long$specimen_id <- factor(
  heatmap_long$specimen_id,
  levels = metadata_ordered$specimen_id
)

heatmap_long$gene_name <- factor(
  heatmap_long$gene_name,
  levels = rev(rownames(heatmap_z))
)

heatmap_plot <- ggplot(
  heatmap_long,
  aes(
    x = specimen_id,
    y = gene_name,
    fill = z_score
  )
) +
  geom_tile() +
  labs(
    title = "Top 500 Most Variable Genes Across Specimens",
    subtitle = "Gene-wise variance selected from the finalized 16-specimen expression matrix",
    x = "Specimen",
    y = "Gene",
    fill = "Z-score"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.5,
      size = 7
    ),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.grid = element_blank()
  )

ggsave(
  filename = file.path(
    output_dir,
    "day16_figure4_variable_gene_heatmap.png"
  ),
  plot = heatmap_plot,
  width = 10,
  height = 14,
  dpi = 300
)

# ------------------------------------------------------------
# 11. Session information
# ------------------------------------------------------------

writeLines(
  capture.output(sessionInfo()),
  file.path(output_dir, "day16_figure4_session_info.txt")
)

# ------------------------------------------------------------
# 12. Completion message
# ------------------------------------------------------------

cat("Day 16 Figure 4 completed.\n")
cat("Genes in finalized matrix:", nrow(expression), "\n")
cat("Specimens:", length(specimen_columns), "\n")
cat("Variable genes selected:", top_n, "\n")
cat(
  "Heatmap:",
  file.path(
    output_dir,
    "day16_figure4_variable_gene_heatmap.png"
  ),
  "\n"
)
cat("Outputs written to:", output_dir, "\n")