# Code samples

Small sketches that mirror chapter patterns. Prefer in-chapter / `solutions/` snippets for study; use this folder for a quick smoke check.

| File | Chapter | Notes |
|------|---------|-------|
| `*/unique*` | 3 | Order-preserving unique IDs |
| `kotlin/TopK.kt` (`kLargest`) | 18 | Size-k min-heap → k largest values |
| `swift/KLargest.swift` | 18 | Same |
| `dart/k_largest.dart` | 18 | Same |
| `typescript/kLargest.ts` | 18 | Same |

## Smoke test

From this directory:

```bash
./run_smoke.sh
```

Requires whatever interpreters you have installed (`node`, `dart`, `swift`, `kotlinc`/`kotlin`). Missing tools are skipped with a warning.
