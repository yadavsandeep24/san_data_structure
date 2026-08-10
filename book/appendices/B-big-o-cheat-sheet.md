# Appendix B — Big-O Master Cheat Sheet

Quick reference for interviews and code review. Assume average-case for hash structures unless noted. “Mobile note” flags UI-thread risk.

---

## Common structures & operations

| Structure | Access | Search | Insert | Delete | Space | Mobile note |
|-----------|--------|--------|--------|--------|-------|-------------|
| Dynamic array (`ArrayList` / `Array` / `List`) | O(1) | O(n) | Amort. O(1) end; O(n) middle/front | O(n) | O(n) | Default UI list backbone |
| Static array | O(1) | O(n) | — | — | O(n) | Fixed buffers, ring slots |
| Singly linked list | O(n) | O(n) | O(1) at known node | O(1)* | O(n) | *need prev; poor locality |
| Doubly linked list | O(n) | O(n) | O(1) at known node | O(1) | O(n) | LRU node unlink |
| Stack (array-backed) | top O(1) | O(n) | O(1) push | O(1) pop | O(n) | Nav / undo |
| Queue / deque (ring or two-stack) | ends O(1) | O(n) | O(1) | O(1) | O(n) | Avoid `shift`/`removeFirst` on arrays |
| Hash map / dictionary | — | O(1) avg / O(n) worst | O(1) avg | O(1) avg | O(n) | Membership & indexes |
| Hash set | — | O(1) avg | O(1) avg | O(1) avg | O(n) | Selected IDs, dedupe |
| Sorted map / TreeMap | — | O(log n) | O(log n) | O(log n) | O(n) | Ordered keys |
| Binary heap | peek O(1) | O(n) | O(log n) | O(log n) pop | O(n) | Priority work |
| BST (balanced) | — | O(log n) | O(log n) | O(log n) | O(n) | Prefer platform sorted maps |
| BST (skewed) | — | O(n) | O(n) | O(n) | O(n) | Interview trap |
| Trie | — | O(L) | O(L) | O(L) | O(Σ·nodes) | Autocomplete; L = key length |
| Graph adj. list | — | — | O(1) edge | O(deg) | O(V+E) | Default graph |
| Graph adj. matrix | — | edge O(1) | O(1) | O(1) | O(V²) | Tiny dense only |

---

## Algorithm families

| Family | Typical time | Extra space | Use when |
|--------|--------------|-------------|----------|
| Linear scan | O(n) | O(1)–O(n) | One pass, small n on UI |
| Two pointers | O(n) | O(1) | Sorted arrays, palindrome, containers |
| Sliding window | O(n) | O(Σ) | Substring / subarray constraints |
| Prefix sums | O(n) build, O(1) query | O(n) | Range sums |
| Binary search | O(log n) | O(1) | Sorted monotonic predicates |
| Sorting (comparison) | O(n log n) | O(1)–O(n) | Prefer platform sort |
| Counting / radix | O(n + k) | O(k) | Small integer domains |
| DFS (graph/tree) | O(V+E) / O(n) | O(h) or O(V) | Connectivity, cycles, paths |
| BFS | O(V+E) | O(V) | Shortest unweighted path, levels |
| Dijkstra | O((V+E) log V)* | O(V) | *binary heap; weighted non-neg |
| Topological sort | O(V+E) | O(V) | Build order, course prereqs |
| Union-Find | ~O(α(n)) | O(n) | Components, provinces |
| Heap select (top-k) | O(n log k) | O(k) | Leaderboards, kth |
| Greedy | often O(n log n) sort | varies | Intervals, jump game (when proven) |
| DP (1D/2D) | O(n)–O(n·W) | can optimize | Overlapping subproblems |
| Backtracking | exponential | O(depth) | Small search spaces only |
| String KMP/Z | O(n+m) | O(n+m) | Pattern search (rare in app code) |

---

## Complexity ↔ mobile frame budget

| Budget | Rough ceiling |
|--------|----------------|
| 60 Hz frame | ~16 ms |
| 120 Hz frame | ~8 ms |
| Comfortable main-thread DSA | O(1) / O(visible) / tiny O(log n) |
| Risky on main | O(n) at n ≥ 10⁴–10⁵ with allocations |
| Almost never on main | O(n²), heavy sorts of huge lists, JSON parse of MBs |

---

## Amortized & average vs worst

| Claim | Meaning |
|-------|---------|
| Amortized O(1) append | Occasional O(n) resize; average per op O(1) over many appends |
| Average O(1) hash | Expected with good hash; pathological O(n) chains/trees |
| O(h) tree | Height; balanced ⇒ log n, skewed ⇒ n |

---

## Recurrence cheat (interview)

| Recurrence | Closed form |
|------------|-------------|
| T(n) = T(n/2) + O(1) | O(log n) |
| T(n) = T(n/2) + O(n) | O(n) |
| T(n) = 2T(n/2) + O(n) | O(n log n) |
| T(n) = T(n−1) + O(1) | O(n) |
| T(n) = T(n−1) + T(n−2) + O(1) | O(φⁿ) without memo; O(n) with DP |

Keep this sheet open while drilling Chapter 24. Next: [Appendix C — Collections Internals](C-collections-internals.md).
