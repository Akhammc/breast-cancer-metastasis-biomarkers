library(readxl)
library(dplyr)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

rna <- read_excel(file, sheet = "RNA-seq")

clin <- read_excel(file, sheet = "Clinical Data") %>%
  filter(!is.na(`Patient #`))

# One row per recorded specimen
specimens <- rna %>%
  group_by(
    `Patient #`,
    `Tissue Site`,
    `Container ID`,
    `Internal Case ID`
  ) %>%
  summarise(
    N_libraries = n(),
    Library_names = paste(`RNA-seq name`, collapse = "; "),
    .groups = "drop"
  )

# Reuse the exact verified clinical join
matched <- inner_join(
  specimens,
  clin,
  by = c(
    "Patient #" = "Patient #",
    "Tissue Site" = "Tissue Site...2",
    "Container ID" = "Container ID",
    "Internal Case ID" = "Internal Case ID"
  )
)

# Explicitly classify documented tumor content
eligibility <- matched %>%
  mutate(
    Tumor_content_category = case_when(
      grepl(
        "No Tumor Seen",
        `Percent Tumor In Biopsy`,
        ignore.case = TRUE
      ) ~ "No tumor seen",
      grepl(
        "75%-99%",
        `Percent Tumor In Biopsy`,
        fixed = TRUE
      ) ~ "Documented 75-99%",
      grepl(
        "50%-75%",
        `Percent Tumor In Biopsy`,
        fixed = TRUE
      ) ~ "Documented 50-75%",
      grepl(
        "Unknown",
        `Percent Tumor In Biopsy`,
        ignore.case = TRUE
      ) ~ "Unknown",
      TRUE ~ "Other / not classified"
    ),
    Breast_tissue_flag = case_when(
      `Tissue Site` != "Breast" ~ "Not applicable",
      Tumor_content_category == "No tumor seen" ~
        "Not eligible: no tumor seen",
      Tumor_content_category == "Unknown" ~
        "Eligibility unresolved: tumor content unknown",
      Tumor_content_category == "Documented 75-99%" ~
        "Tumor documented: 75-99%",
      TRUE ~ "Review required"
    ),
    Metastatic_tissue_flag = case_when(
      `Tissue Site` == "Breast" ~ "Not applicable",
      Tumor_content_category == "Unknown" ~
        "Tumor content unknown",
      Tumor_content_category == "No tumor seen" ~
        "No tumor seen",
      TRUE ~ "Tumor content documented; review pathology"
    )
  ) %>%
  select(
    `Patient #`,
    `Tissue Site`,
    `Container ID`,
    `Internal Case ID`,
    N_libraries,
    Library_names,
    `ER Status`,
    `PR Status`,
    `HER2 Status`,
    `Percent Tumor In Biopsy`,
    Tumor_content_category,
    Breast_tissue_flag,
    Metastatic_tissue_flag,
    `Percent Necrosis In Biopsy`,
    `Treatment prior to collection?`,
    `Primary Breast Treatment Before Becoming Metastatic`,
    `Metastatic Disease Treatment`
  )

cat("\n=== Specimen eligibility table ===\n")
print(eligibility, n = Inf, width = Inf)

cat("\n=== Breast specimen eligibility ===\n")
print(
  eligibility %>%
    filter(`Tissue Site` == "Breast") %>%
    select(
      `Patient #`,
      Tumor_content_category,
      Breast_tissue_flag
    ),
  n = Inf
)

cat("\n=== Metastatic specimen tumor-content summary ===\n")
print(
  eligibility %>%
    filter(`Tissue Site` != "Breast") %>%
    count(`Tissue Site`, Tumor_content_category),
  n = Inf
)

cat("\n=== Patient counts by breast eligibility category ===\n")
print(
  eligibility %>%
    filter(`Tissue Site` == "Breast") %>%
    count(Breast_tissue_flag),
  n = Inf
)

dir.create("results/day3", recursive = TRUE, showWarnings = FALSE)

write.csv(
  eligibility,
  "results/day3/day3_specimen_eligibility.csv",
  row.names = FALSE,
  na = ""
)

cat("\nSaved: results/day3/day3_specimen_eligibility.csv\n")
