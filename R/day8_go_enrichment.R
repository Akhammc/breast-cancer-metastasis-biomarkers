suppressPackageStartupMessages({
  library(AnnotationDbi)
  library(org.Hs.eg.db)
  library(clusterProfiler)
})

# 1. Read the selected gene set and eligible background
selected <- read.csv(
  "results/day4/day4_selected_variable_genes.csv",
  stringsAsFactors = FALSE
)$Geneid

universe <- read.csv(
  "results/day5/day5_gene_expression_summary.csv",
  stringsAsFactors = FALSE
)$Geneid

# Remove Ensembl version suffixes, if present
selected <- sub("\\.[0-9]+$", "", selected)
universe <- sub("\\.[0-9]+$", "", universe)

# 2. Map Ensembl IDs to Entrez IDs
# Retain one mapping per Ensembl ID, then deduplicate Entrez IDs
map_genes <- function(ids) {
  mapping <- AnnotationDbi::select(
    org.Hs.eg.db,
    keys = unique(ids),
    keytype = "ENSEMBL",
    columns = "ENTREZID"
  )

  mapping <- mapping[
    !is.na(mapping$ENTREZID),
    c("ENSEMBL", "ENTREZID")
  ]

  mapping <- unique(mapping)

  # Exclude Ensembl IDs mapping to multiple distinct Entrez IDs
  mapping_counts <- table(mapping$ENSEMBL)
  unambiguous_ids <- names(mapping_counts[mapping_counts == 1])

  mapping <- mapping[mapping$ENSEMBL %in% unambiguous_ids, ]

  unique(mapping$ENTREZID)
}

selected_entrez <- map_genes(selected)
universe_entrez <- map_genes(universe)

# Restrict selected IDs to the defined background
selected_entrez <- intersect(
  selected_entrez,
  universe_entrez
)

stopifnot(length(selected_entrez) > 0)
stopifnot(length(universe_entrez) > 0)
stopifnot(all(selected_entrez %in% universe_entrez))

# 3. Run exploratory GO Biological Process ORA
ego <- enrichGO(
  gene = selected_entrez,
  universe = universe_entrez,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 1,
  qvalueCutoff = 1,
  minGSSize = 10,
  maxGSSize = 500,
  readable = TRUE
)

# 4. Create output directory
out_dir <- "results/enrichment"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 5. Save results and analysis metadata
write.csv(
  as.data.frame(ego),
  file.path(out_dir, "day8_go_bp_ora.csv"),
  row.names = FALSE
)

metadata <- data.frame(
  metric = c(
    "selected_ensembl_count",
    "background_ensembl_count",
    "selected_unique_entrez_count",
    "background_unique_entrez_count",
    "GO_ontology",
    "adjustment_method",
    "minimum_gene_set_size",
    "maximum_gene_set_size",
    "clusterProfiler_version",
    "org.Hs.eg.db_version",
    "AnnotationDbi_version",
    "R_version"
  ),
  value = c(
    length(unique(selected)),
    length(unique(universe)),
    length(selected_entrez),
    length(universe_entrez),
    "BP",
    "Benjamini-Hochberg",
    10,
    500,
    as.character(packageVersion("clusterProfiler")),
    as.character(packageVersion("org.Hs.eg.db")),
    as.character(packageVersion("AnnotationDbi")),
    R.version.string
  )
)

write.csv(
  metadata,
  file.path(out_dir, "day8_go_bp_ora_metadata.csv"),
  row.names = FALSE
)

writeLines(
  capture.output(sessionInfo()),
  file.path(out_dir, "day8_go_bp_session_info.txt")
)

cat("Selected Entrez IDs:", length(selected_entrez), "\n")
cat("Background Entrez IDs:", length(universe_entrez), "\n")
cat("GO BP terms returned:", nrow(as.data.frame(ego)), "\n")
cat("Results written to:", out_dir, "\n")