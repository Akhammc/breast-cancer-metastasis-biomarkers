# ============================================================
# Day 16 - Figure 3: Specimen Distance Heatmap
# ============================================================

options(stringsAsFactors = FALSE)

library(ggplot2)

# ------------------------------------------------------------
# 1. Paths
# ------------------------------------------------------------

expression_file <- "results/day14/day14_specimen_mean_logCPM.csv"
metadata_file <- "results/day14/day14_specimen_metadata.csv"

output_dir <- "results/day16/figure3"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Read finalized Day 14 specimen-level data
# ------------------------------------------------------------

expression <- read.csv(
  expression_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

metadata <- read.csv(
  metadata_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# ------------------------------------------------------------
# 3. Validate inputs
# ------------------------------------------------------------

stopifnot("Geneid" %in% colnames(expression))
stopifnot("gene_name" %in% colnames(expression))
stopifnot("specimen_id" %in% colnames(metadata))

specimen_columns <- setdiff(
  colnames(expression),
  c("Geneid", "gene_name")
)

if (length(specimen_columns) != 16) {
  stop("Expected 16 specimen columns; found ", length(specimen_columns))
}

if (nrow(expression) != 26892) {
  stop("Expected 26,892 genes; found ", nrow(expression))
}

if (nrow(metadata) != 16) {
  stop("Expected 16 specimens in metadata; found ", nrow(metadata))
}

if (length(unique(expression$Geneid)) != nrow(expression)) {
  stop("Geneid values are not unique.")
}

if (!setequal(specimen_columns, metadata$specimen_id)) {
  stop("Expression specimen IDs and metadata specimen IDs do not match.")
}

expression_matrix <- as.matrix(
  expression[, specimen_columns, drop = FALSE]
)

storage.mode(expression_matrix) <- "numeric"

if (anyNA(expression_matrix)) {
  stop("Expression matrix contains missing values.")
}

if (any(!is.finite(expression_matrix))) {
  stop("Expression matrix contains non-finite values.")
}

# ------------------------------------------------------------
# 4. Calculate specimen-to-specimen Euclidean distances
# ------------------------------------------------------------

distance_matrix <- as.matrix(
  dist(
    t(expression_matrix),
    method = "euclidean"
  )
)

rownames(distance_matrix) <- specimen_columns
colnames(distance_matrix) <- specimen_columns

# ------------------------------------------------------------
# 5. Validate distance matrix
# ------------------------------------------------------------

if (!all(dim(distance_matrix) == c(16, 16))) {
  stop("Distance matrix is not 16 x 16.")
}

if (anyNA(distance_matrix)) {
  stop("Distance matrix contains missing values.")
}

if (any(!is.finite(distance_matrix))) {
  stop("Distance matrix contains non-finite values.")
}

if (!isTRUE(all.equal(
  distance_matrix,
  t(distance_matrix),
  tolerance = 1e-10
))) {
  stop("Distance matrix is not symmetric.")
}

if (any(abs(diag(distance_matrix)) > 1e-8)) {
  stop("Distance matrix diagonal is not zero within tolerance.")
}

# ------------------------------------------------------------
# 6. Order specimens by patient and tissue site
# ------------------------------------------------------------

metadata_ordered <- metadata[
  match(specimen_columns, metadata$specimen_id),
  ,
  drop = FALSE
]

if (anyNA(metadata_ordered$specimen_id)) {
  stop("Failed to match specimen metadata.")
}

patient_order <- order(
  metadata_ordered$`Patient #`,
  metadata_ordered$`Tissue Site`,
  metadata_ordered$specimen_id
)

metadata_ordered <- metadata_ordered[
  patient_order,
  ,
  drop = FALSE
]

ordered_specimens <- metadata_ordered$specimen_id

distance_matrix_ordered <- distance_matrix[
  ordered_specimens,
  ordered_specimens,
  drop = FALSE
]

# ------------------------------------------------------------
# 7. Save distance matrix
# ------------------------------------------------------------

distance_output <- data.frame(
  specimen_id = rownames(distance_matrix_ordered),
  distance_matrix_ordered,
  check.names = FALSE
)

write.csv(
  distance_output,
  file.path(
    output_dir,
    "day16_figure3_specimen_distance_matrix.csv"
  ),
  row.names = FALSE
)

# ------------------------------------------------------------
# 8. Save specimen annotation
# ------------------------------------------------------------

write.csv(
  metadata_ordered,
  file.path(
    output_dir,
    "day16_figure3_specimen_annotation.csv"
  ),
  row.names = FALSE
)

# ------------------------------------------------------------
# 9. Convert distance matrix to long format
# ------------------------------------------------------------

distance_long <- as.data.frame(
  as.table(distance_matrix_ordered),
  stringsAsFactors = FALSE
)

colnames(distance_long) <- c(
  "specimen_x",
  "specimen_y",
  "distance"
)

distance_long$specimen_x <- factor(
  distance_long$specimen_x,
  levels = ordered_specimens
)

distance_long$specimen_y <- factor(
  distance_long$specimen_y,
  levels = rev(ordered_specimens)
)

# ------------------------------------------------------------
# 10. Create specimen distance heatmap
# ------------------------------------------------------------

distance_plot <- ggplot(
  distance_long,
  aes(
    x = specimen_x,
    y = specimen_y,
    fill = distance
  )
) +
  geom_tile() +
  labs(
    title = "Specimen Pairwise Expression Distance",
    subtitle = "Euclidean distances calculated from the finalized 16-specimen expression matrix",
    x = "Specimen",
    y = "Specimen",
    fill = "Euclidean distance"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.5,
      size = 7
    ),
    axis.text.y = element_text(
      size = 7
    ),
    panel.grid = element_blank()
  )

ggsave(
  filename = file.path(
    output_dir,
    "day16_figure3_specimen_distance_heatmap.png"
  ),
  plot = distance_plot,
  width = 10,
  height = 9,
  dpi = 300
)

# ------------------------------------------------------------
# 11. Save session information
# ------------------------------------------------------------

writeLines(
  capture.output(sessionInfo()),
  file.path(
    output_dir,
    "day16_figure3_session_info.txt"
  )
)

# ------------------------------------------------------------
# 12. Completion message
# ------------------------------------------------------------

cat("Day 16 Figure 3 completed.\n")
cat("Genes used:", nrow(expression), "\n")
cat("Specimens:", length(specimen_columns), "\n")
cat("Distance matrix:", nrow(distance_matrix), "x", ncol(distance_matrix), "\n")
cat(
  "Heatmap:",
  file.path(
    output_dir,
    "day16_figure3_specimen_distance_heatmap.png"
  ),
  "\n"
)
cat("Outputs written to:", output_dir, "\n")