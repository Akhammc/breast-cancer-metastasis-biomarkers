# Research Progress Log

Project: Breast Cancer Metastasis-Associated Gene Expression and Candidate Biomarker Discovery

Start date: 2026-09-29
Project time limit: Four weeks, with a hard stop of 2026-10-26
Planned effort: Approximately 3–4 hours per day

This log records completed work, evidence, decisions, and milestone transitions. Technical details and full audit results are maintained in the linked project documents and scripts.

## Day 1 — Project setup and environment verification

Date: 2026-09-29
Status: COMPLETED

### Work completed

- Established the project directory and subdirectory structure for raw and processed data, R and Python scripts, results, documentation, and logs.
- Initialized the Git repository and configured the author identity.
- Verified the local software environment, including Windows PowerShell, Git, R, Rscript, and Python.
- Created and verified the initial project commit.

### Evidence and records

- Initial Git commit: `c4258cf` — Initialize breast cancer metastasis research project.
- Project root: `C:\Users\LENOVO\Documents\breast-cancer-metastasis-biomarkers`

### Day 1 outcome

The local project environment and version-control structure were established. No expression analysis was performed.

## Day 2 — Dataset and data-integrity audit

Date: 2026-09-29
Status: COMPLETED

### Work completed

- Examined GEO dataset GSE316391 and its linked BioProject/SRA metadata.
- Verified gzip integrity of the two count matrix files.
- Reconciled the PE and GTEx-inclusive count matrices by Ensembl gene identifier.
- Inspected the clinical workbook and mapped RNA-seq libraries to recorded specimens.
- Matched all 16 distinct RNA-seq specimens to clinical records using patient, tissue site, container ID, and internal case ID.
- Inspected SRA RunInfo and public BioSample metadata.
- Documented specimen eligibility, available clinical annotations, and unresolved replicate independence.
- Updated the data-integrity audit and committed the metadata-audit scripts.

### Key verified findings

- The PE count matrix contains 62,703 unique gene IDs.
- The GTEx-inclusive matrix contains 62,748 rows, including 45 duplicated gene IDs. Each duplicated pair has identical annotations and counts across all 32 tumor libraries.
- After removing one copy of each verified duplicate in memory and aligning gene IDs, all 32 tumor library count vectors matched exactly between matrices.
- The count matrix contains 32 RNA-seq libraries mapping to 16 distinct patient-tissue specimens across seven patients.
- All 16 distinct RNA-seq specimens matched clinical records; no unmatched specimens or duplicate clinical matches were found.
- Three patients have both primary breast and metastatic RNA-seq specimens.
- Patient 2's breast specimen is annotated "No Tumor Seen." Patient 1's breast tumor percentage is unknown. Patient 3's matched breast specimen has recorded tumor content of 75–99%.
- Public metadata does not establish whether repeated libraries represent independent tissue pieces, independent RNA extractions, technical library replicates, or resequencing.

### Decisions and limitations

- The PE matrix is the provisional tumor count source.
- Verified duplicate gene rows will not be summed.
- GTEx normal samples are excluded from the primary tumor analysis unless a separately justified design is approved.
- The patient, not the sequencing library, is the biological unit of inference.
- Replicate independence remains unresolved because available public experimental detail is insufficient.
- The primary contrast, final analysis matrix, and statistical formula remain unfrozen.
- No differential-expression analysis has been performed.

### Evidence and records

- `docs/data_integrity_audit.md`
- `docs/decision_log.md`
- Matrix reconciliation scripts under `R/`
- Metadata inspection and specimen audit scripts under `R/`
- Audit commit: `5df04e6` — Document and verify count matrix reconciliation.
- Metadata audit commit: `1648a91` — Complete data integrity and specimen metadata audit.

## Day 3 — Statistical feasibility and analysis design

Date: 2026-09-29
Status: IN PROGRESS

### Original entry criteria (not independently verified)

- Days 1 and 2 documentation reviewed and committed.
- A clean working tree was intended before beginning new work; the pre-work state was not independently confirmed.

### Initial plan (retained for traceability; see findings below)

1. Summarize library counts and distinct specimen counts by patient and tissue.
2. Assess the number of independent patients available for each proposed comparison.
3. Evaluate whether patient pairing, repeated specimens, and replicate structure can be represented defensibly.
4. Assess clinical eligibility, tumor content, and potential confounding.
5. Document the feasibility and limitations of each comparison.
6. Maintain the user-approved descriptive scope (D007); differential-expression design and testing are outside the current scope.

No differential-expression analysis or statistical model is authorized by this progress entry.

## Historical project status at close of Day 2

Data integrity and specimen-to-clinical matching: VERIFIED.

Replicate independence: UNRESOLVED.

Analysis matrix: PROVISIONAL.

Statistical design: NOT FROZEN.

Differential-expression analysis: NOT STARTED.

The project proceeds as a descriptive, exploratory feasibility study of tissue-associated gene-expression patterns and data limitations, subject to transparent reporting of limitations.

### Day 3 feasibility findings — 2026-09-29

Status: IN PROGRESS

#### Patient-level eligibility

| Comparison | All matched patients | Tumor documented at both sites |
|---|---:|---:|
| Breast–liver | 3 | 1 |
| Breast–lung | 2 | 1 |
| Liver–lung | 6 | 1 |

- Patient 3 is the only patient with documented tumor content at all three tissue sites.
- Unknown tumor content does not establish absence of tumor.
- The strict documented-tumor scenario is a sensitivity description, not an approved specimen exclusion rule.

#### Scope decision

- Decision D007: Proceed with a descriptive, exploratory feasibility project.
- Describe tissue-associated expression patterns and data limitations.
- Differential-expression testing is not authorized under the selected scope.
- No causal, clinical biomarker, or population-level inference is planned.
- The small matched cohort, incomplete tumor-content information, and unresolved library independence constrain interpretation.

#### Remaining work

1. Complete and review the feasibility report.
2. Assess and document whether descriptive expression summaries can be generated defensibly.
3. Review the analysis matrix and replicate structure before any expression summaries.
4. Keep differential-expression testing out of scope unless the user explicitly revises the project decision.

No differential-expression analysis has been performed.

### Feasibility report approval — 2026-09-29

Status: VERIFIED

- The user explicitly approved `docs/statistical_feasibility_report.md` as written.
- Approval is recorded in decision D008.
- The descriptive, exploratory scope in D007 remains in effect.
- Differential-expression testing remains outside the current scope.

## Day 4 — Descriptive exploratory expression analysis

**Status:** Completed; descriptive outputs generated and validated.

### Scope and preprocessing
- Used the audited PE count matrix (`GSE316391_counts_PE.csv.gz`) and matched RNA-seq workbook metadata.
- Retained the 32 RNA-seq libraries representing 16 matched patient-tissue specimens across 7 patients.
- Applied the approved low-expression filter: CPM > 1 in at least 2 libraries.
- Applied edgeR TMM normalization and calculated logCPM with prior count 2.
- Selected the 500 most variable retained genes for visualization.
- Performed centered, unscaled PCA at library level and calculated Euclidean sample distances using the same transformed expression values.

### Results and technical validation
- 26,892 genes retained after the CPM filter; 500 selected for visualization.
- PCA contains 32 unique libraries with no missing PC1 or PC2 coordinates.
- PC1 explains 31.4% and PC2 explains 20.9% of the variance in the selected-gene PCA.
- Sample-distance matrix is 32 × 32, symmetric, and has a zero diagonal.
- Raw library sizes range from 18,854,457 to 29,614,222 counts.
- TMM effective library sizes range from approximately 10,889,918 to 31,044,063.
- Both figures were visually reviewed. The PCA has some overlapping labels and shows separation of R18LIV_1; these are descriptive observations only.

### Outputs
Generated under `results/day4/`:
- `day4_exploratory_pca.png`
- `day4_sample_distance.png`
- `day4_library_metadata.csv`
- `day4_library_qc_summary.csv`
- `day4_pca_coordinates.csv`
- `day4_sample_distance_matrix.csv`
- `day4_selected_variable_genes.csv`

Reproducible script: `R/day4_exploratory_pca.R`

### Limitations and interpretation
- PCA and sample distances are exploratory visualizations, not inferential tests.
- Libraries are not treated as independent biological replicates; 32 libraries map to 16 specimens from 7 patients.
- No differential expression testing, tissue-effect inference, causal analysis, or clinical biomarker claims were performed.
- The PCA separation of R18LIV_1 is not, by itself, evidence of a biological mechanism or grounds for sample exclusion.
- The selected 500 genes and observed distances depend on the stated filtering, normalization, and feature-selection choices.

## Day 5 — Descriptive gene-expression summaries

### Objective

Generate descriptive gene- and library-level expression summaries using the PE count matrix and the established Day 4 normalization workflow.

### Methods

* Input: `data/raw/GSE316391_counts_PE.csv.gz`.
* Applied the existing expression filter: CPM > 1 in at least two libraries.
* Applied edgeR TMM normalization and calculated log2-CPM values using a prior count of 2.
* Summarized library-level expression distributions and gene-level mean, median, standard deviation, and variance across the 32 libraries.
* No differential-expression testing, inferential tissue comparisons, causal analysis, or clinical biomarker claims were performed.

### Results and validation

* Libraries processed: 32.
* Genes retained: 26,892.
* Gene summary contains 26,892 rows and 26,892 unique Gene IDs.
* No missing Gene IDs or missing values in the gene- or library-level summaries.
* Library summary contains 32 rows and 32 unique library IDs.
* Overall distribution summary contains eight descriptive metrics.

### Outputs

* `results/day5/day5_gene_expression_summary.csv`
* `results/day5/day5_library_expression_summary.csv`
* `results/day5/day5_overall_distribution_summary.csv`
* `results/day5/day5_session_info.txt`

### Interpretation and limitations

These outputs describe expression distributions across the available RNA-seq libraries. Libraries are not independent patients or necessarily independent biological observations. The summaries do not establish tissue-specific differential expression, causal effects, clinical validity, or biomarker performance. Interpretations remain exploratory and subject to the previously documented specimen-level and clinical metadata limitations.

### Status

Day 5 descriptive expression summaries completed and validated. Results have not yet been committed to Git.

## Day 6 - Descriptive expression review and annotation checks

### Objective

Review the Day 5 expression summaries, characterize the highest-variance genes, and assess gene-symbol annotation uniqueness without conducting inferential tissue comparisons.

### Methods

* Reviewed gene- and library-level descriptive expression summaries from Day 5.
* Examined the 20 genes with the highest variance in log2-CPM across 32 libraries.
* Checked missing and repeated gene symbols in the retained gene summary.
* Checked whether any of the top 20 variable genes had duplicated gene symbols.
* Retained Ensembl Gene IDs as primary identifiers; no rows were collapsed or summed by gene symbol.

### Results and validation

* Libraries reviewed: 32.
* Genes retained: 26,892.
* Missing gene symbols: 0.
* Unique non-empty gene symbols: 26,717.
* Repeated gene symbols beyond the first occurrence: 175.
* The most frequently repeated symbol was Y_RNA, occurring 21 times.
* None of the top 20 highest-variance genes had a duplicated gene symbol.

### Interpretation and limitations

The top-variance list describes variability across the available libraries and does not establish tissue-specific expression, metastatic mechanisms, or biomarker validity. Expression variability may reflect biological heterogeneity, tissue composition, technical factors, or other sources of variation that cannot be separated under the current study design.

Repeated gene symbols do not necessarily indicate duplicated count records or errors. Ensembl Gene IDs remain the primary identifiers. No gene-symbol-based aggregation, differential-expression testing, inferential tissue-effect modeling, causal analysis, or clinical biomarker claims were performed.

### Status

Day 6 descriptive review and annotation checks completed. Findings remain exploratory and subject to the previously documented specimen-level and clinical metadata limitations.

## Day 7 - Reproducibility and repository quality control

### Objective

Review the repository state, required software dependencies, input data availability, and data-handling practices to establish a reproducibility baseline before further analysis.

### Methods

* Checked Git working-tree status and recent commit history.
* Inspected the existing R analysis scripts and results directory structure.
* Verified availability of the required R packages: edgeR, ggplot2, and readxl.
* Confirmed that the PE count matrix and Day 4 and Day 5 analysis scripts are present.
* Generated a SHA-256 checksum for the local PE count matrix.
* Checked that the raw count matrix is ignored by Git and is not tracked.
* Confirmed that the local Git branch is synchronized with the remote repository.

### Results and validation

* Git branch: master.
* Local branch synchronized with origin/master.
* Required R packages are installed.
* Input count matrix and Day 4 and Day 5 scripts are present.
* SHA-256 checksum of the local PE count matrix: D580AE4882B716D8A1D188155723A02E61EF2B03081BE610348024F566D7665A.
* Raw count matrix is excluded by .gitignore and is not tracked by Git.
* Working tree was clean at the end of the checks.

### Interpretation and limitations

The checks establish local file availability, software package availability, and repository cleanliness. The generated checksum provides a fingerprint for future file-integrity comparisons but does not independently verify identity with the original GEO source file.

The Day 4 and Day 5 analyses were not rerun during these checks, and existing results were not overwritten. No new biological or statistical inference was performed. The established exploratory study scope and data-handling restrictions remain unchanged.

### Status

Day 7 reproducibility and repository quality-control checks completed. No files were modified or committed during the initial checks; this progress-log entry records the completed work.
