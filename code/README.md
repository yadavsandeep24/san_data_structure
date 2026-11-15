# Code: snippet tests and samples

## Snippet tests (`verify_snippets.py`)

The book's code lives in Markdown. This harness pulls every ` ```kotlin `, ` ```dart ` and ` ```typescript ` block out of a chapter and its solutions, joins them with a test in [`snippet-tests/`](snippet-tests/), and compiles and runs the result. If a snippet in the book breaks, the test fails.

```bash
python3 code/verify_snippets.py            # every covered chapter
```

```bash
python3 code/verify_snippets.py ch14 ch16  # just these
```

| Target | Covers |
|--------|--------|
| `ch13`–`ch17` | Core Patterns chapters (worked examples + all practice solutions) |
| `ch21` | "Binary search on the answer" section |

Tests mostly compare each snippet against a brute-force version on hundreds of random inputs.

**Toolchains:** `node` (and `tsc` for type-checking; otherwise Node 22.6+ runs with `--experimental-strip-types`), `dart`, and `kotlinc` + `java`. A language without its toolchain is reported as `SKIP`. Swift snippets aren't run automatically, so keep them in step with the Kotlin versions by review.

**Adding a chapter:** add an entry to `TARGETS` in `verify_snippets.py` and create `snippet-tests/chNN/test.{ts,dart,kt}`. Each test file calls the snippet functions by name and throws on a mismatch. Function names must be unique across the chapter and its solutions file, because everything is compiled together.

## Reference samples + smoke script

Small standalone sketches that mirror chapter patterns:

| File | Chapter | Notes |
|------|---------|-------|
| `*/unique*` | 3 | Order-preserving unique IDs |
| `kotlin/TopK.kt` (`kLargest`) | 12 | Size-k min-heap → k largest values |
| `swift/KLargest.swift` | 12 | Same |
| `dart/k_largest.dart` | 12 | Same |
| `typescript/kLargest.ts` | 12 | Same |

```bash
./code/run_smoke.sh
```

Requires whichever interpreters you have installed (`node`, `dart`, `swift`, `kotlinc`/`kotlin`). Missing tools are skipped with a warning.
