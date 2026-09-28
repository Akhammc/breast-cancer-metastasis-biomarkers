# Statistical Feasibility and Descriptive Analysis Report

Date: 2026-09-29
Status: VERIFIED — approved by user on 2026-09-29

## 1. Project scope

The project will proceed as a descriptive, exploratory investigation of tissue-associated gene-expression patterns in the GSE316391 breast cancer metastasis dataset.

The user selected descriptive scope (Decision D007).

Differential-expression testing and inferential statistical modeling are outside the current scope. No causal, clinical biomarker, or population-level claims will be made.

## 2. Data and specimen structure

The provisional tumor count source is the paired-end (PE) count matrix.

- The PE matrix contains 62,703 rows with unique Ensembl gene identifiers.
- The GTEx-inclusive matrix contains 62,748 rows, including 45 duplicated identifiers.
- After removing one copy of each duplicated row in memory, all 32 tumor library count vectors match the PE matrix exactly.
- Duplicate rows will not be summed.
- GTEx normal samples are excluded from the current project scope.

The audited data contain 32 RNA-seq libraries corresponding to 16 patient-tissue specimens from seven patients.

The public metadata do not establish whether repeated libraries represent independent tissue pieces, RNA extractions, technical replicates, or resequencing. The 32 libraries map to 16 recorded patient-tissue specimens. Repeated libraries must not be silently counted as independent biological observations or patients in descriptive summaries.

## 3. Patient-level tissue availability

| Tissue comparison | All matched patients | Tumor documented at both sites |
|---|---:|---:|
| Breast–liver | 3 | 1 |
| Breast–lung | 2 | 1 |
| Liver–lung | 6 | 1 |

Patient 3 is the only patient with documented tumor content at all three tissue sites.

Unknown tumor content does not establish absence of tumor. The documented-tumor scenario is a sensitivity description and does not constitute an approved specimen exclusion rule.

## 4. Clinical and biological limitations

- Primary breast receptor annotations are available for three patients; metastatic receptor status is not documented in the audited records.
- Tumor content is unknown for most metastatic specimens.
- Treatment histories are incomplete and do not consistently establish treatment timing relative to specimen collection.
- Patient 2's breast specimen is annotated as "No Tumor Seen."
- Tissue cellular composition, necrosis, and tumor purity may affect observed expression patterns.
- The audited workbook and matrix contain seven patients; this should not be conflated with broader patient counts described in the GEO series summary.

These limitations constrain interpretation of tissue-associated expression differences.

## 5. Feasibility assessment

The matched patient counts are small, particularly for primary breast versus metastatic tissue.

Under the strict scenario requiring documented tumor content at both sites, each tissue comparison has only one matched patient. This supports descriptive case-level inspection, not population-level inference.

The broader matched scenarios contain more patients but include specimens with unknown tumor content and unresolved library independence. They do not remove the need for careful specimen-level review.

The liver–lung comparison has six matched patients in the broad scenario, but tumor content is documented at both sites for only one patient.

## 6. Current analysis boundaries

Permitted within the selected scope, subject to review:

- Descriptive summaries of audited sample and specimen characteristics.
- Quality-control summaries and visualizations that preserve patient and specimen identity.
- Exploratory expression summaries with transparent reporting of normalization, filtering, and replicate handling. The normalization method and the level of summarization (library, specimen, or patient) must be documented and reviewed before execution; no method is approved yet.
- Case-level descriptions that do not imply population-level statistical significance.

Not authorized under the current scope:

- Differential-expression testing.
- Inferential statistical modeling of tissue effects.
- Treating sequencing libraries as independent biological replicates.
- Clinical biomarker claims, causal claims, or population-level conclusions.

Any expression summary must first undergo a documented review of the analysis matrix, sample mapping, and handling of repeated libraries.

## 7. Outstanding work

1. Approval completed and recorded in decision D008; no further report approval is pending.
2. Review the provisional analysis matrix and library-to-specimen mapping for descriptive use.
3. Define and document quality-control and descriptive summarization procedures before running them.
4. Keep differential-expression testing outside the scope unless the user explicitly revises Decision D007.

## 8. Supporting records

- `docs/data_integrity_audit.md`
- `docs/decision_log.md`
- `docs/research_progress_log.md`
- Patient-level eligibility results: `results/tables/day3_specimen_eligibility.csv`
- Day 3 feasibility scripts under `R/`
