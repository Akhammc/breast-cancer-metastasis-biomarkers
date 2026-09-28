# Data Integrity Audit

Date: 2026-09-29
Status: VERIFIED — tumor count matrix reconciliation

## Source files

- GSE316391_counts_PE.csv.gz
- GSE316391_RNA_counts_Met_plus_GTEX.csv.gz

Original source files were not modified.

## Gene identifier audit

- PE matrix: 62,703 rows and 62,703 unique Ensembl gene IDs.
- GTEx-inclusive matrix: 62,748 rows and 62,703 unique Ensembl gene IDs.
- All 62,703 unique gene IDs are shared between matrices.
- The GTEx-inclusive matrix contains 45 duplicated gene IDs, each occurring twice.
- All 45 duplicated pairs have identical annotations and identical counts across all 32 tumor libraries.

## Count reconciliation

After removing one copy of each verified duplicate in memory and aligning rows by Ensembl gene ID:

- 62,703 genes were aligned.
- All 32 tumor library count vectors matched exactly.
- Total differing gene-sample entries: 0.
- All 32 sample count totals matched.

The R49 liver sample is labeled R49LIV_2 in the PE matrix and R49_4-Liver_Tumor in the GTEx-inclusive matrix. The count vectors match under the positional mapping, but the biological sample identity requires confirmation against the clinical metadata.

## Analysis implications

- The PE matrix is the provisional tumor count source, pending sample metadata and design validation.
- The original source files remain unchanged.
- Duplicate rows must not be summed.
- GTEx normal samples are excluded from the primary tumor analysis pending a separately justified design.
- No differential expression analysis has been performed.
- Biological independence, specimen relationships, pairing, collection times, and confounders remain unresolved.

## Scripts

- R/audit_gene_ids.R
- R/compare_matrices.R
- R/inspect_duplicate_genes.R
- R/reconcile_matrices.R
- R/verify_duplicate_counts.R

## Decision status

Matrix-level reconciliation: VERIFIED.
Final analysis matrix and statistical design: NOT FROZEN.
