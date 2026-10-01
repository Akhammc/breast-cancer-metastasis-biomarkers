# Reproducibility Summary

## 1. Purpose

This document records the reproducibility and provenance structure of the Breast Cancer Metastasis Biomarkers project.

The purpose is to document the software environment, analysis scripts, inputs, outputs, Git history, traceability relationships, raw-data protection, and remaining reproducibility gaps for the completed descriptive exploratory analysis of GEO GSE316391.

The project remains within the approved D007/D008 descriptive exploratory scope.

## 2. Reproducibility Scope

The reproducible analysis chain is centered on the finalized specimen-level expression dataset and the final expression figures.

The primary final analytical unit is the patient-tissue specimen. Multiple RNA-seq libraries may map to the same specimen and were not treated as independent biological observations.

The final specimen-level expression matrix was produced from the PE count matrix using the established filtering, TMM normalization, normalized logCPM transformation, and arithmetic mean aggregation across libraries belonging to the same specimen.

No differential-expression testing or inferential tissue comparison was performed under the approved scope.

## 3. Software Environment

### R

- R version: 4.6.1
- R build date: 2026-06-24
- Platform: x86_64-w64-mingw32/x64
- Operating system: Windows 11 x64

The Day 14 session information records the primary analysis packages as:
- edgeR 4.10.5
- limma 3.68.5
- readxl 1.5.0

The final Day 16 figure sessions record:
- ggplot2 4.0.3

The Day 8 exploratory enrichment session records:
- clusterProfiler 4.20.0
- org.Hs.eg.db 3.23.1
- AnnotationDbi 1.74.0

Additional package versions are preserved in the corresponding session-information files stored with the analysis outputs.

## 4. Primary Input Data

The principal raw inputs are:
- `data/raw/GSE316391_counts_PE.csv.gz`
- `data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx`

The PE count matrix is the finalized count source used for the specimen-level expression workflow.

The GTEx-inclusive count matrix was not used as the final analytical input. Its duplicate Geneid rows were not summed into the PE matrix.

Raw input files are treated as immutable project inputs and are not version-controlled in the Git repository.

## 5. Analysis Scripts

The repository contains the R scripts used for the analysis workflow.

### Feasibility and exploratory analysis

- `R/day3_patient_feasibility.R`
- `R/day3_clinical_eligibility.R`
- `R/day3_eligibility_scenarios.R`
- `R/day4_exploratory_pca.R`
- `R/day5_expression_summaries.R`
- `R/day6_reconstructed_reproducibility.R`
- `R/day8_go_enrichment.R`
- `R/day9_go_redundancy.R`

### Final specimen-level analysis

- `R/day14_specimen_expression_summary.R`
- `R/day15_patient_specimen_analysis.R`

### Final expression figures

- `R/day16_figure1_final_expression.R`
- `R/day16_figure2_pca.R`
- `R/day16_figure3_specimen_distance_heatmap.R`
- `R/day16_figure4_variable_gene_heatmap.R`

Additional audit and reconciliation scripts remain in `R/` for data inspection and provenance work.

## 6. Final Analysis Traceability

### Day 14 — Final specimen-level expression matrix

Input:
- `data/raw/GSE316391_counts_PE.csv.gz`
- `data/raw/GSE316391_BCMetastasis_All_Samples_and_Clinical_Data.xlsx`

Script:
- `R/day14_specimen_expression_summary.R`

Outputs:
- `results/day14/day14_specimen_mean_logCPM.csv`
- `results/day14/day14_specimen_metadata.csv`
- `results/day14/day14_specimen_expression_summary.csv`
- `results/day14/day14_session_info.txt`

The Day 14 script explicitly references the two raw input files and writes its outputs to `results/day14`.

### Day 15 — Patient/specimen-aware descriptive analysis

Inputs:
- `results/day14/day14_specimen_mean_logCPM.csv`
- `results/day14/day14_specimen_metadata.csv`

Script:
- `R/day15_patient_specimen_analysis.R`

Outputs:
- `results/day15/day15_matched_tissue_summary.csv`
- `results/day15/day15_patient_specimen_structure.csv`
- `results/day15/day15_specimen_expression_summary.csv`
- `results/day15/day15_session_info.txt`

The Day 15 script consumes the finalized Day 14 specimen-level data rather than reprocessing the raw count matrix.

### Day 16 — Final expression figures

All four final figure scripts consume the finalized Day 14 specimen-level expression matrix and specimen metadata.

Figure 1:
- Script: `R/day16_figure1_final_expression.R`
- Output directory: `results/day16/figure1/`
- Primary figure: `day16_figure1_specimen_expression_distributions.png`

Figure 2:
- Script: `R/day16_figure2_pca.R`
- Output directory: `results/day16/figure2/`
- Primary figure: `day16_figure2_specimen_pca.png`

Figure 3:
- Script: `R/day16_figure3_specimen_distance_heatmap.R`
- Output directory: `results/day16/figure3/`
- Primary figure: `day16_figure3_specimen_distance_heatmap.png`

Figure 4:
- Script: `R/day16_figure4_variable_gene_heatmap.R`
- Output directory: `results/day16/figure4/`
- Primary figure: `day16_figure4_variable_gene_heatmap.png`

Each figure directory also contains the corresponding data or annotation files and session-information output required to inspect the generated result.

## 7. Final Biological Interpretation

The final biological interpretation is documented in:
- `docs/final_biological_interpretation.md`

The interpretation is based on the finalized descriptive expression analyses and explicitly distinguishes supported observations from hypotheses and limitations.

It does not convert exploratory expression structure into claims of metastasis-specific effects, causality, population-level effects, or clinically validated biomarkers.

## 8. Git Provenance

The current repository history includes the following major reproducibility checkpoints:
- `610e33d` — Complete Day 12 QC reproducibility audit
- `83d0ef4` — Freeze Day 13 final analysis specification
- `6a44073` — Document Day 13 final analysis specification
- `7deb91b` — Complete Day 14 specimen-level expression consolidation
- `d28483d` — Version-control generated analysis results
- `a3a4ee6` — Complete Day 15 patient specimen analysis
- `1bfcb5c` — Complete Day 16 final expression figures
- `90c75d0` — Complete Day 17 final biological interpretation

At the start of Day 18, both local `master` and `origin/master` point to commit `90c75d0`.

## 9. Generated Results and Version Control

Generated analysis results under `results/` are intentionally version-controlled for reproducibility.

This includes the finalized Day 14 and Day 15 analytical outputs and the Day 16 figure outputs and supporting data.

The repository therefore retains the generated results associated with the documented scripts and analysis checkpoints.

## 10. Raw-Data Protection

The repository `.gitignore` contains:
- `data/raw/*`
- `data/processed/*`

The local repository verification performed for Day 18 confirms that `data/raw/` is ignored by Git.

The `results/` directory is not ignored. This is intentional because generated analysis results are version-controlled for reproducibility.

The raw source data therefore remain protected from accidental Git tracking while derived analytical results remain available for provenance and audit.

## 11. Traceability Verification

The final workflow has been checked for explicit script-to-input and script-to-output relationships.

The final traceability chain is:
`raw count matrix + metadata workbook`
- `Day 14 specimen-level expression processing`
- `Day 14 finalized specimen matrix`
- `Day 15 patient/specimen analysis`
- `Day 16 final expression figures`
- `Day 17 biological interpretation`

The Day 14 script explicitly references the raw count matrix and metadata workbook.

The Day 15 script explicitly references the Day 14 specimen-level matrix and metadata.

The four Day 16 figure scripts explicitly reference the Day 14 specimen-level matrix and metadata.

Session-information files are retained alongside the relevant generated outputs.

## 12. Reproducibility Gaps

The following limitations remain:
- The original executable Day 6 analysis script was unavailable and the reproducibility step was reconstructed explicitly as `R/day6_reconstructed_reproducibility.R`.
- Historical exploratory analyses from earlier project days were not all regenerated from the raw data during the finalization phase.
- Public metadata do not definitively resolve whether repeated RNA-seq libraries represent independent biological specimens, technical replicates, separate extractions, or repeated sequencing.
- The project depends on the availability and integrity of the original local raw input files, which are intentionally excluded from Git.
- Exact package environments are documented through session-information files, but a formal lockfile or containerized environment has not been created.
- The project has not established a fully automated end-to-end workflow manager or single command that regenerates every historical and final result from the raw inputs.
- External database and annotation resources used for exploratory enrichment are version-documented through the Day 8 session information, but their external availability may change over time.
These gaps do not invalidate the documented descriptive analysis, but they define the limits of exact environment recreation and full historical rerunability.

## 13. Reproducibility Status

The final descriptive analysis has a documented chain from raw input specification through scripts, generated outputs, session information, interpretation, and Git history.

The final specimen-level expression matrix and Figures 1–4 have explicit script and input provenance.

The project is therefore reproducibly documented at the level required for the completed descriptive exploratory analysis, subject to the remaining gaps listed above.
