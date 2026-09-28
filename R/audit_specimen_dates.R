library(readxl)
library(dplyr)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

rna <- read_excel(file, sheet = "RNA-seq")
clin <- read_excel(file, sheet = "Clinical Data")

# Remove completely blank separator rows
clin <- clin %>%
  filter(!is.na(`Patient #`))

# Convert Excel serial dates to calendar dates
clin$Procedure_Date_Converted <- as.Date(
  suppressWarnings(as.numeric(clin$`Date of procedure`)),
  origin = "1899-12-30"
)

cat("\n=== Unique RNA-seq specimens ===\n")

specimens <- rna %>%
  group_by(
    `Patient #`,
    `Tissue Site`,
    `External ID`,
    `Container ID`,
    `Internal Case ID`
  ) %>%
  summarise(
    N_libraries = n(),
    Library_names = paste(`RNA-seq name`, collapse = "; "),
    .groups = "drop"
  )

print(specimens, n = Inf, width = Inf)

cat("\n=== Clinical specimen records with converted dates ===\n")

clinical_fields <- c(
  "Patient #",
  "Tissue Site...2",
  "Study ID...3",
  "Container ID",
  "Internal Case ID",
  "Date of procedure",
  "Procedure_Date_Converted",
  "# RNA-seq Reps",
  "ER Status",
  "Percent Tumor In Biopsy"
)

print(clin[, clinical_fields], n = Inf, width = Inf)
