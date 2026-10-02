# Breast Cancer Metastasis-Associated Gene Expression and Candidate Biomarker Discovery

## Project status

**Completed — descriptive exploratory analysis**

This project investigates gene-expression patterns across breast and metastatic tissue specimens from GEO dataset **GSE316391**.

The final analysis is intentionally descriptive and exploratory. It characterizes expression structure, patient/specimen organization, tissue-associated variation, and functional annotation while explicitly accounting for the limitations of the available cohort and metadata.

The project does **not** claim to identify or validate a metastasis-specific biomarker.

---

## Research objective

The original project was initiated around differential gene expression and biomarker discovery in breast cancer metastasis.

During statistical feasibility assessment, the structure of the available data showed that inferential analysis could not be responsibly supported within the project scope. The project was therefore refocused into a descriptive exploratory study.

The final objective was:

> **To characterize tissue-associated gene-expression patterns in the available breast, liver/bile duct, and lung specimens while preserving patient and specimen structure and documenting the statistical and biological limitations of the dataset.**

---

## Dataset

- **GEO accession:** GSE316391
- **Primary count matrix:** `data/raw/GSE316391_counts_PE.csv.gz`
- **RNA-seq libraries:** 32
- **Tissue specimens:** 16
- **Patients:** 7
- **Genes retained after expression filtering:** 26,892

The 16 specimens consisted of:

| Tissue site | Specimens |
|---|---:|
| Breast | 3 |
| Liver/Bile Duct | 7 |
| Lung | 6 |

The 32 sequencing libraries mapped to 16 tissue specimens. Multiple libraries therefore belong to the same specimen and were not treated as independent biological replicates.

---

## Analytical approach

### 1. Count-matrix preparation

The PE count matrix was validated for:

- expected dimensions
- unique Ensembl identifiers
- valid library identifiers
- agreement with clinical metadata
- missing or invalid values

A GTEx-inclusive count matrix was also audited. It contained 62,748 rows with 45 duplicated Ensembl identifiers. Duplicate rows were not summed into the working matrix. After removing the duplicate copy in memory, the tumor-library vectors matched the PE matrix, which was retained as the primary input.

GTEx normal samples were excluded from the project analysis.

---

### 2. Expression filtering and normalization

Genes were retained when their CPM was greater than 1 in at least two libraries.

This resulted in **26,892 retained genes**.

Library sizes were normalized using the **trimmed mean of M-values (TMM)** method in edgeR, followed by calculation of normalized logCPM values using a prior count of 2.

---

### 3. Specimen-level expression summarization

Normalized logCPM values were averaged across libraries belonging to the same specimen.

The final descriptive expression matrix therefore represents:

**26,892 genes × 16 specimens**

The original library-level normalized values were retained for quality control, exploratory analyses, and provenance.

The patient remains the biological unit relevant to any future inferential analysis.

---

## Exploratory analyses

### Expression distributions

Expression distributions were examined across all 16 specimens after normalization and specimen-level consolidation.

### Principal component analysis

PCA was performed on the 500 most variable genes across the 16 specimens.

- **PC1:** 29.98%
- **PC2:** 20.37%
- **PC1 + PC2:** approximately 50.34%

The PCA is descriptive and is not interpreted as evidence of a statistically significant tissue effect or metastasis-specific expression program.

### Specimen-distance analysis

Euclidean distances were calculated between all 16 specimens using the normalized logCPM matrix.

The resulting distance matrix was:

- 16 × 16
- symmetric
- zero on the diagonal
- free of missing and non-finite values

### Variable-gene heatmap

The 500 genes with the highest variance across the 16 specimens were visualized using a specimen-level heatmap.

These genes were selected for overall variability, not through differential-expression testing.

---

## Functional annotation

An exploratory Gene Ontology Biological Process over-representation analysis was performed using the highly variable gene set.

The analysis included:

- **3,161 GO Biological Process terms tested**
- **306 terms with BH-adjusted p < 0.05**

GO-term redundancy was then examined using pairwise Jaccard similarity.

Among **46,665 pairwise comparisons**:

- 1,053 had Jaccard similarity ≥ 0.5
- 123 had Jaccard similarity = 1
- 930 had similarity ≥ 0.5 and < 1
- 45,612 had similarity < 0.5

These results are exploratory. Enriched GO terms do not demonstrate pathway activation, causality, or metastasis specificity.

---

## Patient and specimen structure

The project explicitly preserves the distinction between sequencing libraries, tissue specimens, and patients.

| Unit | Number |
|---|---:|
| Patients | 7 |
| Specimens | 16 |
| Libraries | 32 |

Matched tissue availability was:

| Tissue pair | Patients with both tissues |
|---|---:|
| Breast — Liver/Bile Duct | 3 |
| Breast — Lung | 2 |
| Liver/Bile Duct — Lung | 6 |

Patient 3 is the only patient represented at all three tissue sites.

The public metadata do not establish whether repeated libraries represent independent tissue pieces, separate extractions, technical libraries, resequencing, or other repeated measurements. For this reason, repeated libraries were not treated as independent biological replicates.

---

## Biological interpretation

The analysis demonstrates measurable expression variation across the available specimens and provides a descriptive view of how the samples are organized in expression space.

However, tissue identity and disease context are closely connected in this dataset: breast specimens represent primary tissue, while liver/bile duct and lung specimens represent metastatic sites in the project design.

Therefore, a tissue-associated expression difference cannot automatically be interpreted as a metastasis-specific effect.

Bulk RNA-seq also reflects tissue composition, including epithelial, stromal, immune, vascular, and other cellular components. Tumor content is incompletely documented, and one breast specimen is explicitly annotated as **"NO TUMOR SEEN."**

---

## What this project does and does not establish

### Supported by the analysis

- Descriptive expression patterns across 16 specimens
- Patient/specimen organization of the dataset
- Exploratory multivariate expression structure
- Identification of highly variable genes
- Exploratory functional annotation
- Documentation of important data and biological limitations
- A reproducible record of the final descriptive analysis

### Not established by the analysis

- A metastasis-specific gene-expression signature
- Causal mechanisms of metastasis
- Population-level tissue effects
- Differential-expression significance
- Diagnostic performance
- Prognostic value
- Treatment-response prediction
- A clinically validated biomarker

---

## Key limitations

The major limitations are:

1. **Small patient cohort** — only seven patients are represented.
2. **Repeated libraries** — 32 libraries correspond to only 16 specimens.
3. **Limited matched specimens** — matched tissue availability varies substantially between tissue pairs.
4. **Tumor-content uncertainty** — tumor content is incompletely established.
5. **Bulk tissue composition** — expression reflects mixtures of cellular populations.
6. **Incomplete clinical metadata** — receptor, treatment, and metastatic clinical information are limited.
7. **Tissue/metastatic-context confounding** — tissue identity cannot be cleanly separated from metastatic status.
8. **Exploratory functional annotation** — GO enrichment does not establish pathway activation or causality.

---

## Reproducibility

The analysis was performed in a documented R environment:

- R 4.6.1
- edgeR 4.10.5
- limma 3.68.5
- readxl 1.5.0
- ggplot2 4.0.3

The functional annotation stage additionally used:

- clusterProfiler 4.20.0
- org.Hs.eg.db 3.23.1
- AnnotationDbi 1.74.0

The main provenance chain is:

```text
GSE316391 count matrix
        +
RNA-seq clinical metadata
        ↓
library-level QC and normalization
        ↓
26,892-gene normalized logCPM matrix
        ↓
specimen-level mean normalized logCPM
        ↓
16-specimen expression matrix
        ↓
patient/specimen structure analysis
        ↓
final exploratory figures
        ↓
biological interpretation
        ↓
final report