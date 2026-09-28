library(readxl)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

rna <- read_excel(file, sheet = "RNA-seq")
clin <- read_excel(file, sheet = "Clinical Data")

cat("\n=== RNA-seq sample-to-specimen mapping ===\n")
print(rna[, c(
  "RNA-seq name",
  "Patient #",
  "Tissue Site",
  "External ID",
  "Container ID",
  "Internal Case ID"
)], n = Inf)

cat("\n=== Clinical specimen and biological metadata ===\n")
fields <- c(
  "Patient #",
  "Tissue Site...2",
  "Study ID...3",
  "Container ID",
  "Internal Case ID",
  "Primary Diagnosis",
  "# RNA-seq Reps",
  "Date of procedure",
  "Treatment prior to collection?",
  "Primary Breast Treatment Before Becoming Metastatic",
  "Metastatic Disease Treatment",
  "ER Status",
  "PR Status",
  "HER2 Status",
  "Tissue Site...23",
  "Study ID...24",
  "Percent Tumor In Biopsy"
)

print(clin[, fields], n = Inf, width = Inf)
