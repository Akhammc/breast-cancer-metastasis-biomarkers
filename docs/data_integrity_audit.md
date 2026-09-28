# Data Integrity Audit

Date: 2026-09-29
Status: VERIFIED — data integrity and specimen metadata audit

## 1. Source files

- GSE316391_counts_PE.csv.gz
- GSE316391_RNA_counts_Met_plus_GTEX.csv.gz
- GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx
- PRJNA999001_SRA_RunInfo.csv
- PRJNA999001_BioSample_metadata.xml

Original source files were not modified.

## 2. Gene identifier and count matrix audit

- PE matrix: 62,703 rows and 62,703 unique Ensembl gene IDs.
- GTEx-inclusive matrix: 62,748 rows and 62,703 unique Ensembl gene IDs.
- All 62,703 unique gene IDs are shared between matrices.
- The GTEx-inclusive matrix contains 45 duplicated gene IDs, each occurring twice.
- All 45 duplicated pairs have identical annotations and identical counts across all 32 tumor libraries.

After removing one copy of each verified duplicate in memory and aligning rows by Ensembl gene ID:

- 62,703 genes were aligned.
- All 32 tumor library count vectors matched exactly.
- Total differing gene-sample entries: 0.
- All 32 sample count totals matched.

The R49 liver library naming discrepancy was reconciled against the clinical workbook. The matrix reconciliation used aligned library columns; the source files remain unchanged.

Decision:
- Use the PE matrix as the provisional tumor count source.
- Do not sum duplicate gene rows.
- Exclude GTEx normal samples from the primary tumor analysis unless a separately justified design is approved.

## 3. Sample and specimen structure

The RNA-seq count matrix contains 32 libraries.

The RNA-seq and clinical workbook metadata identify 16 distinct patient-tissue specimens across seven patients:

- Breast: 3 specimens, from patients 1, 2, and 3.
- Liver: 7 specimens, from patients 1 through 7.
- Lung: 6 specimens, from patients 1, 3, 4, 5, 6, and 7.

All 16 distinct RNA-seq specimens were matched to clinical records using patient, container, and internal case identifiers.

The clinical workbook includes additional breast specimens without corresponding RNA-seq libraries. These are not included in the count matrix.

The 32 libraries map to the 16 specimens as repeated libraries from the same recorded specimen identifiers. The available public metadata does not establish whether these are independent tissue pieces, independent RNA extractions, technical library replicates, or resequencing.

Therefore:
- Library count is not equivalent to biological sample size.
- Libraries from the same recorded specimen must not be treated as independent patients.
- Replicate independence remains unresolved due to insufficient available experimental detail.

## 4. Pairing and clinical eligibility

Three patients have both a primary breast specimen and metastatic specimens in the RNA-seq dataset: patients 1, 2, and 3.

Clinical metadata:
- Patient 1: ER-positive primary; breast tumor percentage unknown.
- Patient 2: ER-positive primary record, but breast specimen annotated "No Tumor Seen"; liver specimen has recorded tumor content of 50–75%.
- Patient 3: ER-positive, PR-positive, HER2-negative primary; breast, liver, and lung specimens recorded as 75–99% tumor content.

Patient 3 is the only matched primary breast specimen with documented tumor content of 75–99%.

The workbook records ER status on primary breast clinical records; metastatic ER status is not established in the available metadata.

Treatment exposure, collection circumstances, tumor purity, and other potential confounders require careful consideration. Dates recorded in the workbook do not independently establish the timing of treatment relative to every specimen or prove that specimens represent comparable disease stages.

## 5. SRA and GEO metadata

- GEO accession: GSE316391.
- BioProject: PRJNA999001, a component of umbrella project PRJNA999000.
- SRA RunInfo contains 74 records: 32 RNA-seq and 42 ATAC-seq.
- The 32 RNA-seq RunInfo library names match the 32 count matrix library names.
- The RNA-seq records have distinct SRR, SRX, and BioSample accessions.
- Public BioSample attributes confirm tissue labels and RNA analyte type but do not establish biological independence of repeated libraries.

The GEO record includes author-provided differential-expression files. These are reference materials and are not results independently reproduced by this project.

## 6. Analysis implications

- No differential-expression analysis has been performed.
- No statistical design has been frozen.
- For biological interpretation, the patient is the relevant biological unit; repeated libraries from the same recorded specimen must not be treated as independent biological observations. No inferential analysis is authorized under the current scope.
- The small number of matched patients and uncertain tumor content constrain the descriptive comparisons and limit the generalizability of observed expression patterns.
- Any subsequent expression analysis must be described as exploratory unless the verified sample structure supports stronger inference.
- No causal, clinical biomarker, or clinical validation claims are supported by this audit alone.

## 7. Scripts

Matrix audit:
- R/audit_gene_ids.R
- R/compare_matrices.R
- R/inspect_duplicate_genes.R
- R/reconcile_matrices.R
- R/verify_duplicate_counts.R

Metadata audit:
- R/inspect_metadata_headers.R
- R/inspect_metadata_records.R
- R/audit_specimen_dates.R
- R/audit_specimen_eligibility.R

## 8. Decision status

Matrix integrity: VERIFIED.
Specimen-to-clinical metadata matching: VERIFIED.
Replicate independence: UNRESOLVED — insufficient public experimental detail.
Final analysis matrix: PROVISIONAL.
Statistical design: NOT FROZEN.
Differential-expression analysis: NOT STARTED.

Next milestone: assess statistical feasibility and approve the analysis design before performing differential expression.