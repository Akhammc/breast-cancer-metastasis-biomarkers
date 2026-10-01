# Final Biological Interpretation

## 1. Purpose and Scope

This document provides the final biological interpretation of the descriptive exploratory RNA-seq analysis of the audited GSE316391 breast-cancer tissue dataset.

The interpretation is aligned with D007/D008 and is intentionally limited to what can be supported descriptively by the available expression data and metadata.

The analysis characterizes tissue-associated gene-expression patterns across the audited patient specimens. It does not establish metastasis-specific molecular effects, causal mechanisms, population-level effects, or clinically validated biomarkers.

## 2. Supported Descriptive Observations

The finalized expression dataset contains 26,892 retained genes measured across 16 patient-tissue specimens from 7 patients. The 16 specimens represent Breast, Liver/Bile Duct, and Lung tissue.

The expression data were normalized at the library level using TMM normalization followed by normalized logCPM transformation. Where multiple RNA-seq libraries mapped to the same patient-tissue specimen, their normalized logCPM values were summarized using the arithmetic mean to obtain the finalized specimen-level expression matrix.

The four final expression figures provide complementary descriptive views of this dataset:

- Figure 1 shows the distributions of normalized logCPM values across the 16 specimens.

- Figure 2 shows the exploratory PCA structure of the 16 specimen-level expression profiles using the 500 genes with the greatest variance across specimens.

- Figure 3 shows pairwise Euclidean expression distances among the 16 specimens using all 26,892 retained genes.

- Figure 4 shows the expression patterns of the 500 most variable genes across the 16 specimens.

These figures demonstrate that the audited dataset contains measurable variation in gene expression across patient-tissue specimens. The analyses describe the structure of that variation but do not statistically attribute it to metastasis, tissue identity, treatment, or another biological factor.

## 3. Patient-Level Structure

Patient identity is an important component of the interpretation.

The dataset contains 7 patients contributing 16 patient-tissue specimens and 32 recorded RNA-seq libraries. Several patients contribute specimens from more than one tissue site.

Matched tissue availability is limited:

- Breast-Liver/Bile Duct: 3 patients

- Breast-Lung: 2 patients

- Liver/Bile Duct-Lung: 6 patients

Only a small subset of the available patients therefore contributes matched specimens across particular tissue pairs.

Patient 3 is the only patient represented at all three tissue sites in the audited RNA-seq dataset.

Because multiple specimens can originate from the same patient, expression patterns cannot be interpreted as if all 16 specimens represented independent individuals.

## 4. Repeated Libraries and Biological Independence

The 32 RNA-seq libraries map to 16 patient-tissue specimens. Some specimens are represented by multiple libraries.

The available public metadata do not definitively establish whether these repeated libraries represent independent biological specimens, technical replicates, separate RNA extractions, or repeated sequencing of the same material.

Therefore, the repeated libraries were not treated as independent biological observations.

For the final descriptive expression matrix, repeated libraries belonging to the same specimen were summarized by the arithmetic mean of their normalized logCPM values.

This approach preserves the specimen as the primary unit of the final descriptive expression analysis while retaining the original library-level data for quality-control and exploratory analyses.

## 5. Limited Matched Specimens

The presence of matched tissue specimens provides patient-aware descriptive context, but the number of matched specimens is small.

In particular, the strict documented-tumor scenario leaves only one patient with documented tumor status for each of the Breast-Liver/Bile Duct, Breast-Lung, and Liver/Bile Duct-Lung matched comparisons.

This structure is insufficient for reliable population-level inference about tissue differences or metastasis-associated expression.

The matched specimens can therefore be used to describe individual patient/tissue expression patterns and to identify observations that may motivate future investigation, but not to establish general tissue effects.

## 6. Tumor-Content Uncertainty

Tumor content is incompletely characterized in the available metadata.

Unknown tumor content should not be interpreted as absence of tumor. At the same time, uncertainty about tumor content limits the biological interpretation of expression differences between specimens.

Patient 2's breast specimen is explicitly annotated as having no tumor seen. It remains represented in the descriptive analysis rather than being silently removed.

For other specimens where tumor content is unknown, the expression profiles may reflect varying proportions of malignant cells and non-malignant tissue.

Consequently, observed expression differences cannot automatically be attributed to differences in malignant-cell biology.

## 7. Tissue Composition

Bulk RNA-seq expression profiles represent RNA from the material present in each tissue specimen.

Differences in tissue composition, cellularity, stromal content, immune-cell contribution, necrosis, and other specimen characteristics can contribute to observed expression variation.

The available analysis does not independently resolve these components.

Accordingly, tissue-associated expression patterns should be interpreted as properties of the measured tissue specimens rather than as direct measurements of tumor-cell-specific transcriptional programs.

## 8. Clinical Metadata Limitations

Clinical metadata are incomplete for several variables relevant to biological interpretation.

Primary breast receptor annotations are available for only part of the cohort, while metastatic receptor status is not consistently available. Treatment histories are incomplete, and tumor content is uncertain for many specimens.

These limitations prevent reliable assessment of treatment-associated expression changes, receptor-defined biological subgroups, or relationships between expression patterns and clinical outcomes.

The present analysis therefore does not attempt clinical stratification or clinical biomarker validation.

## 9. Biological Interpretation

The principal supported biological interpretation is that the audited specimens exhibit heterogeneous gene-expression profiles across patients and tissue sites.

The PCA, specimen-distance analysis, expression distributions, and variable-gene heatmap provide complementary descriptions of this heterogeneity.

Patterns observed in these analyses may reflect combinations of patient-specific biology, tissue identity, cellular composition, tumor content, specimen characteristics, and technical factors.

Because these factors are not independently resolved in the available dataset, the observed expression structure cannot be assigned uniquely to metastatic biology.

Genes showing high variability across specimens may represent exploratory candidate signals for subsequent investigation. However, variability alone does not establish biological relevance to metastasis and does not establish biomarker validity.

## 10. Hypotheses for Future Investigation

The descriptive expression patterns can motivate hypotheses for future research.

Potential hypotheses include:

- Some genes may show tissue-associated expression patterns that warrant investigation in larger and better-controlled cohorts.

- Some highly variable genes may reflect biological differences between patient-tissue specimens and could be evaluated as candidate markers in independent datasets.

- Patient-specific expression structure may contribute substantially to the observed variation and should be incorporated explicitly into any future inferential analysis.

- Differences in tissue composition or tumor content may explain part of the observed expression heterogeneity and should be evaluated with appropriate cellular-composition or pathology information where available.

These are hypotheses generated from descriptive structure, not findings established by statistical testing in the present analysis.

## 11. What Cannot Be Concluded

The current analysis cannot establish:

- that a particular gene is specifically associated with breast-cancer metastasis;

- that an observed expression difference is caused by metastatic progression;

- that a gene or gene set drives metastatic spread;

- that an expression pattern represents a tumor-cell-specific metastatic program;

- that observed patterns generalize to the wider breast-cancer population;

- that a candidate gene has predictive, diagnostic, prognostic, or therapeutic clinical utility;

- that any candidate expression signal is a clinically validated biomarker;

- that treatment caused an observed expression pattern;

- or that tissue-associated expression differences represent causal biological mechanisms.

No differential-expression testing or inferential tissue comparison was performed under the approved D007/D008 scope.

## 12. Overall Interpretation

The completed analysis provides a reproducible descriptive characterization of gene-expression variation across 16 audited patient-tissue specimens from 7 patients.

The strongest supported conclusion is that the dataset contains heterogeneous, tissue-associated and patient-associated expression structure that can be visualized at the specimen level.

The analysis also establishes important constraints for any future inferential work: patient-level dependence must be respected, repeated-library independence remains unresolved, matched specimens are limited, tumor content is uncertain, tissue composition may contribute substantially to bulk expression patterns, and clinical metadata are incomplete.

The results therefore provide an exploratory foundation for candidate biomarker research rather than a validated set of breast-cancer metastasis biomarkers.

Any future analysis intended to make inferential claims about metastasis-associated expression, causal mechanisms, population effects, or clinical biomarkers would require an explicitly documented scope change and appropriate statistical and biological validation.
