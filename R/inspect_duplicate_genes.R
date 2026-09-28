gx <- read.csv(
  gzfile("data/raw/GSE316391_RNA_counts_Met_plus_GTEX.csv.gz"),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Identify all rows with duplicated Ensembl gene IDs
dup_ids <- unique(gx$Geneid[duplicated(gx$Geneid) |
                            duplicated(gx$Geneid, fromLast = TRUE)])

cat("Number of duplicated gene IDs:", length(dup_ids), "\n")
cat("Number of rows involved:", sum(gx$Geneid %in% dup_ids), "\n")

# Show the duplicated rows, including annotations and three tumor counts
dup_rows <- gx[gx$Geneid %in% dup_ids,
               c("gene_name", "Geneid", "Chr", "Start",
                 "End", "Strand", "Length", names(gx)[8:10])]

cat("\n=== Duplicated gene records ===\n")
print(dup_rows, row.names = FALSE)

# Check whether the duplicated rows have identical annotations
cat("\n=== Annotation consistency within duplicated IDs ===\n")

for (id in dup_ids) {
  z <- gx[gx$Geneid == id, ]
  if (nrow(z) > 1) {
    cat(
      id,
      "| rows:", nrow(z),
      "| identical annotations:",
      all(vapply(
        z[, 1:7, drop = FALSE],
        function(x) length(unique(x)) == 1,
        logical(1)
      )),
      "| identical counts in first tumor:",
      length(unique(z[[8]])) == 1,
      "\n"
    )
  }
}
