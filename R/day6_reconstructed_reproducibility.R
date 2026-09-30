# Day 6: Descriptive expression review and annotation checks
# Reconstructed during the Day 12 reproducibility audit from the
# documented Day 6 methods and surviving Day 5 expression summary.
#
# This is a reconstructed reproducibility script, not a claim that
# this file is the original historical Day 6 script.

input_file <- "results/day5/day5_gene_expression_summary.csv"
out_dir <- "results/day6"

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

day5 <- read.csv(
  input_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

required_columns <- c(
  "Geneid",
  "gene_name",
  "mean_logCPM",
  "median_logCPM",
  "sd_logCPM",
  "variance_logCPM"
)

missing_columns <- setdiff(required_columns, colnames(day5))

if (length(missing_columns) > 0) {
  stop(
    "Missing required columns: ",
    paste(missing_columns, collapse = ", ")
  )
}

if (anyDuplicated(day5$Geneid) > 0) {
  stop("Duplicate Ensembl Gene IDs detected in Day 5 summary.")
}

if (any(is.na(day5$Geneid))) {
  stop("Missing Ensembl Gene IDs detected.")
}

if (any(is.na(day5$gene_name))) {
  stop("Missing gene symbols detected.")
}

if (any(is.na(day5$variance_logCPM))) {
  stop("Missing variance values detected.")
}

# Top 20 genes by variance in log2-CPM.
top20 <- day5[
  order(-day5$variance_logCPM),
  required_columns
]

top20 <- head(top20, 20)

# Annotation checks.
nonempty_symbols <- day5$gene_name[
  !is.na(day5$gene_name) & day5$gene_name != ""
]

symbol_counts <- table(nonempty_symbols)

unique_nonempty_symbols <- length(unique(nonempty_symbols))

repeated_symbol_count <- sum(symbol_counts[symbol_counts > 1] - 1)

most_frequent_symbol <- names(symbol_counts)[
  which.max(symbol_counts)
]

most_frequent_symbol_count <- max(symbol_counts)

missing_symbol_count <- sum(
  is.na(day5$gene_name) | day5$gene_name == ""
)

top20_symbol_counts <- table(top20$gene_name)

top20_duplicated_symbols <- names(
  top20_symbol_counts[top20_symbol_counts > 1]
)

# Write reproducibility outputs.
write.csv(
  top20,
  file.path(out_dir, "day6_top20_variable_genes.csv"),
  row.names = FALSE
)

annotation_summary <- data.frame(
  Libraries_reviewed = 32,
  Genes_retained = nrow(day5),
  Missing_gene_symbols = missing_symbol_count,
  Unique_nonempty_gene_symbols = unique_nonempty_symbols,
  Repeated_gene_symbols_beyond_first_occurrence = repeated_symbol_count,
  Most_frequent_symbol = most_frequent_symbol,
  Most_frequent_symbol_count = most_frequent_symbol_count,
  Top20_duplicated_symbol_count = length(top20_duplicated_symbols),
  stringsAsFactors = FALSE
)

write.csv(
  annotation_summary,
  file.path(out_dir, "day6_annotation_summary.csv"),
  row.names = FALSE
)

write.csv(
  data.frame(
    gene_name = top20_duplicated_symbols,
    stringsAsFactors = FALSE
  ),
  file.path(out_dir, "day6_top20_duplicated_symbols.csv"),
  row.names = FALSE
)

writeLines(
  capture.output(sessionInfo()),
  file.path(out_dir, "day6_session_info.txt")
)

cat("Day 6 reconstructed reproducibility analysis completed.\n")
cat("Libraries reviewed:", 32, "\n")
cat("Genes retained:", nrow(day5), "\n")
cat("Missing gene symbols:", missing_symbol_count, "\n")
cat("Unique non-empty gene symbols:", unique_nonempty_symbols, "\n")
cat(
  "Repeated gene symbols beyond first occurrence:",
  repeated_symbol_count,
  "\n"
)
cat(
  "Most frequent symbol:",
  most_frequent_symbol,
  "(",
  most_frequent_symbol_count,
  "occurrences)\n"
)
cat(
  "Duplicated symbols among top 20 variable genes:",
  length(top20_duplicated_symbols),
  "\n"
)
cat("Outputs written to:", out_dir, "\n")
