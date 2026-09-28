library(readxl)
library(dplyr)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

rna <- read_excel(file, sheet = "RNA-seq")
clin <- read_excel(file, sheet = "Clinical Data") %>%
  filter(!is.na(`Patient #`))

rna_specimens <- rna %>%
  distinct(
    `Patient #`,
    `Tissue Site`,
    `Container ID`,
    `Internal Case ID`
  )

matched <- inner_join(
  rna_specimens,
  clin,
  by = c(
    "Patient #" = "Patient #",
    "Tissue Site" = "Tissue Site...2",
    "Container ID" = "Container ID",
    "Internal Case ID" = "Internal Case ID"
  )
)

cat("RNA-seq distinct specimens:", nrow(rna_specimens), "\n")
cat("Matched clinical records:", nrow(matched), "\n")
cat(
  "Unmatched RNA-seq specimens:",
  nrow(anti_join(
    rna_specimens,
    clin,
    by = c(
      "Patient #" = "Patient #",
      "Tissue Site" = "Tissue Site...2",
      "Container ID" = "Container ID",
      "Internal Case ID" = "Internal Case ID"
    )
  )),
  "\n"
)

cat(
  "Duplicate clinical matches:",
  sum(duplicated(matched %>% select(
    `Patient #`, `Tissue Site`, `Container ID`, `Internal Case ID`
  ))),
  "\n"
)

fields <- c(
  "Patient #",
  "Tissue Site",
  "Container ID",
  "Internal Case ID",
  "Primary Diagnosis",
  "Histology",
  "Date of procedure",
  "Treatment prior to collection?",
  "Primary Breast Treatment Before Becoming Metastatic",
  "Metastatic Disease Treatment",
  "ER Status",
  "PR Status",
  "HER2 Status",
  "Percent Tumor In Biopsy",
  "Percent Necrosis In Biopsy"
)

cat("\n=== Matched specimen eligibility and clinical history ===\n")

print(
  matched %>% select(any_of(fields)),
  n = Inf,
  width = Inf
)