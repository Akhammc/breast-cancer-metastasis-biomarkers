# Final Analysis Specification

## 1. Purpose

This document defines the final analytical specification for the breast cancer metastasis project after the approved D007/D008 scope decision and the Day 12 chronological QC/reproducibility audit.

The project will proceed as a descriptive, exploratory feasibility investigation of tissue-associated gene-expression patterns and data limitations in GSE316391.

This specification is the controlling analytical plan for the remaining project work.

## 2. Approved scientific scope

The project is descriptive and exploratory.

The analysis is intended to characterize:

- audited sample, specimen, and patient structure;
- descriptive gene-expression patterns;
- exploratory expression-profile structure;
- exploratory functional annotation;
- reproducibility and data limitations.

The following are outside the approved scope:

- differential-expression testing;
- inferential statistical modeling of tissue effects;
- population-level inference;
- causal inference;
- clinical biomarker validation or clinical biomarker claims.

No result will be presented as evidence of a clinically validated metastasis biomarker.

## 3. Dataset and source matrix

The project uses GSE316391 as the selected dataset.

The provisional tumor count source is the paired-end (PE) count matrix:

`data/raw/GSE316391_counts_PE.csv.gz`

The PE matrix contains 62,703 rows with unique Ensembl gene identifiers and 32 tumor RNA-seq libraries.

The GTEx-inclusive matrix is not used for the final analysis. Its 45 duplicated gene identifiers are not summed.

GTEx normal samples are excluded from the current project scope.

The source count files remain immutable.

## 4. Biological units and sample hierarchy

The audited data contain:

- 32 RNA-seq libraries;
- 16 patient-tissue specimens;
- 7 patients.

A specimen is represented by the existing project mapping:

`Patient # | Tissue Site | Container ID | Internal Case ID`

The existing Day 4 workflow constructs `specimen_id` using these four fields.

Multiple sequencing libraries can map to the same patient-tissue specimen.

Public metadata do not establish whether repeated libraries represent independent tissue pieces, RNA extractions, technical replicates, or resequencing.

Therefore:

- libraries are retained as sequencing-level observations for QC and exploratory visualization;
- libraries are not treated as independent biological replicates;
- specimen is the primary unit for final descriptive expression aggregation;
- patient is the biological unit for interpretation and matched-tissue/case-level descriptions.

## 5. Repeated-library handling

For final specimen-level descriptive expression summaries, repeated libraries belonging to the same specimen will be summarized by the arithmetic mean of normalized logCPM values for each gene.

The aggregation is performed after the established library-level normalization and logCPM transformation.

This aggregation is descriptive only.

It does not imply that the underlying libraries are independent biological replicates and does not create an inferential statistical model.

The original library-level values remain available for QC, PCA, sample-distance visualization, and provenance.

## 6. Patient and tissue structure

The final analysis will preserve the documented patient-level tissue structure.

Documented broad matched-patient availability is:

| Tissue comparison | All matched patients | Tumor documented at both sites |
|---|---:|---:|
| Breast-liver | 3 | 1 |
| Breast-lung | 2 | 1 |
| Liver-lung | 6 | 1 |

Patient 3 is the only patient with documented tumor content at all three tissue sites.

Unknown tumor content is not treated as absence of tumor.

The documented-tumor scenario is a sensitivity description and is not an approved automatic specimen-exclusion rule.

Patient 2 breast tissue is documented as "No Tumor Seen" and remains explicitly identified in descriptive summaries.

## 7. Clinical and biological metadata limitations

The final interpretation will preserve the documented limitations:

- primary breast receptor annotations are available for three patients;
- metastatic receptor status is not documented in the audited records;
- tumor content is unknown for most metastatic specimens;
- treatment histories are incomplete and do not consistently establish treatment timing relative to specimen collection;
- tissue cellular composition, necrosis, and tumor purity may affect observed expression patterns.

These limitations constrain interpretation of tissue-associated expression patterns.

## 8. Expression preprocessing

The final descriptive expression workflow will use the established Day 4/D009 processing:

1. Read the PE count matrix.
2. Validate the expected matrix structure and identifiers.
3. Construct the 32-library expression matrix.
4. Filter genes using CPM > 1 in at least 2 libraries.
5. Apply TMM normalization using edgeR.
6. Transform the retained expression matrix to logCPM using prior count 2.
7. Retain the library-level normalized expression values for QC and exploratory visualization.
8. For final specimen-level descriptive expression summaries, calculate the arithmetic mean of normalized logCPM across libraries belonging to the same specimen.

No raw counts will be summed across repeated library rows.

## 9. Exploratory expression-profile analysis

The existing exploratory visualization framework will be retained.

The final analysis will include:

- library-level PCA;
- library-level Euclidean sample-distance visualization;
- descriptive expression distributions;
- highest-variance gene summaries;
- specimen-level descriptive expression summaries.

PCA and sample-distance visualization will use the established 500 most variable retained genes.

PCA will remain centered and unscaled as in the established Day 4 workflow.

These visualizations are descriptive and exploratory.

They will not be interpreted as inferential evidence of tissue effects or metastasis-specific biology.

## 10. Variable-gene and annotation review

The final project will report descriptive summaries of expression variability across the analyzed libraries/specimens.

Ensembl gene identifiers remain the primary gene identifiers.

Gene-symbol completeness and repeated symbols will be documented.

Repeated gene symbols will not be resolved by silently collapsing or summing Ensembl identifiers.

The distinction between expression variability and biological interpretation will be maintained.

## 11. Exploratory functional annotation

The existing exploratory GO Biological Process analysis will be retained as an annotation component of the final project.

The analysis will be described as exploratory annotation of the selected expression-variable gene set.

The GO results will not be presented as:

- proof of metastasis-specific pathways;
- causal mechanisms;
- clinical biomarkers;
- population-level biological effects.

The existing GO-term redundancy review may be used to describe overlap among enriched terms.

No pathway or biological process will be presented as a statistical winner or clinical target.

## 12. Analyses explicitly excluded

The following analyses will not be performed under this specification:

- differential-expression testing;
- DESeq2/edgeR inferential tissue contrasts;
- inferential paired tissue-effect models;
- p-value-based tissue comparisons;
- treatment-effect modeling;
- causal analysis;
- population-level biomarker inference;
- clinical biomarker validation;
- claims that a gene is a validated metastasis biomarker.

Any future change to these boundaries requires an explicit new project decision.

## 13. Interpretation constraints

The final report will distinguish:

### Descriptive observations

Statements directly supported by the observed expression data, sample structure, and exploratory visualizations.

### Exploratory interpretations

Biological interpretations that are presented as hypotheses or contextual observations rather than established effects.

### Unsupported conclusions

The project will not claim that the observed patterns establish:

- a metastasis-specific gene-expression signature;
- a causal metastatic mechanism;
- a population-level tissue effect;
- a clinically useful biomarker.

The limited number of matched patients, unresolved library independence, tumor-content uncertainty, tissue composition, and incomplete clinical metadata must remain visible in the final interpretation.

## 14. Reproducibility and provenance

The final analysis must be traceable to:

- the selected raw input files;
- documented metadata mapping;
- version-controlled analysis scripts;
- generated result files;
- software and package versions;
- Git history.

Historical execution evidence must remain distinct from reconstructed reproducibility evidence.

A reconstructed workflow must never be represented as the original historical script.

Final outputs should be reproducible from the documented analysis scripts and specified inputs.

## 15. Final deliverables

The final project package should contain, as applicable:

- final analysis specification;
- final library-level QC summaries;
- final specimen-level descriptive expression summaries;
- patient/specimen structure summaries;
- final PCA and sample-distance figures;
- variable-gene summaries;
- exploratory GO annotation;
- GO redundancy summary;
- final reproducibility summary;
- final research report;
- updated progress and decision documentation.

## 16. Day 13 completion requirements

Day 13 is complete when:

- the scientific scope is frozen under D007/D008;
- the PE matrix is frozen as the provisional analysis source;
- the library/specimen/patient hierarchy is documented;
- repeated-library handling is explicitly defined;
- specimen-level aggregation is defined as the arithmetic mean of normalized logCPM;
- the established filtering, TMM normalization, logCPM transformation, and 500-variable-gene exploratory workflow are documented;
- excluded inferential analyses are explicitly listed;
- interpretation constraints are documented;
- the specification is committed to version control after review.

## 17. Scope-change rule

Any analysis that falls outside this specification must not be added implicitly.

A proposed scope change must be documented separately with:

- the scientific question;
- required data;
- biological unit;
- statistical assumptions;
- feasibility assessment;
- methodological consequences.

The user must explicitly approve the change before execution.
