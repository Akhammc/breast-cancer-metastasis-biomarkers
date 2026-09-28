# Day 3: patient-level comparison feasibility
# Descriptive inventory only. No differential expression.

library(readxl)
library(dplyr)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

rna <- read_excel(file, sheet = "RNA-seq")

specimens <- rna %>%
  distinct(
    `Patient #`,
    `Tissue Site`,
    `Container ID`,
    `Internal Case ID`
  )

patients <- sort(unique(specimens$`Patient #`))

cat("\n=== Patient-level tissue availability ===\n")

availability <- specimens %>%
  mutate(
    Tissue = case_when(
      `Tissue Site` == "Breast" ~ "Breast",
      `Tissue Site` == "Liver/Bile Duct" ~ "Liver",
      `Tissue Site` == "Lung" ~ "Lung",
      TRUE ~ as.character(`Tissue Site`)
    )
  ) %>%
  select(`Patient #`, Tissue) %>%
  distinct() %>%
  mutate(Present = 1L) %>%
  tidyr::pivot_wider(
    names_from = Tissue,
    values_from = Present,
    values_fill = 0L
  )

print(availability, n = Inf)

cat("\n=== Matched-patient counts ===\n")

if (all(c("Breast", "Liver", "Lung") %in% names(availability))) {
  cat(
    "Breast-Liver:",
    sum(availability$Breast == 1 & availability$Liver == 1),
    "\n"
  )

  cat(
    "Breast-Lung:",
    sum(availability$Breast == 1 & availability$Lung == 1),
    "\n"
  )

  cat(
    "Liver-Lung:",
    sum(availability$Liver == 1 & availability$Lung == 1),
    "\n"
  )

  cat(
    "Breast with either metastatic site:",
    sum(
      availability$Breast == 1 &
        (availability$Liver == 1 | availability$Lung == 1)
    ),
    "\n"
  )
}