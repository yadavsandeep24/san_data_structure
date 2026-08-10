# Appendix D — Quick Self-Check Answer Key

Concise answers matching Self-Check numbering in chapters **1–23**.

---

## Chapter 1 — Why Data Structures Matter

**1.1** A 16 ms frame is the 60 Hz budget. An O(n) array scan for membership can blow that budget as n grows; a hash set keeps “contains?” near O(1) so scroll/bind stays within the frame.

**1.2** Examples: parsing multi-MB JSON, decoding bitmaps, diffing large lists, building search indexes — O(n) but allocation-heavy; run off the UI thread.

**1.3** False. A set of the same IDs often uses *more* memory per element (hash table overhead) than a compact list; you trade space for faster membership.

**1.4** Cell recycling only helps native views. Nested loops in JS still run on the JS thread and can stall bridge updates / interactions even if rows recycle.

**1.5** The API promises operations (get, push, contains) *and* asymptotic costs; choosing a structure is choosing that cost contract.

---

## Chapter 2 — Big-O

**2.1** O(n) is an upper bound (≤ c·n). Θ(n) is tight: both O(n) and Ω(n). People say “O(n)” loosely for Θ(n) linear scans.

**2.2** Constants and allocations matter on mobile: GC/ARC pressure, cache misses, and memory spikes can make a “better” Big-O feel worse for moderate n.

**2.3** Yes — Σᵢ₌₀ⁿ i = Θ(n²).

**2.4** Build O(n) once, then 10k × O(1) lookups ⇒ O(n + 10k) ≈ O(n) setup + O(1) per query; describe both phases.

**2.5** ~8.3 ms/frame. O(n) on the UI thread becomes intolerable sooner than at 60 Hz.

---

## Chapter 3 — Arrays

**3.1** Append usually hits free capacity (amortized O(1) with rare resize). Insert at 0 shifts every element ⇒ O(n).

**3.2** Geometric growth makes total copy cost across n appends O(n); constant growth (+k each time) yields O(n²) copies.

**3.3** False. Builders need O(1) index into *your* model; a linked list still forces O(n) walks per index.

**3.4** Fewer resizes ⇒ fewer large allocations/copies during load ⇒ less jank and GC.

**3.5** Contiguous memory improves CPU cache locality during bind/scroll; fewer pointer-chasing stalls than node-based lists.

---

## Chapter 4 — Linked Lists

**4.1** Arrays compute address from index; lists must walk `next` pointers.

**4.2** When you already hold the node: doubly linked can unlink in O(1) via `prev`; singly needs the predecessor.

**4.3** Key **2** is evicted: after `get(1)`, order is 2 (LRU) then 1 (MRU); `put(3)` evicts LRU = 2.

**4.4** Examples: `LruCache`, `NSCache`, image-loader memory caches, `LinkedHashMap` access-order.

**4.5** Floyd uses O(1) extra memory; a `HashSet` of nodes uses O(n) space — painful on low-RAM devices.

---

## Chapter 5 — Stacks

**5.1** Gesture spam can push/pop many times per frame; O(n) stack ops would jank or drop frames.

**5.2** It is a stack of view controllers; the **top** is the visible VC.

**5.3** Walk (undo stack holds *inverse* ops; redo cleared on a new edit):

| Step | Document | Undo stack | Redo stack |
|------|----------|------------|------------|
| type A | A | [invA] | [] |
| type B | A,B | [invA, invB] | [] |
| undo | A | [invA] | [B] |
| type C | A,C | [invA, invC] | [] |

**5.4** Deep/untrusted depth (JSON, view trees, graphs) risk stack overflow — use explicit stacks/queues.

**5.5** `java.util.Stack` is synchronized legacy `Vector`; `ArrayDeque` is faster, clearer as stack/deque.

---

## Chapter 6 — Queues / Deques

**6.1** Each `removeFirst` is O(n); 10k events ⇒ O(n²) shifting.

**6.2** The main looper is a FIFO message queue: enqueue messages, dequeue and dispatch.

**6.3** Each element moves at most once from in-stack to out-stack; amortized O(1) per enqueue/dequeue.

**6.4** The maximum of the current window (indices monotonic, values decreasing in the classic deque).

**6.5** Drop-oldest when newer samples supersede (live location); keep newest telemetry.

---

## Chapter 7 — Hash Tables

**7.1** Load factor ≈ entries/buckets; resize when high to keep chains short and ops ~O(1).

**7.2** Equal keys must share hash buckets; unequal hashes for equal keys break lookup.

**7.3** Need insertion/access order (LRU, predictable iteration) — `LinkedHashMap`.

**7.4** Dedupe feed IDs, download URLs, or analytics event keys with a set/map.

**7.5** Average O(1); worst O(n) (degenerate collisions).

---

## Chapter 8 — Sets

**8.1** Hash-backed membership probes a bucket in expected constant time.

**8.2** When you need uniqueness *and* stable iteration/order (chips, recent unique tags).

**8.3** Iterate the smaller set; probe the larger — O(min(|A|,|B|)).

**8.4** That marks the start of a run; otherwise you’d recount the same streak many times.

**8.5** Selected IDs, muted conversations, downloaded chapter IDs, blocked users.

---

## Chapter 9 — Trees Basics

**9.1** Root: no parent. Leaf: no children. In this book’s interview style, `maxDepth(null)=0` and a leaf/single node counts as depth **1** (node count on the path). Edge-count height (leaf = 0) is fine if you state it.

**9.2** In-order.

**9.3** FIFO discovers nodes level by level; recursion alone is DFS-shaped.

**9.4** View hierarchy, file picker folders, JSON objects, settings sections.

**9.5** O(n) time for n nodes.

---

## Chapter 10 — Trees Practical

**10.1** Left subtree keys &lt; node &lt; right (consistent duplicate policy).

**10.2** Parent-only checks miss ancestor constraints (e.g. right child of left subtree too large).

**10.3** `search` requires end-of-word flag; `startsWith` only needs the path to exist.

**10.4** Shared prefix nodes store each character once across many words — less RAM than storing full strings separately.

**10.5** e.g. `tags[1]` or `tags.1` depending on path convention → `"b"`.

---

## Chapter 11 — Graphs Intro

**11.1** A tree is an undirected acyclic connected graph (n−1 edges); general graphs may have cycles and multiple components.

**11.2** Sparse graphs: adj list uses O(V+E) vs matrix O(V²).

**11.3** First time you reach a node is via a minimum number of edges (FIFO layers).

**11.4** Follow graph, deep-link routing, task dependencies, one-way streets in maps.

**11.5** O(V + E).

---

## Chapter 12 — Caching

**12.1** Bitmaps are large; unbounded growth → jetsam/OOM despite fast lookups.

**12.2** **LRU** keeps the freshly prefetched window (recency = the scan). **LFU** better protects a *previously* hot set against that one-time pollution, but may leave cold-but-frequent noise in cache after the burst.

**12.3** Same URL decoded at different sizes/transforms are different bitmaps — wrong key ⇒ wrong pixels or huge oversized images.

**12.4** Disk hit: promote into memory. Critical memory warning: trim/clear memory; keep disk.

**12.5** TTL only expires by time; many fresh entries can still exhaust RAM without capacity eviction.

---

## Chapter 13 — List Rendering

**13.1** Full reload treats rows as new; loaders cancel/restart because identity was thrown away.

**13.2** Identity = same entity (stable ID). Contents = fields changed (needs rebind).

**13.3** Index keys remount widgets when order shifts — text fields lose focus/state.

**13.4** Offset pagination duplicates/skips rows when new items insert at the head; cursors stay stable.

**13.5** Array (order / random access) + Set (seen IDs for dedupe).

---

## Chapter 14 — Decision Guide

**14.1** **Set** — O(1) membership per bind; array `contains` is O(n) per row.

**14.2** When you need O(1) index for `itemBuilder` — linked lists make indexing O(n).

**14.3** Feed/chat: array order + set of IDs; cart: line order + map of SKU→qty.

**14.4** LIFO / “only care about the most recent end” → stack (undo, back navigation).

**14.5** Without eviction/bounds, memory grows without limit → OOM despite O(1) get/put.

---

## Chapter 15 — Searching & Sorting

**15.1** Unsorted, dynamic ID sets with many lookups — hash map O(1) avg without sorting cost.

**15.2** Lower bound of 5 → index of first 5 (2). Upper bound → first &gt; 5 (index 4 → 7).

**15.3** Platform sorts are tuned/tested; app QuickSort risks bugs, worst-case O(n²), wasted effort.

**15.4** Lexicographic string sort (`"10" < "2"`); numbers need `(a,b) => a-b`.

**15.5** Merge two sorted change streams like merge-sort merge — O(n+m) sync without full resorted.

---

## Chapter 16 — Recursion & Backtracking

**16.1** Base case, progress toward base, recursive call(s).

**16.2** Elegant for view trees, but unbounded depth can overflow the call stack on mobile.

**16.3** Restores state so sibling branches see a clean slate.

**16.4** Deep/unknown depth, or when you must cap memory and show progress — use explicit stacks.

**16.5** Reasonable: maze/level editor, form dependency resolution on small graphs. Not: unconstrained password cracking UX, huge combinatorial search on device.

---

## Chapter 17 — Greedy

**17.1** Greedy picks the locally best choice once and commits; backtracking explores and retracts.

**17.2** Coins `{1,3,4}`, amount `6`: greedy 4+1+1=3 coins; optimal 3+3=2.

**17.3** Finishing earliest frees the timeline for the most subsequent intervals (classic exchange argument).

**17.4** Farthest index reachable so far from positions in the current jump range.

**17.5** Prefetch hints, approximate ranking, timeout-bounded pathfinding — good enough UX under budget.

---

## Chapter 18 — Heaps

**18.1** Compact complete tree; parent `(i-1)/2`, children `2i+1`, `2i+2`.

**18.2** Size-k **min-heap** of the largest-so-far; root is kth largest.

**18.3** O(log n) push and pop; peek O(1).

**18.4** O(N log k) with a k-heap vs O(N log N) full sort — better when k ≪ N.

**18.5** Max-heap for lower half, min-heap for upper half; rebalance sizes so medians sit at the tops.

---

## Chapter 19 — Dynamic Programming

**19.1** Optimal substructure + overlapping subproblems.

**19.2** Memoization is top-down recursion with cache (uses call stack); tabulation is bottom-up loops (usually less stack risk).

**19.3** `dp[i] = max(dp[i-1], dp[i-2] + nums[i])` (with base cases for i=0,1).

**19.4** Greedy can trap on local coin choices; DP considers all combinations of sub-amounts.

**19.5** Image memory cache / memoized selector — caching results is not DP unless you solve overlapping *subproblems* of an optimization/counting recurrence.

---

## Chapter 20 — Graphs Advanced

**20.1** No remaining prerequisites — the module/task is ready to build or run.

**20.2** A cheaper path found later could require decreasing an already finalized distance; non-negative weights guarantee the first finalization is optimal.

**20.3** Path compression flattens trees on find; union by rank keeps trees shallow when merging — together nearly O(1) amortized.

**20.4** If `find(u) == find(v)` before union, u and v are already connected — the edge is redundant (creates a cycle).

**20.5** A cycle in the directed prerequisite graph — Kahn could not order all courses.

---

## Chapter 21 — Strings

**21.1** O(k) keying vs O(k log k) sort when alphabet is small (e.g. 26 letters).

**21.2** 2n−1 centers: n odd centers (at each index) and n−1 even centers (between adjacent indices).

**21.3** Immutable strings copy the growing prefix on each `+=`, summing 1+2+…+n = Θ(n²).

**21.4** A `Character` is an extended grapheme cluster (user-perceived character), which may span multiple Unicode scalars / UTF-8 bytes.

**21.5** JS `length` counts UTF-16 code units; a flag emoji is often two code points (four units), not one grapheme.

---

## Chapter 22 — Bits & Matrix

**22.1** `x^x=0` and `x^0=x`; pairs cancel, the unique value remains.

**22.2** Powers of two have one set bit; clearing the lowest set bit via `n&(n-1)` yields zero iff exactly one bit was set (and n>0).

**22.3** Transpose, then reverse each row.

**22.4** Each unvisited land cell starts a flood that marks the whole connected component; count how many floods you start.

**22.5** A Swift protocol for bit-flag sets (`OptionSet`) — typed masks with set algebra.

---

## Chapter 23 — Concurrency

**23.1** Correctness depends on uncontrolled timing of concurrent accesses to shared mutable state.

**23.2** Only one context ever mutates the data (thread/instance/stack) — no concurrent access, so no race and no lock needed for that data.

**23.3** All increments/reads run as serial jobs on one queue — mutations never overlap.

**23.4** Prevents unbounded buffering when producers outpace consumers (memory blowups, latency spikes).

**23.5** `await` interleaves tasks on one thread; Workers / SharedArrayBuffer / native bridges add true parallelism.

---

## Chapter 26 — Money, Idempotency & Reliability

**26.1** Binary floats cannot represent most decimals exactly (`0.1 + 0.2 ≠ 0.3`). Store **integer minor units** (`Long`) plus an ISO currency code; format only for display.

**26.2** Same payment intent → **same idempotency key** (and same semantic body). A *new* user intent (second deliberate pay) → **new key**.

**26.3** Networks give at-least-once delivery; the server dedupes by idempotency key so retries produce **one business effect** (exactly-once *effect*, not exactly-once *delivery*).

**26.4** An in-flight map keyed by intent returns the same `Future`/`Deferred` to overlapping callers, so a double-tap shares one POST instead of starting two.

**26.5** **Safe:** resume by querying status with the persisted key / intent id; replay POST only with the same key. **Unsafe:** mint a new key and POST again “to be sure,” or ignore pending and allow another charge UI path.

**26.6** **Authorize** holds/confirms with the rail; **capture** collects funds; **settlement** is inter-bank/merchant batch movement (often invisible). Pay success screen should follow **API payment status** (`succeeded`), not settlement file arrival.

**26.7** Capture/refund are **different operations** with different bodies and effects — reusing a create key risks wrong dedupe or blocked retries; use per-operation keys (e.g. `idem_capture_{payment_id}_…`).

---

## Chapter 27 — Hard Drill Bank

No Self-Check section (timed drills). Track misses in a log; re-solve after 48 hours. Approaches index: [`solutions/ch27`](../../solutions/ch27/README.md).

---

## Chapter 28 — Mobile Fintech System Design

**28.1** Redirect URLs are forgeable / incomplete; PSP and webhooks may still be in flight. **Server payment status** is source of truth after deep-link return.

**28.2** Disabling Pay is a same-process UX guard. An **Idempotency-Key** protects across retries, process death, and duplicate POSTs.

**28.3** LWW is OK for non-authoritative fields (memo/notes). Not OK for amount/currency/settlement — use **server authority** / versioning.

**28.4** Upsert by stable `txn_id`; keep newer `updated_at`; collapse push + REST by the same id.

**28.5** Benefit: harder MITM with rogue CAs. Risk: pin rotation / backup-pin failure can brick API access until an app update.

**28.6** Biometrics prove **local device user** unlocked the Pay action — not that the card network charged successfully. **3DS/SCA** proves issuer/challenge for the card rail — not session login. Neither replaces **GET payment status** or idempotency on writes.

---

## Chapter 29 — Behavioral & Product (Fintech)

**29.1** After detection: **mitigation** (stop bleeding), **fix/root cause**, **prevention** (guardrail/process).

**29.2** Debounce is same-process only; duplicates still happen via retries, timeouts, and process death — need **idempotency** and status resume.

**29.3** Examples: never store PAN/CVV; scrub PII from logs; short-lived tokens; mask account numbers; minimize analytics properties.

**29.4** Push is a **hint** (trigger fetch/upsert), not source of truth for money. Server state is authoritative; pushes can drop, delay, or duplicate.

**29.5** Do not assert law. Implement compliance/risk guidance with engineering controls (minimize data, audit, least privilege, PSP tokenization) and escalate policy questions.

---

## Appendix E — UPI & India Rails

**E.1** User may cancel, app may not resume, or debit succeeds while webhook lags — only **server payment status** is authoritative.

**E.2** **Intent:** payer app launched with prefilled payee/amount (payer approves push). **Collect:** payee/merchant requests pull; payer approves in any UPI app.

**E.3** Show honest **processing**; poll GET; offer support with `payment_id`; do **not** POST create with a new idempotency key until server confirms no payment exists.

**E.4** IMPS/NEFT/RTGS are bank-transfer rails with different latency/settlement UX — not interchangeable with in-app UPI intent “instant paid” copy.

---

Back: [Appendix C](C-collections-internals.md) · Book map: [README](../../README.md).
