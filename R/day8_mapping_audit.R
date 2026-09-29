suppressPackageStartupMessages({
  library(AnnotationDbi)
  library(org.Hs.eg.db)
})

selected <- read.csv(
  "results/day4/day4_selected_variable_genes.csv",
  stringsAsFactors = FALSE
)$Geneid

universe <- read.csv(
  "results/day5/day5_gene_expression_summary.csv",
  stringsAsFactors = FALSE
)$Geneid

selected <- sub("\\.[0-9]+$", "", selected)
universe <- sub("\\.[0-9]+$", "", universe)

mapped_selected <- mapIds(
  org.Hs.eg.db,
  keys = unique(selected),
  keytype = "ENSEMBL",
  column = "ENTREZID",
  multiVals = "first"
)

mapped_universe <- mapIds(
  org.Hs.eg.db,
  keys = unique(universe),
  keytype = "ENSEMBL",
  column = "ENTREZID",
  multiVals = "first"
)

cat("Selected genes:", length(unique(selected)), "\n")
cat("Selected genes mapped:", sum(!is.na(mapped_selected)), "\n")
cat("Unique selected Entrez IDs:",
    length(unique(na.omit(mapped_selected))), "\n")

cat("Background genes:", length(unique(universe)), "\n")
cat("Background genes mapped:", sum(!is.na(mapped_universe)), "\n")
cat("Unique background Entrez IDs:",
    length(unique(na.omit(mapped_universe))), "\n")