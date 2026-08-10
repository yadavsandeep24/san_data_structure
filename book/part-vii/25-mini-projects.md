# Chapter 25 — Mini Projects

Six portfolio-sized projects that force you to *compose* structures from Parts II–VI the way production mobile code does. Each project lists goals, required data structures, acceptance criteria, stretch goals, and a link to reference sketches.

Work in your primary language first, then port critical paths to a second language. Keep main-thread work O(1) / O(visible) where noted.

Full reference architectures: **[`solutions/ch25/README.md`](../../solutions/ch25/README.md)**

---

## Project 1 — LRU Image Memory Cache

**Goals:** Bound decoded-image (or byte-buffer) memory with O(1) `get` / `put` and LRU eviction. Mimic what Coil/Glide/SDWebImage do in the hot path—without disk I/O.

**Required DS:** Hash map (key → node) + doubly linked list (recency order), *or* language LRU primitive (`LruCache`, access-order `LinkedHashMap`) used deliberately.

**Acceptance criteria:**
- Capacity `C` entries; `put` when full evicts least-recently-used.
- `get` refreshes recency; missing key returns null/optional.
- Operations average O(1); no unbounded growth.
- Unit tests: capacity 2 sequence `put(1), put(2), get(1), put(3)` ⇒ key `2` gone, `1` present.

**Stretch:** TTL per entry; size-weighted capacity (bytes); `trimToSize` on memory warning; thread-safe wrapper.

→ [`solutions/ch25` §P1](../../solutions/ch25/README.md#p1-lru-image-memory-cache)

---

## Project 2 — Autocomplete Trie

**Goals:** Typeahead over a static dictionary (contacts, tickers, city names) with prefix query returning up to `k` suggestions.

**Required DS:** Trie (prefix tree) with children map/array; end-of-word flag; optional subtree hit counts.

**Acceptance criteria:**
- `insert(word)`, `startsWith(prefix)`, `suggest(prefix, k)` .
- `suggest` is O(prefix + visited) with early stop at `k`.
- Case-folding policy documented (e.g. lowercase on insert/query).
- Works offline on a bundled word list ≥ 1k entries without UI jank when queried on a background isolate/thread (UI only receives results).

**Stretch:** Weighted suggestions (frequency); deletion; fuzzy edit-distance-1; persistence snapshot.

→ [`solutions/ch25` §P2](../../solutions/ch25/README.md#p2-autocomplete-trie)

---

## Project 3 — Offline-First Feed with Pagination + Diff

**Goals:** Local ordered feed buffer that merges remote pages, dedupes by ID, supports cursor pagination, and emits a minimal diff for the UI list.

**Required DS:** Array (order) + Set/Map (id → index or entity); cursor token; diff result (insert/remove/update ops).

**Acceptance criteria:**
- `applyPage(items, nextCursor, prepend|append)` dedupes by stable `id`.
- No duplicate IDs in the visible array after merge.
- `diff(oldSnapshot, newSnapshot)` uses identity (id) not index keys.
- Scroll-up loads older (prepend) without scrambling viewport identities.

**Stretch:** Conflict policy (server wins / LWW); SQLite persistence; partial updates; animated diff application.

→ [`solutions/ch25` §P3](../../solutions/ch25/README.md#p3-offline-first-feed)

---

## Project 4 — Task Scheduler with Priority Queue

**Goals:** Schedule background jobs (upload, sync, analytics flush) by priority and optional earliest-start time.

**Required DS:** Binary heap (priority queue); tie-break by sequence number for stability.

**Acceptance criteria:**
- `schedule(task, priority)` and `next()` / `runNext()` in O(log n).
- Higher priority runs first; equal priority is FIFO.
- Cancel by id (lazy deletion or heap + map).
- Simulated clock: tasks with `notBefore` stay unrun until due.

**Stretch:** Fairness / aging; rate limit per task type; persistence across process death.

→ [`solutions/ch25` §P4](../../solutions/ch25/README.md#p4-task-scheduler)

---

## Project 5 — Navigation Back Stack Simulator

**Goals:** Model app navigation: push, pop, replace, pop-to-root, and deep-link reset—with O(1) top access.

**Required DS:** Stack (array-backed); optional secondary stack for “forward” if you model browser-style history.

**Acceptance criteria:**
- `push` / `pop` / `peek` / `replaceTop` / `popToRoot`.
- Pop on empty is a safe no-op or typed error (document choice).
- Serialize stack to route list for state restoration.
- Property: after any sequence, `peek` is the last successfully pushed, not-yet-popped route.

**Stretch:** Parallel tab stacks; result-passing (`pop` with result); middleware guards.

→ [`solutions/ch25` §P5](../../solutions/ch25/README.md#p5-navigation-back-stack)

---

## Project 6 — Thread-Safe Request Coalescer

**Goals:** In-flight dedupe: concurrent callers requesting the same key share one network/load promise; later callers await the same result.

**Required DS:** Concurrent map (key → shared in-flight future/deferred); mutex/lock or actor/single-queue discipline.

**Acceptance criteria:**
- Two overlapping `load(key)` calls trigger **one** producer function.
- After completion, map entry is removed so the next call may refresh.
- Errors fail all waiters; retry is a new call.
- Stress test: 100 coroutines/tasks same key ⇒ single fetch.

**Stretch:** TTL single-flight; stale-while-revalidate; per-key rate limit; cancellation when all waiters cancel.

→ [`solutions/ch25` §P6](../../solutions/ch25/README.md#p6-request-coalescer)

---

## Suggested build order

1 → 5 → 2 → 4 → 6 → 3 (cache and stack warm up structures; feed diff is richest).

## Grading yourself

| Stars | Meaning |
|-------|---------|
| ★★☆ | Acceptance met in one language |
| ★★★ | + tests + complexity notes |
| ★★★★ | + second language port |
| ★★★★★ | + stretch goals + README demo GIF/notes |

Back: [Chapter 24](24-interview-questions.md) · Solutions: [`solutions/ch25`](../../solutions/ch25/README.md) · Next: [Chapter 26 — Money, Idempotency & Client Reliability](../part-viii/26-money-idempotency-reliability.md) (top fintech track).
