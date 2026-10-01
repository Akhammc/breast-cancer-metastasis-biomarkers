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

## Day 8 - Enrichment workflow and provenance review

### Objective

Determine whether existing enrichment outputs or an identifiable enrichment workflow are present in the repository before considering any further exploratory analysis.

### Methods

* Inspected the results/enrichment directory recursively for files.
* Checked the directory for hidden items.
* Checked whether Git tracks files under results/enrichment.
* Searched R script filenames for enrichment, pathway, GO, and KEGG-related terms.
* Listed all R scripts and searched their contents for common enrichment functions and packages, including clusterProfiler, enrichGO, enrichKEGG, gseGO, gseKEGG, fgsea, and ReactomePA.

### Results and validation

* The results/enrichment directory exists but contains no files, including hidden items.
* No files under results/enrichment are tracked by Git.
* No R script filenames matched the enrichment-related filename search.
* No matches for the searched enrichment functions, packages, or terms were found in the R scripts.
* No enrichment analysis was run and no new analysis outputs were generated.

### Interpretation and limitations

The repository checks did not identify existing enrichment outputs or a readily identifiable enrichment workflow in the R scripts. These filename and text searches do not prove that no enrichment-related code or outputs exist elsewhere in the repository or outside it.

No gene set, enrichment background, statistical test, or multiple-testing adjustment was evaluated. No biological pathway conclusions or biomarker claims can be drawn from this repository review.

The established exploratory study scope and data-handling restrictions remain unchanged.

### Status

Day 8 repository-level enrichment and provenance review completed. No enrichment analysis was performed. This progress-log entry records the checks and their limitations.
### Day 8 follow-up - Exploratory GO Biological Process enrichment

#### Objective

Characterize functional annotations overrepresented among the 500 most variable genes across the mixed-tissue libraries, using the established expression-filtered gene universe.

#### Methods

* Used the 500 genes selected by descending logCPM variance in the Day 4 exploratory PCA workflow. These genes were selected across all 32 libraries, without tissue-specific or metastasis-specific selection.
* Used the 26,892 genes retained by the established CPM > 1 in at least two libraries expression filter as the enrichment background.
* Mapped Ensembl gene IDs to Entrez IDs using org.Hs.eg.db and AnnotationDbi. Ensembl IDs mapping to multiple distinct Entrez IDs were excluded; duplicate Entrez IDs were reduced to unique identifiers.
* Performed over-representation analysis for Gene Ontology Biological Process terms using clusterProfiler::enrichGO.
* Used Benjamini-Hochberg adjustment, gene-set size limits of 10 to 500, and unfiltered p-value and q-value cutoffs for result inspection.
* Recorded package versions and R version in the enrichment metadata output.

#### Results

* Selected genes: 500 Ensembl IDs; 440 unique Entrez IDs after mapping.
* Background: 26,892 Ensembl IDs; 19,996 unique Entrez IDs after mapping.
* GO BP terms returned: 3,161.
* Terms with BH-adjusted p-value < 0.05: 306.
* The top-ranked annotations included humoral immune response, antimicrobial humoral response, estrogen and steroid metabolic processes, acute-phase response, complement activation, and inflammatory response.
* The most significant term shown in the reviewed output was humoral immune response (GO:0006959; adjusted p-value approximately 7.83e-14).

#### Outputs

* R/day8_mapping_audit.R
* R/day8_go_enrichment.R
* results/enrichment/day8_go_bp_ora.csv
* results/enrichment/day8_go_bp_ora_metadata.csv
* results/enrichment/day8_go_bp_session_info.txt

#### Interpretation and limitations

The enrichment is exploratory and describes GO annotations overrepresented among highly variable genes across mixed breast, liver, and lung libraries. The selected genes were not derived from a tissue-specific contrast or a metastasis-versus-primary comparison. Results must not be interpreted as metastasis-associated pathways, causal mechanisms, or validated clinical biomarkers.

GO terms are hierarchically related and overlap in their gene membership; the 306 adjusted-significant terms are not 306 independent biological findings. Enrichment p-values do not resolve tissue composition, tumor content, patient-level dependence, or other potential sources of variation. The expression-filtered background and identifier mapping choices also affect the tested universe and results.

No differential-expression testing, inferential tissue-effect modeling, causal or clinical biomarker claims, or population-level inference was performed. The established project scope and data-handling restrictions remain unchanged.

#### Status

The exploratory GO BP over-representation analysis was run and its outputs and metadata were generated. Results were reviewed for mapping counts, term counts, adjusted p-values, and scope limitations. Repository validation and version-control review remain to be completed.
### Day 9 - Exploratory GO term gene-overlap review

#### Objective

Characterize gene-list overlap among the 306 BH-adjusted-significant GO Biological Process terms from the Day 8 exploratory over-representation analysis.

#### Methods

* Loaded the Day 8 GO BP enrichment results and retained terms with BH-adjusted p-value < 0.05.
* Parsed the reported gene symbols for each significant term.
* Calculated pairwise Jaccard similarity between reported gene lists, defined as the number of shared genes divided by the number of genes in the union of the two lists.
* Compared all unique pairs of significant terms. This is a descriptive gene-list overlap analysis, not a statistical test or a semantic GO ontology similarity analysis.

#### Results

* Significant GO BP terms reviewed: 306.
* Pairwise comparisons: 46,665.
* Identical reported gene lists (Jaccard = 1): 123 pairs (0.26%).
* High gene-list overlap (Jaccard >= 0.5 and < 1): 930 pairs (1.99%).
* Lower gene-list overlap (Jaccard < 0.5): 45,612 pairs (97.75%).
* Total pairs with Jaccard >= 0.5: 1,053 (2.26%).

Examples of overlapping annotations included coagulation and hemostasis, synaptic signaling, ion homeostasis, host defense, protein secretion, and metabolic processes. Several related terms had identical reported gene lists.

#### Outputs

* R/day9_go_redundancy.R
* results/enrichment/day9_go_pairwise_overlap.csv
* results/enrichment/day9_go_significant_terms.csv

#### Interpretation and limitations

The analysis documents gene-list overlap among significant GO BP annotations. Identical reported gene lists do not establish that GO terms are biologically synonymous; terms can differ in ontology definitions and hierarchical relationships. Jaccard similarity measures overlap among the genes reported in this enrichment output and does not measure semantic similarity between GO terms.

The 306 significant terms should not be treated as 306 independent biological findings. The reviewed themes remain exploratory annotations of highly variable genes across mixed breast, liver, and lung libraries. They cannot be attributed specifically to breast cancer metastasis, a particular tissue, or a causal mechanism.

No differential-expression testing, inferential tissue-effect modeling, causal or clinical biomarker claims, or population-level inference was performed. The established project scope and data-handling restrictions remain unchanged.

#### Status

The Day 9 gene-overlap review was completed. The analysis script and two output tables were generated, and the pairwise comparison counts and leading overlaps were reviewed. The Day 9 analysis was committed and pushed to origin/master in commit 497448f.

## Day 10 - Project documentation update

### Objective

Update the project README to reflect the current exploratory scope, completed analysis workflow, reproducibility documentation, and data-handling restrictions.

### Methods

* Reviewed the approved scope documented in D007 and D008 of the decision log.
* Updated README.md to describe completed analyses, their scripts, and key project limitations.
* Documented that generated enrichment CSV outputs remain local and are not tracked in Git.
* Checked the README diff for whitespace errors.

### Results

* README updated to reflect the current project status and approved scope.
* No analytical methods, results, or scope decisions were changed.

### Status

The README update was committed and pushed to origin/master in commit 62df3bd. The working tree was verified clean after the push.

## Day 11 - Reproducibility review

### Objective

Review the reproducibility and documentation of the existing analysis scripts without changing the approved scientific scope or rerunning analyses.

### Methods

* Reviewed the Day 4, Day 5, Day 8, and Day 9 analysis scripts.
* Added session-information capture to the Day 4 PCA script.
* Confirmed that the Day 5 script already records session information and produces descriptive expression summaries.
* Checked Git tracking and ignore rules for session-information and metadata outputs. Local results remain subject to the existing data-handling restrictions.

### Results

* Day 4 now writes R session and package information to `results/day4/day4_session_info.txt` when the script is next run.
* Day 5 session-information capture was verified; no changes were needed.
* The Day 4 script update was committed and pushed in commit `f1e8797`.
* The working tree was verified clean after the push.

### Limitations

The Day 4 analysis was not rerun during this review. Its new session-information output has therefore not yet been regenerated or verified. No scientific methods, results, or project scope decisions were changed.

## Day 12 - QC / Reproducibility Audit

### Objective

Conduct a chronological QC and reproducibility audit of the recorded project work from Day 4 through Day 11, preserving the distinction between historical execution evidence and current reproducibility verification.

### Day 4 audit

* The Day 4 exploratory PCA and sample-distance workflow was rerun successfully.
* The analysis processed 32 libraries representing 16 specimens.
* The CPM filter retained 26,892 genes.
* The 500 most variable genes were used for PCA and sample-distance visualization.
* The script regenerated the Day 4 descriptive output files.
* Current session information was captured successfully.
* R version: 4.6.1.
* edgeR version: 4.10.5.
* limma version: 3.68.5.
* ggplot2 version: 4.0.3.
* readxl version: 1.5.0.
* The Day 4 outputs were present after execution.
* The message `calcNormFactors has been renamed to normLibSizes` was emitted during execution.
* The rerun confirmed reproducibility of the recorded Day 4 workflow under the current environment.

### Day 5 audit

* The historical Day 5 workflow was reviewed against the surviving analysis script, descriptive output files, and session-information record.
* The gene-expression summary contains 26,892 retained genes.
* The library-expression summary contains 32 libraries.
* The documented distribution summary covers the same 32-library and 26,892-gene analysis space.
* R version and package information in the Day 5 session-information record were reviewed.
* No differential-expression testing or inferential tissue-effect modeling was introduced.
* Day 5 remains a descriptive expression-summary analysis.

### Day 6 audit

* The original Day 6 executable script was not available in the surviving repository history.
* A reconstructed reproducibility script was created from the documented historical methods and the surviving Day 5 gene-expression summary artifact.
* The reconstructed workflow reviewed the top 20 genes by variance in log2-CPM and the uniqueness/repetition of gene symbols.
* The reconstructed run reproduced the recorded findings:
  * 32 libraries reviewed.
  * 26,892 genes retained.
  * 0 missing gene symbols.
  * 26,717 unique non-empty gene symbols.
  * 175 repeated gene-symbol occurrences beyond the first occurrence.
  * Y_RNA was the most frequent symbol, with 21 occurrences.
  * 0 duplicated symbols occurred among the top 20 variable genes.
* The reconstructed workflow is explicitly treated as a reconstruction, not as the original historical Day 6 script.
* The resulting outputs are reproducibility artifacts and are not represented as original historical outputs.

### Day 7 audit

* The historical repository and environment QC activity was reviewed against the current repository state and recorded project history.
* No separate biological-analysis rerun was applicable to the Day 7 audit.
* The Day 7 work remains repository/environment QC rather than a new biological analysis.

### Day 8 audit

* The historical Day 8 workflow was corroborated by the surviving enrichment script and output artifacts.
* The documented exploratory workflow used GO Biological Process enrichment in the mixed-tissue expression context.
* The historical analysis involved 500 variable genes and the documented background set.
* The surviving artifacts support the recorded exploratory enrichment findings.
* The analysis remains exploratory annotation and does not establish metastasis-specific pathways, causal mechanisms, or clinical biomarkers.
* No inferential tissue-effect model was introduced.

### Day 9 audit

* The historical Day 9 workflow was corroborated by the surviving gene-overlap script and output artifacts.
* The recorded analysis contained 306 significant GO terms and 46,665 pairwise term comparisons.
* 123 term pairs had Jaccard similarity equal to 1.
* 930 term pairs had Jaccard similarity greater than or equal to 0.5 but less than 1.
* 45,612 term pairs had Jaccard similarity below 0.5.
* Therefore, 1,053 term pairs had Jaccard similarity greater than or equal to 0.5.
* The analysis was a descriptive GO-term redundancy/overlap review.
* No biological or clinical ranking of pathways was introduced.

### Day 10 audit

* The historical Day 10 activity was documentation-focused.
* The project README was updated to reflect the approved D007/D008 scope and associated limitations.
* The documented Git commit for this activity was reviewed.
* No analytical method, biological result, or scientific scope change was introduced by the Day 10 documentation update.

### Day 11 audit

* The historical Day 11 reproducibility review was corroborated from the project record and Git history.
* Day 4 and Day 5 analysis scripts were reviewed.
* Day 4 session-information capture was added to the analysis script.
* Day 5 already contained session-information capture.
* Git tracking and ignore behavior for analysis outputs were reviewed.
* The Day 4 session-information addition was committed as documented.
* The Day 11 progress-log update was committed as documented.
* The Day 4 session-information output was subsequently regenerated and verified during the Day 12 audit.
* The Day 11 work remains a reproducibility/documentation review and does not expand the scientific scope.

### Day 12 checkpoint conclusion

#### Overall audit status

The Day 12 chronological QC/reproducibility audit covered the recorded project work from Day 4 through Day 11.

* Day 4: executed and verified by rerunning the exploratory PCA and sample-distance workflow and capturing current session information.
* Day 5: executed and verified against the surviving script, descriptive outputs, and session-information record.
* Day 6: reconstructed and independently reproduced from the documented historical methods and surviving Day 5 expression-summary artifact; the reconstructed run reproduced all recorded findings.
* Day 7: historical repository and environment QC was corroborated against the current repository state; no separate biological-analysis rerun was applicable.
* Day 8: historical execution was corroborated by the surviving enrichment script and output artifacts, with the exploratory GO BP scope and limitations preserved.
* Day 9: historical execution was corroborated by the surviving gene-overlap script and output artifacts.
* Day 10: documentation activity was corroborated by the historical record and recorded Git commit.
* Day 11: reproducibility-review activity was corroborated, with the Day 4 session-information addition subsequently regenerated and verified during the Day 12 audit.

#### Scientific scope confirmation

The Day 12 audit did not expand the approved scientific scope.

The project remains a descriptive, exploratory feasibility study focused on tissue-associated expression patterns, exploratory annotation, reproducibility, and documented data limitations.

No differential-expression testing, inferential tissue-effect modeling, causal analysis, population-level inference, or clinical biomarker validation was introduced during the Day 12 audit.

The documented limitations concerning patient-level biological units, unresolved library independence, limited matched specimens, tumor-content uncertainty, tissue composition, and incomplete clinical metadata remain applicable.

#### Reproducibility and provenance conclusion

The audit distinguishes historical execution from current reproducibility evidence. Where original executable artifacts were available, they were reviewed or rerun as documented. Where the original executable was unavailable, surviving outputs and historical records were used, and the Day 6 workflow was explicitly reconstructed rather than represented as the original historical script.

Historical outputs and reconstructed reproducibility artifacts were not conflated.

#### Day 12 status

Day 12 QC/reproducibility audit: completed through the Day 11 audit and final checkpoint review.

The project is ready to proceed to the next planned project stage subject to the approved D007 descriptive exploratory scope and the documented feasibility limitations.

### Day 13 - Final analysis specification

* The final analysis specification was created as `docs/final_analysis_specification.md`.
* The specification was reviewed against the approved D007/D008 scope, the Day 12 QC/reproducibility audit, and the documented patient/specimen/library structure.
* The scientific scope was frozen as descriptive and exploratory, with differential-expression testing, inferential tissue-effect modeling, causal inference, population-level inference, and clinical biomarker validation explicitly excluded.
* The PE count matrix `data/raw/GSE316391_counts_PE.csv.gz` was documented as the provisional final analysis source.
* The 32-library, 16-specimen, 7-patient hierarchy was explicitly documented, with libraries retained for QC/exploratory visualization and specimens used as the primary unit for final descriptive expression aggregation.
* Repeated libraries within a specimen were explicitly defined to be summarized using the arithmetic mean of normalized logCPM values for each gene after library-level TMM normalization and logCPM transformation.
* The original library-level values remain available for QC, PCA, sample-distance visualization, and provenance.
* The established exploratory workflow, including CPM > 1 in at least 2 libraries, TMM normalization, logCPM transformation with prior count 2, and the 500 most variable retained genes for PCA/sample-distance visualization, was documented as the final workflow.
* The existing exploratory GO Biological Process annotation and GO-term redundancy review were retained within the descriptive exploratory scope.
* Interpretation constraints, clinical/biological metadata limitations, and reproducibility/provenance requirements were explicitly documented.
* The final analysis specification was committed to Git as commit `83d0ef4` with message `Freeze Day 13 final analysis specification`.

### Day 13 status

Day 13 final analysis specification: completed.

The final analytical specification is now frozen for the remaining project work unless an explicit scope-change decision is documented and approved.

## Day 14 - Final specimen-level descriptive expression consolidation

**Status:** Completed

### Objective
Implement the frozen Day 13 final analysis specification for specimen-level descriptive expression summarization, using the audited PE count matrix and the established library-level preprocessing workflow.

### Analysis completed
- Used `data/raw/GSE316391_counts_PE.csv.gz` as the primary expression matrix.
- Validated 62,703 unique Ensembl gene IDs and 32 RNA-seq libraries.
- Applied the established exploratory preprocessing:
  - CPM >1 in at least 2 libraries.
  - TMM library-size normalization.
  - logCPM transformation with prior count = 2.
- Retained 26,892 genes after expression filtering.
- Preserved the audited library-to-specimen mapping from the RNA-seq metadata.
- Aggregated normalized logCPM values to the frozen specimen level by taking the arithmetic mean across libraries belonging to each specimen.
- Produced 16 unique patient-tissue specimens from 32 libraries and 7 patients.
- Library representation per specimen was verified as:
  - 1 specimen with 1 library.
  - 14 specimens with 2 libraries.
  - 1 specimen with 3 libraries.
  - Total = 32 libraries.
- Generated:
  - `results/day14/day14_specimen_mean_logCPM.csv`
  - `results/day14/day14_specimen_metadata.csv`
  - `results/day14/day14_specimen_expression_summary.csv`
  - `results/day14/day14_session_info.txt`

### Validation
- Specimen expression matrix: 26,892 genes × 16 specimens.
- Gene IDs: 26,892 unique identifiers.
- Specimen IDs: 16 unique identifiers with no duplicates.
- Tissue sites represented: Breast, Liver/Bile Duct, and Lung.
- Patient count: 7.
- No missing or non-finite specimen expression values.
- Specimen summary statistics contained 26,892 unique genes with no missing or non-finite values.
- Aggregation was independently checked for:
  - a 2-library specimen (Patient 4 liver), where the reported value matched the arithmetic mean of its two library-level logCPM values.
  - a 3-library specimen (Patient 3 breast), where the reported value matched the arithmetic mean of its three library-level logCPM values.
- Patient 2 breast remained represented in the descriptive matrix and retained its metadata annotation indicating no tumor seen; it was not silently excluded.

### Reproducibility
Day 14 session information was captured successfully:
- R 4.6.1
- Windows 11 x64
- edgeR 4.10.5
- limma 3.68.5
- readxl 1.5.0

A non-blocking deprecation warning was observed when assigning row names to a tibble-derived object during metadata preparation. The analytical outputs and validation checks were unaffected.

### Scope
Day 14 remains strictly descriptive/exploratory under D007/D008. No differential-expression testing, inferential tissue comparison, causal inference, population-level inference, treatment-effect analysis, or clinical biomarker validation was performed.

### Day 14 conclusion
The frozen specimen-level descriptive aggregation has been implemented and independently validated. The resulting 16-specimen expression matrix and associated metadata/statistical summaries are structurally and numerically consistent with the approved analysis specification.

## Day 15 — Patient/Specimen-Aware Descriptive Analysis

### Objective
Extend the finalized Day 14 specimen-level expression dataset into a patient/specimen-aware descriptive analysis while preserving the established biological-unit hierarchy and avoiding inferential tissue comparisons.

### Inputs
- `results/day14/day14_specimen_mean_logCPM.csv`
- `results/day14/day14_specimen_metadata.csv`
- Finalized Day 14 expression matrix: 26,892 genes × 16 specimens.
- Sample structure: 32 RNA-seq libraries mapped to 16 patient-tissue specimens from 7 patients.

### Analysis Performed
- Validated the Day 14 specimen-level expression matrix and metadata before analysis.
- Preserved specimen identity using the established `specimen_id`.
- Summarized patient-level specimen structure, including the number of specimens, tissue sites, and libraries represented for each patient.
- Documented tissue availability and matched-tissue structure for Breast, Liver/Bile Duct, and Lung.
- Generated descriptive expression summaries for each specimen across the 26,892 retained genes.
- Expression summaries included mean, median, standard deviation, variance, minimum, and maximum normalized logCPM.
- Retained patient, tissue-site, specimen, library-count, and histology metadata with the expression summaries.

### Patient/Specimen Structure
- Patients: 7
- Patient-tissue specimens: 16
- RNA-seq libraries: 32
- Breast–Liver/Bile Duct matched patients: 3
- Breast–Lung matched patients: 2
- Liver/Bile Duct–Lung matched patients: 6
- Libraries remained associated with their specimen and were not treated as independent biological observations.

### Validation
- Specimen expression summary rows: 16
- Duplicate specimen IDs: 0
- Missing `mean_logCPM` values: 0
- Missing `variance_logCPM` values: 0
- Unique patients represented: 7
- Genes represented per specimen: 26,892
- Day 14 specimen IDs and Day 15 expression specimen IDs were validated as the same set.

### Outputs
- `results/day15/day15_patient_specimen_structure.csv`
- `results/day15/day15_matched_tissue_summary.csv`
- `results/day15/day15_specimen_expression_summary.csv`
- `results/day15/day15_session_info.txt`

### Interpretation and Scope
This analysis is descriptive and exploratory. Specimen-level expression summaries are intended to characterize the audited dataset while preserving patient/specimen structure. They do not constitute differential-expression testing or an inferential comparison of tissue types.

No differential-expression analysis, inferential tissue-effect testing, causal inference, population-level inference, treatment-effect analysis, or clinical biomarker validation was performed.

### Status
Day 15 patient/specimen-aware descriptive analysis completed and validated. Outputs are ready for documentation and version control.