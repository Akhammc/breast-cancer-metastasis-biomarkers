# Breast Cancer Metastasis-Associated Gene Expression

## Project status

Day 10 - exploratory feasibility and reproducibility documentation.

The project has completed initial data integrity, descriptive expression, exploratory PCA, expression summary, and GO enrichment analyses. The current approved scope is descriptive and exploratory.

## Research source

- GEO accession: GSE316391
- Official record: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE316391

## Research objective

To characterize tissue-associated gene-expression patterns and data limitations in the available breast, liver, and lung libraries, and assess the feasibility of further research.

The project does not currently support inferential claims about metastasis-associated expression differences or clinical biomarkers.

## Approved scope

As documented in D007 and D008 of `docs/decision_log.md`:

- Descriptive and exploratory expression analysis only.
- No differential-expression testing or inferential tissue-effect modeling.
- No causal, clinical biomarker, or population-level claims.
- Libraries are not treated as independent biological replicates.
- Patient and specimen structure, tumor content, and replicate independence remain important limitations.

Any change to the approved scope requires an explicit decision.

## Analysis workflow

| Day | Analysis | Script |
|---|---|---|
| 4 | Exploratory PCA and sample distances | `R/day4_exploratory_pca.R` |
| 5 | Descriptive expression summaries | `R/day5_expression_summaries.R` |
| 8 | Exploratory GO BP over-representation analysis | `R/day8_go_enrichment.R` |
| 9 | GO term gene-list overlap review | `R/day9_go_redundancy.R` |

Additional data integrity, statistical feasibility, and mapping audits are documented in `docs/`.

## Reproducibility

Analytical workflows are implemented in R scripts. The scripts, research progress log, decision log, and relevant software-version records document analysis methods and decisions.

The Day 8 enrichment used the expression-filtered gene universe and the 500 most variable genes across mixed-tissue libraries. Day 9 compared reported gene lists using pairwise Jaccard similarity.

Generated enrichment CSV outputs are retained locally and are not tracked in Git. They can be regenerated using the corresponding scripts and verified input data.

Raw input data must remain unchanged. Analysis outputs must be interpreted in light of their documented inputs, parameters, software versions, and limitations.

## Key documentation

- `docs/decision_log.md` - approved decisions and scope
- `docs/research_progress_log.md` - chronological research activities
- `docs/data_integrity_audit.md` - input and sample structure audit
- `docs/statistical_feasibility_report.md` - statistical feasibility and limitations

## Data handling

Raw data and sensitive sample-level metadata must not be committed without review. Generated outputs are subject to the repository's ignore rules and project data-handling restrictions.

## Status convention

PLANNED, EXECUTED, VERIFIED, FROZEN, SUPERSEDED.
