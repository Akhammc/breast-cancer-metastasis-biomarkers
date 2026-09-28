gx <- read.csv(
  gzfile("data/raw/GSE316391_RNA_counts_Met_plus_GTEX.csv.gz"),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

dup_ids <- unique(gx$Geneid[
  duplicated(gx$Geneid) |
  duplicated(gx$Geneid, fromLast = TRUE)
])

tumor_cols <- names(gx)[8:39]

checks <- lapply(dup_ids, function(id) {
  z <- gx[gx$Geneid == id, tumor_cols, drop = FALSE]

  data.frame(
    Geneid = id,
    identical_all_tumor_counts = nrow(z) == 2 &&
      identical(as.integer(z[1, ]), as.integer(z[2, ])),
    differing_tumor_values = if (nrow(z) == 2) {
      sum(as.integer(z[1, ]) != as.integer(z[2, ]))
    } else {
      NA_integer_
    }
  )
})

checks <- do.call(rbind, checks)

cat("Duplicated IDs checked:", nrow(checks), "\n")
cat("Identical across all 32 tumor libraries:",
    sum(checks$identical_all_tumor_counts), "\n")
cat("Any differing tumor counts:",
    sum(!checks$identical_all_tumor_counts), "\n")

if (any(!checks$identical_all_tumor_counts)) {
  cat("\nExceptions:\n")
  print(checks[!checks$identical_all_tumor_counts, ],
        row.names = FALSE)
}
