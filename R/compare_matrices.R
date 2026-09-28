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

# Verify gene identifiers and row order
cat("PE rows:", nrow(pe), "\n")
cat("GTEx rows:", nrow(gx), "\n")
cat("Gene IDs identical and in same order:",
    identical(pe$Geneid, gx$Geneid), "\n")

# Define the expected mapping from PE columns to GTEx tumor columns
pe_names <- names(pe)[8:39]
gx_names <- names(gx)[8:39]

cat("\nPE tumor columns:", length(pe_names), "\n")
cat("GTEx tumor columns:", length(gx_names), "\n")

# Map each PE sample to its corresponding GTEx tumor column
map <- data.frame(
  PE = pe_names,
  GTEx = gx_names,
  stringsAsFactors = FALSE
)

cat("\nSample mapping:\n")
print(map, row.names = FALSE)

# Compare the actual counts for each mapped sample
results <- lapply(seq_len(nrow(map)), function(i) {
  a <- pe[[map$PE[i]]]
  b <- gx[[map$GTEx[i]]]

  data.frame(
    PE_sample = map$PE[i],
    GTEx_sample = map$GTEx[i],
    identical = identical(a, b),
    differing_genes = sum(a != b, na.rm = TRUE),
    PE_total = sum(a, na.rm = TRUE),
    GTEx_total = sum(b, na.rm = TRUE)
  )
})

comparison <- do.call(rbind, results)

cat("\nCount comparison summary:\n")
print(comparison, row.names = FALSE)

cat("\nOverall all tumor count vectors identical:",
    all(comparison$identical), "\n")
