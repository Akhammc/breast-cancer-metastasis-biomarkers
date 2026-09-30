# Day 9: Descriptive GO term redundancy review
# Uses Day 8 GO BP ORA results; does not rerun enrichment.

input_file <- "results/enrichment/day8/day8_go_bp_ora.csv"
out_dir <- "results/enrichment/day9"

results <- read.csv(input_file, stringsAsFactors = FALSE)

significant <- results[
  !is.na(results$p.adjust) & results$p.adjust < 0.05,
]

# Parse the Entrez-derived readable gene symbols listed by clusterProfiler
gene_sets <- strsplit(significant$geneID, "/", fixed = TRUE)
names(gene_sets) <- significant$ID

n <- length(gene_sets)

overlap_rows <- list()
k <- 1

if (n >= 2) {
  for (i in seq_len(n - 1)) {
    for (j in (i + 1):n) {
      a <- unique(gene_sets[[i]])
      b <- unique(gene_sets[[j]])

      shared <- intersect(a, b)
      union_genes <- union(a, b)

      jaccard <- if (length(union_genes) > 0) {
        length(shared) / length(union_genes)
      } else {
        NA_real_
      }

      overlap_rows[[k]] <- data.frame(
        GO_ID_1 = significant$ID[i],
        Description_1 = significant$Description[i],
        GO_ID_2 = significant$ID[j],
        Description_2 = significant$Description[j],
        Shared_gene_count = length(shared),
        Jaccard_similarity = jaccard,
        Shared_genes = paste(sort(shared), collapse = "/"),
        stringsAsFactors = FALSE
      )

      k <- k + 1
    }
  }
}

if (length(overlap_rows) > 0) {
  overlap_table <- do.call(rbind, overlap_rows)
  overlap_table <- overlap_table[
    order(-overlap_table$Jaccard_similarity,
          -overlap_table$Shared_gene_count),
  ]

  write.csv(
    overlap_table,
    file.path(out_dir, "day9_go_pairwise_overlap.csv"),
    row.names = FALSE
  )
}

term_summary <- data.frame(
  ID = significant$ID,
  Description = significant$Description,
  Count = significant$Count,
  p.adjust = significant$p.adjust,
  GeneRatio = significant$GeneRatio,
  stringsAsFactors = FALSE
)

write.csv(
  term_summary,
  file.path(out_dir, "day9_go_significant_terms.csv"),
  row.names = FALSE
)

cat("Significant GO BP terms:", nrow(significant), "\n")
cat("Pairwise comparisons:", length(overlap_rows), "\n")
cat("Outputs written to:", out_dir, "\n")
