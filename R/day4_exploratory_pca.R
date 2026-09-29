# Day 4: Exploratory PCA and sample-distance visualization
# Scope: descriptive exploration only; no differential expression or inference.

suppressPackageStartupMessages({
  library(readxl)
  library(edgeR)
  library(ggplot2)
})

counts_file <- "data/raw/GSE316391_counts_PE.csv.gz"
workbook_file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"
out_dir <- "results/day4"

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 1. Read count matrix and identify expression columns
raw <- read.csv(gzfile(counts_file), check.names = FALSE)

stopifnot(nrow(raw) == 62703)
stopifnot(ncol(raw) == 39)
stopifnot(!anyDuplicated(raw$Geneid))

library_ids <- names(raw)[8:39]
count_data <- raw[, 8:39, drop = FALSE]

stopifnot(all(vapply(count_data, is.numeric, logical(1))))
stopifnot(!anyNA(count_data))
stopifnot(all(as.matrix(count_data) >= 0))

count_matrix <- as.matrix(count_data)
rownames(count_matrix) <- raw$Geneid
storage.mode(count_matrix) <- "numeric"

# 2. Read and validate library-to-specimen metadata
meta <- as.data.frame(
  read_excel(workbook_file, sheet = "RNA-seq")
)

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

# 3. Filter low-expression genes and perform TMM normalization
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

# 4. Select the 500 most variable genes for visualization
gene_variances <- apply(log_cpm, 1, var)
n_selected <- min(500, length(gene_variances))

selected_genes <- names(
  sort(gene_variances, decreasing = TRUE)
)[seq_len(n_selected)]

selected_expr <- log_cpm[selected_genes, , drop = FALSE]

# 5. PCA across libraries
pca <- prcomp(t(selected_expr), center = TRUE, scale. = FALSE)

variance_pct <- 100 * pca$sdev^2 / sum(pca$sdev^2)

pca_df <- data.frame(
  library_id = library_ids,
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2],
  patient = factor(meta[["Patient #"]]),
  tissue = factor(meta[["Tissue Site"]]),
  specimen_id = meta$specimen_id
)

p_pca <- ggplot(
  pca_df,
  aes(x = PC1, y = PC2, color = tissue, shape = patient)
) +
  scale_shape_manual(values = c(0, 1, 2, 3, 4, 5, 6)) +
  geom_point(size = 3, alpha = 0.85) +
  geom_text(
    aes(label = library_id),
    size = 2.5,
    vjust = -0.8,
    check_overlap = TRUE,
    show.legend = FALSE
  ) +
  labs(
    title = "Exploratory PCA of RNA-seq libraries",
    subtitle = "TMM-normalized logCPM; 500 most variable genes",
    x = paste0("PC1 (", round(variance_pct[1], 1), "% variance)"),
    y = paste0("PC2 (", round(variance_pct[2], 1), "% variance)"),
    color = "Tissue",
    shape = "Patient"
  ) +
  theme_bw(base_size = 11)

ggsave(
  file.path(out_dir, "day4_exploratory_pca.png"),
  p_pca, width = 11, height = 8, dpi = 300
)

# 6. Euclidean sample-distance visualization using the same gene set
sample_dist <- as.matrix(dist(t(selected_expr)))

dist_df <- as.data.frame(as.table(sample_dist))
names(dist_df) <- c("library_x", "library_y", "distance")

dist_df$library_x <- factor(
  dist_df$library_x, levels = library_ids
)
dist_df$library_y <- factor(
  dist_df$library_y, levels = rev(library_ids)
)

p_dist <- ggplot(
  dist_df,
  aes(x = library_x, y = library_y, fill = distance)
) +
  geom_tile() +
  scale_fill_viridis_c(name = "Euclidean\ndistance") +
  labs(
    title = "Exploratory sample-distance heatmap",
    subtitle = "TMM-normalized logCPM; 500 most variable genes",
    x = "Library",
    y = "Library"
  ) +
  theme_bw(base_size = 9) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
    panel.grid = element_blank()
  )

ggsave(
  file.path(out_dir, "day4_sample_distance.png"),
  p_dist, width = 12, height = 11, dpi = 300
)

# 7. Save metadata and descriptive QC summaries
write.csv(
  meta,
  file.path(out_dir, "day4_library_metadata.csv"),
  row.names = FALSE
)

qc_summary <- data.frame(
  library_id = library_ids,
  raw_library_size = colSums(count_matrix),
  tmm_normalization_factor = y$samples$norm.factors,
  effective_library_size = y$samples$lib.size * y$samples$norm.factors,
  retained_genes = nrow(y),
  genes_used_for_visualization = n_selected
)

write.csv(
  qc_summary,
  file.path(out_dir, "day4_library_qc_summary.csv"),
  row.names = FALSE
)

write.csv(
  data.frame(
    Geneid = selected_genes,
    logCPM_variance = gene_variances[selected_genes]
  ),
  file.path(out_dir, "day4_selected_variable_genes.csv"),
  row.names = FALSE
)

write.csv(
  pca_df,
  file.path(out_dir, "day4_pca_coordinates.csv"),
  row.names = FALSE
)

write.csv(
  sample_dist,
  file.path(out_dir, "day4_sample_distance_matrix.csv")
)

cat("Day 4 exploratory analysis completed.\n")
cat("Libraries:", ncol(count_matrix), "\n")
cat("Specimens:", length(unique(meta$specimen_id)), "\n")
cat("Genes retained after CPM filter:", nrow(y), "\n")
cat("Genes used for visualization:", n_selected, "\n")
cat("Outputs written to:", out_dir, "\n")