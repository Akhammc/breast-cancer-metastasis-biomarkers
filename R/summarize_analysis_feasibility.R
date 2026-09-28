library(readxl)
library(dplyr)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

rna <- read_excel(file, sheet = "RNA-seq")

specimens <- rna %>%
  group_by(`Patient #`, `Tissue Site`, `Container ID`, `Internal Case ID`) %>%
  summarise(
    N_libraries = n(),
    Library_names = paste(`RNA-seq name`, collapse = "; "),
    .groups = "drop"
  )

cat("\n=== Specimen counts by tissue ===\n")
print(
  specimens %>%
    count(`Tissue Site`, name = "N_specimens"),
  n = Inf
)

cat("\n=== Specimen counts by patient and tissue ===\n")
print(
  specimens %>%
    count(`Patient #`, `Tissue Site`, name = "N_specimens"),
  n = Inf
)

cat("\n=== Libraries per specimen ===\n")
print(
  specimens %>%
    count(N_libraries, name = "N_specimens"),
  n = Inf
)

cat("\n=== Complete specimen-level inventory ===\n")
print(specimens, n = Inf, width = Inf)