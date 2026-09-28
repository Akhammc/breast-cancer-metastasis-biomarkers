# Research Decision Log

| Decision ID | Date | Decision | Rationale | Evidence | Consequences | Status |
|---|---|---|---|---|---|---|
| D001 | 2026-09-29 | Use GSE316391 as the initial candidate dataset | Matches the proposed ER-positive breast primary and liver/lung metastasis research scope | Official NCBI GEO record; cohort and files still require verification | Establish provenance and reconstruct sample-level design before analysis | PLANNED |
| D002 | 2026-09-29 | No primary contrast or statistical formula is frozen; none will be developed under the currently approved scope | Patient pairing, sample independence, and confounding were assessed for descriptive feasibility; inferential modeling is outside D007 | `docs/statistical_feasibility_report.md`; user-approved scope D007/D008 | No inferential contrast or statistical formula will be developed under D007. Reconsider only if the user explicitly revises the approved scope | VERIFIED |
| D003 | 2026-09-29 | Use the PE count matrix as the provisional tumor count source; do not sum verified duplicate gene rows | Matrix reconciliation found identical tumor counts after removing duplicate GTEx-inclusive rows in memory | `docs/data_integrity_audit.md`; commit 5df04e6 | Preserve source files; final analysis matrix remains provisional | VERIFIED |
| D004 | 2026-09-29 | Record replicate independence as unresolved due to insufficient public experimental detail | 32 libraries map to 16 patient-tissue specimens; public GEO/SRA/BioSample metadata does not establish independent tissue pieces, extractions, or technical replicates | `docs/data_integrity_audit.md`; SRA RunInfo and BioSample audit | Do not treat libraries as independent patients; account for specimen and patient structure in analysis design | VERIFIED |
| D005 | 2026-09-29 | Use the patient as the biological unit of inference | Multiple libraries map to the same recorded specimens, and multiple tissues are available from some patients | `docs/data_integrity_audit.md`; specimen eligibility audit | Statistical feasibility must be assessed at the patient level before selecting contrasts or models | VERIFIED |
| D006 | 2026-09-29 | Do not freeze a primary contrast or statistical formula until statistical feasibility is assessed | Only three patients have both breast and metastatic RNA-seq specimens; patient 2 breast specimen is annotated no tumor seen, and patient 1 breast tumor content is unknown | `docs/data_integrity_audit.md`; `docs/statistical_feasibility_report.md` | Feasibility assessment completed and report approved under D008. Differential-expression testing and inferential tissue-effect modeling remain outside the D007 scope unless the user explicitly revises it | VERIFIED |

## D007 — Select descriptive exploratory scope
- Status: VERIFIED
- Date: 2026-09-29
- Decision: Proceed with a descriptive, exploratory feasibility project focused on tissue-associated expression patterns and data limitations.
- Differential expression testing: Not authorized under this scope.
- Claims: No causal, clinical biomarker, or population-level inference.
- Rationale: Matched patient counts are small, tumor content is incompletely documented, and library independence remains unresolved.
- Authority: User-selected scope, Option A.

## D008 — Approve statistical feasibility report
- Status: VERIFIED
- Date: 2026-09-29
- Decision: Approve `docs/statistical_feasibility_report.md` as written.
- Scope: Descriptive and exploratory gene-expression investigation, as established in D007.
- Constraints: No differential-expression testing, inferential tissue-effect modeling, causal claims, clinical biomarker claims, or population-level inference under the current scope.
- Authority: Explicit user approval.
