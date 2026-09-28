library(readr)
library(dplyr)
library(tidyr)

file <- "results/tables/day3_specimen_eligibility.csv"

x <- read_csv(file, show_col_types = FALSE)

# Normalize the tissue labels
x <- x %>%
  mutate(
    Tissue = case_when(
      `Tissue Site` == "Breast" ~ "Breast",
      `Tissue Site` == "Liver/Bile Duct" ~ "Liver",
      `Tissue Site` == "Lung" ~ "Lung",
      TRUE ~ as.character(`Tissue Site`)
    ),
    Tumor_documented = Tumor_content_category %in%
      c("Documented 50-75%", "Documented 75-99%")
  )

# One row per patient, with tissue presence and documented tumor status
patient_status <- x %>%
  group_by(`Patient #`, Tissue) %>%
  summarise(
    Present = TRUE,
    Tumor_documented = any(Tumor_documented),
    .groups = "drop"
  ) %>%
  pivot_wider(
    names_from = Tissue,
    values_from = c(Present, Tumor_documented),
    values_fill = FALSE
  )

cat("\n=== Patient-level eligibility matrix ===\n")
print(patient_status, n = Inf, width = Inf)

# Helper: safely handle absent tissue columns
has_col <- function(df, name) {
  if (name %in% names(df)) df[[name]] else rep(FALSE, nrow(df))
}

breast <- has_col(patient_status, "Present_Breast")
liver <- has_col(patient_status, "Present_Liver")
lung <- has_col(patient_status, "Present_Lung")

breast_tumor <- has_col(patient_status, "Tumor_documented_Breast")
liver_tumor <- has_col(patient_status, "Tumor_documented_Liver")
lung_tumor <- has_col(patient_status, "Tumor_documented_Lung")

cat("\n=== Eligibility scenario counts ===\n")

cat("Breast-Liver, all matched patients:",
    sum(breast & liver), "\n")

cat("Breast-Liver, tumor documented in both:",
    sum(breast & liver & breast_tumor & liver_tumor), "\n")

cat("Breast-Lung, all matched patients:",
    sum(breast & lung), "\n")

cat("Breast-Lung, tumor documented in both:",
    sum(breast & lung & breast_tumor & lung_tumor), "\n")

cat("Liver-Lung, all matched patients:",
    sum(liver & lung), "\n")

cat("Liver-Lung, tumor documented in both:",
    sum(liver & lung & liver_tumor & lung_tumor), "\n")