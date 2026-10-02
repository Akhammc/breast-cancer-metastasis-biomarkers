# Breast cancer metastasis-associated gene expression and candidate biomarker discovery

## Abstract

In breast cancer metastasis, tumor cells leave the primary site in the breast and settle in distant organs, and the expression patterns measured there can reflect both the tumor and the tissue it landed in. This project examined gene expression in the GEO dataset GSE316391 using a descriptive, exploratory approach. It kept patient and specimen identity intact, characterized the normalized expression patterns, checked the multivariate structure, and annotated the most variable genes.

The working dataset held 32 RNA-seq libraries from 16 tissue specimens taken from 7 patients, with 26,892 genes left after expression filtering. The specimens came from breast, liver/bile duct and lung. Several libraries mapped to the same specimen, so the libraries were kept for quality control and exploration but were not counted as independent biological observations in the specimen-level summaries. Expression was normalized with TMM and converted to log-counts per million (logCPM), and libraries from the same specimen were averaged using the arithmetic mean of their normalized logCPM values.

The exploratory analysis covered expression distributions, a specimen-level principal component analysis, Euclidean sample distances, and a heatmap of the 500 most variable genes. The first two principal components explained 29.98% and 20.37% of the variance. Functional annotation tested 3,161 Gene Ontology Biological Process terms, and 306 of them had a Benjamini-Hochberg adjusted p-value below 0.05. The redundancy analysis made 46,665 pairwise comparisons between annotated terms, and 1,053 of those pairs had a Jaccard similarity of 0.5 or higher.

The results describe tissue-associated expression patterns and show that this dataset can be explored this way. They cannot establish metastasis-specific expression signatures, causal mechanisms, population-level effects or clinically validated biomarkers. The cohort is small, the libraries are repeated, tumor content is uncertain, tissue composition affects expression, the clinical metadata are incomplete, and few specimens are matched across tissues.

## 1. Introduction

Metastasis is a complicated process in which tumor cells spread from the primary tumor to distant parts of the body. Gene-expression profiling can show how tissues and specimens differ at the molecular level, and it can give hypotheses worth testing later.

This project set out to study expression patterns in the breast and metastatic tissue specimens of GSE316391 while keeping firm control over what counts as one biological observation and over the limits the available metadata impose.

It began with differential-expression and biomarker discovery in mind. The feasibility check on the statistics showed that the sample structure and metadata left very little room for inferential analysis, so the final scope became a descriptive exploratory study instead of an inferential differential-expression one.

The analysis keeps patient and specimen identity, processes the RNA-seq count matrix openly, runs library-level quality control and exploration, summarizes expression for each specimen, visualizes the multivariate structure, annotates the variable genes, and states its biological and statistical limits. It is meant as a reproducible exploratory foundation for future studies, not a definitive metastasis biomarker panel.

## 2. Dataset and cohort

### 2.1 Dataset

The analysis used GEO dataset GSE316391 with its RNA-seq count and clinical metadata files. The main count matrix was `data/raw/GSE316391\_counts\_PE.csv.gz`, which held 62,703 unique Ensembl gene identifiers and 32 RNA-seq libraries.

During data auditing, a GTEx-inclusive count matrix was also examined. It had 62,748 rows, and 45 of the Ensembl identifiers were duplicated. I did not sum the duplicate rows into the working matrix. After the duplicate copy was removed in memory, the tumor-library vectors matched the PE matrix, so the PE matrix stayed as the main input. The GTEx normal samples were left out of the project analysis. The original raw data were never modified by the workflow.

### 2.2 Cohort structure

The final working cohort had the following structure.

| Unit | Number |
|---|---:|
| Patients | 7 |
| Tissue specimens | 16 |
| RNA-seq libraries | 32 |
| Retained genes | 26,892 |

The 16 specimens fell into three tissue categories.

| Tissue site | Specimens |
|---|---:|
| Breast | 3 |
| Liver/Bile Duct | 7 |
| Lung | 6 |

A specimen was identified by `Patient # | Tissue Site | Container ID | Internal Case ID`, which keeps a sequencing library separate from the tissue specimen behind it.

### 2.3 Library-to-specimen structure

The 32 libraries mapped to 16 specimens. Most specimens had two libraries. The breast specimen from patient 2 had one, and the breast specimen from patient 3 had three.

So the analysis worked with three units. A library is a sequencing-level observation, kept for quality control and exploratory visualization. A specimen is the tissue-level unit used for the final expression summaries. A patient is the biological unit that matters for any eventual inference.

The public metadata do not say whether each repeated library came from an independent tissue piece, a separate extraction, a technical library, a resequencing run or some other repeat measurement. Because of that, repeated libraries were not treated as independent biological replicates.

## 3. Data processing and normalization

### 3.1 Count matrix preparation

The PE count matrix was checked for the expected dimensions, unique Ensembl identifiers, valid library columns, agreement between the library identifiers in the count matrix and the clinical metadata, and missing or invalid values. Before expression filtering, the working matrix had 62,703 unique Ensembl gene rows and 32 library columns.

### 3.2 Expression filtering

A gene was kept when its CPM was above 1 in at least two libraries. This was applied before normalization and the exploratory analysis, and it left 26,892 genes.

### 3.3 TMM normalization

Libraries were normalized with the trimmed mean of M-values (TMM) method in edgeR. The normalized library sizes were then used to calculate logCPM values with a prior count of 2. This normalized logCPM matrix is the basis for all the exploratory analyses.

### 3.4 Specimen-level summarization

For the specimen-level analysis, normalized logCPM values were averaged across the libraries of each specimen. For each gene and specimen,

\[
\text{Specimen expression}
=
\frac{1}{n}
\sum\_{i=1}^{n}
\text{normalized logCPM}\_{i}
\]

where \(n\) is the number of libraries for that specimen. The averaging happened after library-level normalization, so the normalized values were never summed as if they were raw counts. The library-level normalized values were kept for quality control, PCA, distance analysis and provenance.

## 4. Quality control and exploratory expression analysis

### 4.1 Library-level expression assessment

After filtering and TMM normalization I summarized each library by its size, normalization factor, effective library size, number of retained genes, and descriptive statistics of normalized logCPM. The aim was to describe how expression was distributed across the libraries, not to set a statistical cutoff for excluding samples.

### 4.2 Specimen-level expression distributions

The final specimen-level matrix had 26,892 genes and 16 specimens, with no missing and no non-finite values. Expression distributions were plotted for all 16 specimens to check the overall structure after the libraries were consolidated into specimens.

### 4.3 Principal component analysis

The PCA used the specimen-level normalized expression matrix restricted to the 500 most variable genes. It was centered but not scaled. PC1 explained 29.98% of the variance and PC2 explained 20.37%, which is about 50.34% together.

The PCA is descriptive. Where specimens separate or sit close together, that shows how the expression is structured. It is not evidence of a statistically significant tissue effect or of a metastasis-specific molecular program.

### 4.4 Specimen-distance analysis

Euclidean distances between all 16 specimens were calculated from the normalized logCPM matrix. The result is a 16 × 16 symmetric matrix with zeros on the diagonal and no missing or non-finite values. The distance heatmap shows patterns of similarity and dissimilarity among the specimens.

### 4.5 Variable-gene heatmap

The 500 genes with the highest variance across the 16 specimens were selected for the heatmap. These are simply the most variable genes in this dataset, and they were not chosen by a differential-expression test. For display, each gene was standardized so the patterns across specimens could be compared on one scale.

## 5. Functional annotation

### 5.1 Gene Ontology Biological Process analysis

The 500 most variable genes were annotated as an exploratory step. The analysis tested 3,161 Gene Ontology Biological Process terms, and 306 of them passed the Benjamini-Hochberg adjusted p-value threshold of 0.05. The enrichment was used to see which biological themes show up among the highly variable genes.

None of these terms proves that a given pathway drives breast cancer metastasis. The genes were picked for their overall variability across mixed tissues, and tissue composition can account for a large part of that variability.

### 5.2 GO-term redundancy

To check how much the significant terms overlap, pairwise Jaccard similarity was calculated. The final artifact had 46,665 pairwise comparisons. Of these, 1,053 pairs had a Jaccard similarity of at least 0.5, split into 123 pairs with a similarity of exactly 1 and 930 pairs between 0.5 and 1. The other 45,612 pairs fell below 0.5.

So a good share of the significant GO terms contain largely the same genes, and the count of significant terms is not a count of independent biological processes. The annotation stays exploratory and descriptive.

## 6. Patient and specimen structure

### 6.1 Patient-level organization

The 16 specimens came from seven patients.

| Patient | Specimens | Tissue sites | Libraries |
|---|---:|---|---:|
| P1 | 3 | Breast, Liver/Bile Duct, Lung | 6 |
| P2 | 2 | Breast, Liver/Bile Duct | 3 |
| P3 | 3 | Breast, Liver/Bile Duct, Lung | 7 |
| P4 | 2 | Liver/Bile Duct, Lung | 4 |
| P5 | 2 | Liver/Bile Duct, Lung | 4 |
| P6 | 2 | Liver/Bile Duct, Lung | 4 |
| P7 | 2 | Liver/Bile Duct, Lung | 4 |

### 6.2 Matched tissue availability

The number of patients with specimens from both tissues of a pair was uneven.

| Tissue pair | Patients with both tissues |
|---|---:|
| Breast and Liver/Bile Duct | 3 |
| Breast and Lung | 2 |
| Liver/Bile Duct and Lung | 6 |

Patient 3 is the only patient with all three tissue sites.

### 6.3 Tumor-content uncertainty

The metadata describe the breast specimen from patient 2 as `Invasive ductal carcinoma (NO MALIGNANCY DIAGNOSED / NO TUMOR SEEN)`. That description should not be quietly turned into a general rule that the specimen has no tumor. More broadly, tumor content was not fully established for the specimens, and I treat unknown tumor content as an open limitation, not as evidence that tumor is absent.

### 6.4 Biological unit of interpretation

The patient is the biological unit for any population-level inference. The 32 libraries are not 32 patients and not 32 independent biological replicates. Averaging to the specimen level lowers the influence of repeated sequencing records on the descriptive summaries, but it adds no biological replication.

## 7. Biological interpretation

The analyses show substantial expression variation among the 16 specimens. The PCA, distance matrix, expression distributions and variable-gene heatmap each describe that variation from a different angle. None of them can say by itself whether the differences come from metastatic status, tissue of origin, cellular composition, tumor purity, immune infiltration, stromal content, necrosis, or other biological and technical factors.

That matters more here because tissue and disease context are tied together in this dataset. The breast specimens are primary tissue, while the liver/bile duct and lung specimens are the metastatic sites in the project design. A tissue-associated difference therefore cannot be read automatically as a metastasis-specific one. The functional annotation has the same problem, since an enriched process is not shown to cause metastasis or to belong only to metastatic disease.

What the analysis does support is that expression varies measurably across breast, liver/bile duct and lung specimens, that a defined set of genes is highly variable across the 16 specimens, that these genes map to many enriched Gene Ontology Biological Process terms, and that some of those terms share much of their gene content. The patterns give hypotheses for later work.

What it does not establish is a metastasis-specific gene-expression signature, a causal mechanism of metastasis, a population-level tissue effect, diagnostic sensitivity or specificity, prognostic value, treatment-response prediction, or a clinically validated biomarker.

## 8. Limitations

### 8.1 Small patient cohort

The dataset has only seven patients, and the matched comparisons are smaller still. Three patients have both breast and liver/bile duct specimens, two have both breast and lung, and six have both liver/bile duct and lung. This limits how far the descriptive patterns can be generalized.

### 8.2 Repeated libraries

There are 32 libraries but only 16 specimens, and the public metadata do not fully explain how the repeated libraries relate to each other. Treating all 32 as independent would risk pseudoreplication, so the main descriptive expression analysis uses specimen-level summaries.

### 8.3 Tissue composition

Bulk RNA-seq measures the RNA of every cell in the sample. Epithelial, stromal, immune, vascular and necrotic components all affect the expression pattern, so a gene or pathway tied to one tissue may reflect its cell composition and not metastasis biology.

### 8.4 Tumor content

The metadata describe tumor content only in part. The patient 2 breast specimen is explicitly annotated as no tumor seen, and the other specimens have incomplete information. This makes it hard to read expression differences as differences in malignant-cell biology.

### 8.5 Clinical metadata

The clinical information is incomplete. Primary breast receptor annotations exist for only some patients, metastatic receptor information is limited or missing, and treatment histories are incomplete. Clinical heterogeneity therefore cannot be fully built into the interpretation.

### 8.6 Confounding between tissue and disease context

Primary breast tissue and metastatic tissue are different anatomical contexts, and this dataset cannot cleanly separate tissue identity from metastatic status. It is the main biological limit on reading tissue-associated differences as metastasis-specific effects.

### 8.7 Functional annotation

GO enrichment shows statistical over-representation among the selected variable genes. It does not show pathway activation, causality or metastasis specificity. Correlated and overlapping terms also mean that several significant terms can describe nearly the same biology, which the Jaccard redundancy analysis confirmed.

### 8.8 Reproducibility

The final exploratory workflow has documented inputs, scripts, outputs, software versions and Git provenance. A single end-to-end workflow that runs from the raw input to every final output has not been demonstrated, though. Some earlier analyses were reconstructed or carried over from previous project stages and were not regenerated from the original inputs. This is separate from the verified final Day 14 to 16 exploratory pipeline.

## 9. Reproducibility

The final analysis ran in a documented computational environment, with the project kept in a version-controlled repository. The main environment was R 4.6.1 on Windows 11 with edgeR 4.10.5, limma 3.68.5, readxl 1.5.0 and ggplot2 4.0.3. The functional annotation stage also used clusterProfiler 4.20.0, org.Hs.eg.db 3.23.1 and AnnotationDbi 1.74.0.

The provenance chain for the final exploratory analysis was:
```text
GSE316391 count matrix
&#x20;       +
RNA-seq clinical metadata
&#x20;       ↓
library-level QC and normalization
&#x20;       ↓
26,892-gene normalized logCPM matrix
&#x20;       ↓
specimen-level mean normalized logCPM
&#x20;       ↓
16-specimen expression matrix
&#x20;       ↓
patient/specimen structure analysis
&#x20;       ↓
final exploratory figures
```
The final outputs sit in the project's `results/` directory and are tracked with Git, and the `.gitignore` configuration keeps the raw input directories out of version control. The reproducibility record lists the inputs, scripts, software versions, output structure, Git provenance and the known gaps.

## 10. Conclusion

This project built a documented and reproducible descriptive framework for studying gene-expression variation in the GSE316391 breast cancer and metastatic tissue dataset. The final analysis covered 32 RNA-seq libraries from 16 specimens from seven patients, with 26,892 genes retained. Libraries were normalized and quality checked, then averaged to the specimen level using mean normalized logCPM. PCA, distance analysis, expression distributions and the variable-gene heatmap described the expression structure across the specimens. Functional annotation found 3,161 Gene Ontology Biological Process terms, 306 of which met the adjusted significance threshold, and the redundancy analysis showed heavy overlap among a subset of them.

The main contribution is a reproducible description of tissue-associated expression patterns, along with a plain account of the dataset's biological and statistical limits. The findings generate hypotheses only, and this dataset cannot support metastasis-specific biomarkers, causal mechanisms, population-level effects, diagnostic or prognostic performance, or treatment-response biomarkers.

Testing candidate genes as metastasis-associated biomarkers would need larger cohorts with clearly defined biological replication, fuller tumor-content and clinical metadata, suitable inferential designs, independent validation cohorts, and orthogonal experimental validation.
