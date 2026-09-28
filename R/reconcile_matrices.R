pe <- read.csv(
  gzfile("data/raw/GSE316391_counts_PE.csv.gz"),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

gx <- read.csv(
  gzfile("data/raw/GSE316391_RNA_counts_Met_plus_GTEX.csv.gz"),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Remove verified duplicate gene records in memory only
gx <- gx[!duplicated(gx$Geneid), ]

# Align GTEx-inclusive rows to the PE gene-ID order
gx <- gx[match(pe$Geneid, gx$Geneid), ]

cat("PE rows:", nrow(pe), "\n")
cat("GTEx rows after deduplication:", nrow(gx), "\n")
cat("Gene IDs aligned:",
    identical(pe$Geneid, gx$Geneid), "\n")

pe_names <- names(pe)[8:39]
gx_names <- names(gx)[8:39]

comparison <- do.call(rbind, lapply(seq_along(pe_names), function(i) {
  a <- pe[[pe_names[i]]]
  b <- gx[[gx_names[i]]]

  data.frame(
    PE_sample = pe_names[i],
    GTEx_sample = gx_names[i],
    identical = identical(a, b),
    differing_genes = sum(a != b),
    PE_total = sum(a),
    GTEx_total = sum(b)
  )
}))

cat("\n=== ID-aligned count comparison ===\n")
print(comparison, row.names = FALSE)

cat("\nAll 32 count vectors identical:",
    all(comparison$identical), "\n")

cat("\nTotal differing sample-gene entries:",
    sum(comparison$differing_genes), "\n")
