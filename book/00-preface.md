# Preface

Mobile apps are judged in the hand, not on a whiteboard. Users feel lag, heat, and sudden restarts long before they care about which framework you used. Under those symptoms sits a quieter layer: how you store data, how you reach it, and how much work you ask the main thread to do inside a frame.

This book teaches data structures and algorithms through that mobile lens. You will still learn Big-O, trees, graphs, and dynamic programming — the same material interviews test — but every chapter ties the idea to something you already ship: list scrolling, image caches, navigation stacks, request queues, autocomplete, offline sync, and concurrent loaders.

## Who this is for

- Android developers (Kotlin)
- iOS developers (Swift)
- Flutter developers (Dart)
- React Native developers (TypeScript)
- Engineers preparing for product-company coding interviews
- Students who want DSA grounded in real UI and performance constraints

## How chapters are built

Each chapter follows the same shape:

1. A mobile failure mode (jank, memory pressure, battery, races)
2. The structure or technique, with complexity tables
3. Platform bridges across Android, iOS, Flutter, and React Native
4. Worked examples in Kotlin, Swift, Dart, and TypeScript — often a shared warm-up in all four, then representative ports for denser patterns (full four-language solutions live under `solutions/`)
5. Mistakes that quietly slow apps
6. Self-check questions (answers in Appendix D)
7. Practice problems with full model solutions under `solutions/`

## What “model solution” means here

A model solution is not only correct code. It names the pattern, states time and space complexity, calls out edge cases, and adds a short mobile note — for example whether the work is safe on the main thread, or whether an allocation pattern will thrash under scroll.

## A note on originality

The curriculum follows the widely shared *DSA for Mobile* topic map (foundation → linear → associative → mobile systems → algorithms → advanced → practice). The prose, examples, and solutions in this repository are original teaching material written for that map.

## Suggested path

If you have eight focused weeks, use Appendix A (weeks 1–12 core). If you are mid-level and interview-bound, skim Parts I–II quickly, spend deep time on hashing, trees, caching, list diffing, heaps, and Chapter 24’s question bank. If you are senior, treat Part IV and Chapter 23 as architecture vocabulary you should be able to teach.

**Top fintech loops** (Stripe, Block, PayPal, Coinbase, major Indian fintech mobile roles): after Part VII, run **Part VIII** — money/idempotency (26), hard drills (27), system design lite (28), behavioral/product (29). Appendix A weeks 13–16 schedule that track. Before applying, complete the execution checklist in [Appendix F](appendices/F-execution-and-optional-polish.md) (reading alone is not enough).

## Modern platform defaults (2024–2026)

Examples cite both **legacy and current** UI stacks on purpose — many codebases still maintain RecyclerView, UIKit, and bridge-era RN patterns. For **new** work, assume:

| Platform | Default for new UI | Concurrency / networking |
|----------|-------------------|---------------------------|
| **Android** | Jetpack Compose (`LazyColumn` + stable `key`) | Kotlin coroutines, `Mutex`, ViewModel scope — not `GlobalScope` |
| **iOS** | SwiftUI (`Identifiable`, `@Observable`) | Swift `actor`, `async`/`await`, `@MainActor` — GCD only for legacy interop |
| **Flutter** | `ListView.builder` + keys; app state via Riverpod/Bloc (not only `setState`) | `Isolate.run` / `compute` for heavy work |
| **React Native** | Functional components + hooks; Hermes; **New Architecture** (Fabric + TurboModules/JSI) | Avoid assuming every native call is async bridge-only |

When a snippet uses `@Synchronized`, `DispatchQueue.sync`, or `.then()` chains, read it as **interview-portable** or legacy — production mobile code should prefer structured concurrency and `async`/`await` where the language supports it.

Turn the page — start with why the same contacts list can feel like glass or glue depending on the structure underneath.
