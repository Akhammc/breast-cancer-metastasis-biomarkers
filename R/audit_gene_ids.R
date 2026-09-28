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

cat("=== PE gene annotation columns ===\n")
print(names(pe)[1:7])

cat("\n=== GTEx gene annotation columns ===\n")
print(names(gx)[1:7])

cat("\n=== First 10 gene IDs: PE ===\n")
print(head(pe$Geneid, 10))

cat("\n=== First 10 gene IDs: GTEx ===\n")
print(head(gx$Geneid, 10))

cat("\n=== Gene ID integrity ===\n")
cat("PE missing IDs:", sum(is.na(pe$Geneid)), "\n")
cat("GTEx missing IDs:", sum(is.na(gx$Geneid)), "\n")
cat("PE duplicated IDs:", sum(duplicated(pe$Geneid)), "\n")
cat("GTEx duplicated IDs:", sum(duplicated(gx$Geneid)), "\n")
cat("IDs shared:", length(intersect(pe$Geneid, gx$Geneid)), "\n")
cat("IDs only in PE:", length(setdiff(pe$Geneid, gx$Geneid)), "\n")
cat("IDs only in GTEx:", length(setdiff(gx$Geneid, pe$Geneid)), "\n")

cat("\n=== First 20 PE-only IDs ===\n")
print(head(setdiff(pe$Geneid, gx$Geneid), 20))

cat("\n=== First 20 GTEx-only IDs ===\n")
print(head(setdiff(gx$Geneid, pe$Geneid), 20))

cat("\n=== Data types of first tumor columns ===\n")
str(pe[, 8:10])
str(gx[, 8:10])

cat("\n=== Import warnings ===\n")
print(warnings())
