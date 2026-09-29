# Day 5: Descriptive gene-expression summaries
# Scope: exploratory and descriptive only.
# No differential expression, inferential tissue comparisons,
# causal claims, or clinical biomarker claims.

suppressPackageStartupMessages({
  library(edgeR)
})

# 1. Input and output paths
counts_file <- "data/raw/GSE316391_counts_PE.csv.gz"
out_dir <- "results/day5"

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 2. Read and validate the PE count matrix
raw <- read.csv(
  gzfile(counts_file),
  check.names = FALSE
)

stopifnot(nrow(raw) == 62703)
stopifnot(ncol(raw) == 39)
stopifnot(!anyDuplicated(raw$Geneid))

gene_annotation <- raw[, 1:7, drop = FALSE]
library_ids <- names(raw)[8:39]
count_data <- raw[, 8:39, drop = FALSE]

stopifnot(all(vapply(count_data, is.numeric, logical(1))))
stopifnot(!anyNA(count_data))
stopifnot(all(as.matrix(count_data) >= 0))

count_matrix <- as.matrix(count_data)
rownames(count_matrix) <- raw$Geneid
storage.mode(count_matrix) <- "numeric"

# 3. Filter and normalize using the established Day 4 workflow
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

stopifnot(nrow(log_cpm) == sum(keep))
stopifnot(ncol(log_cpm) == 32)

# 4. Descriptive library-level expression summaries
library_summary <- data.frame(
  library_id = library_ids,
  raw_library_size = colSums(count_matrix),
  tmm_normalization_factor = y$samples$norm.factors,
  effective_library_size =
    y$samples$lib.size * y$samples$norm.factors,
  genes_retained = nrow(log_cpm),
  median_logCPM = apply(log_cpm, 2, median),
  mean_logCPM = colMeans(log_cpm),
  sd_logCPM = apply(log_cpm, 2, sd),
  stringsAsFactors = FALSE
)

write.csv(
  library_summary,
  file.path(out_dir, "day5_library_expression_summary.csv"),
  row.names = FALSE
)

# 5. Descriptive gene-level expression summaries
gene_summary <- data.frame(
  Geneid = rownames(log_cpm),
  mean_logCPM = rowMeans(log_cpm),
  median_logCPM = apply(log_cpm, 1, median),
  sd_logCPM = apply(log_cpm, 1, sd),
  variance_logCPM = apply(log_cpm, 1, var),
  stringsAsFactors = FALSE
)

gene_summary <- merge(
  gene_annotation[, c("Geneid", "gene_name")],
  gene_summary,
  by = "Geneid",
  all.y = TRUE,
  sort = FALSE
)

write.csv(
  gene_summary,
  file.path(out_dir, "day5_gene_expression_summary.csv"),
  row.names = FALSE
)

# 6. Descriptive overall expression distribution
distribution_summary <- data.frame(
  metric = c(
    "Number of libraries",
    "Number of genes retained",
    "Minimum library median logCPM",
    "Median library median logCPM",
    "Maximum library median logCPM",
    "Minimum gene mean logCPM",
    "Median gene mean logCPM",
    "Maximum gene mean logCPM"
  ),
  value = c(
    ncol(log_cpm),
    nrow(log_cpm),
    min(library_summary$median_logCPM),
    median(library_summary$median_logCPM),
    max(library_summary$median_logCPM),
    min(gene_summary$mean_logCPM),
    median(gene_summary$mean_logCPM),
    max(gene_summary$mean_logCPM)
  )
)

write.csv(
  distribution_summary,
  file.path(out_dir, "day5_overall_distribution_summary.csv"),
  row.names = FALSE
)

# 7. Save a reproducibility summary
capture.output(
  sessionInfo(),
  file = file.path(out_dir, "day5_session_info.txt")
)

cat("Day 5 descriptive expression summaries completed.\n")
cat("Libraries:", ncol(log_cpm), "\n")
cat("Genes retained:", nrow(log_cpm), "\n")
cat("Outputs written to:", out_dir, "\n")