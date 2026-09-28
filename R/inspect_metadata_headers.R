library(readxl)

file <- "data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx"

sheets <- excel_sheets(file)
print(sheets)

for (s in c("RNA-seq", "Clinical Data")) {
  x <- read_excel(file, sheet = s)
  cat("\n---", s, "---\n")
  cat("Dimensions:", nrow(x), "rows x", ncol(x), "columns\n")
  print(names(x))
}
