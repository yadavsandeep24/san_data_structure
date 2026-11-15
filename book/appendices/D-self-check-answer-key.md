# Appendix D — Quick Self-Check Answer Key

Concise answers matching Self-Check numbering in chapters **1–28** and **39–41** (practice chapters 29–38 and drill banks are self-checking).

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

**5.6** It is a stack of callbacks: the most recently added *enabled* callback wins; if none is enabled the system handles Back. `BackHandler` registers a callback on the same dispatcher, so the most recently composed enabled `BackHandler` wins — the same rule whether the screen is a Fragment or a composable.

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

**9.6** View parents may measure children more than once (`layout_weight`, `RelativeLayout`), so nesting multiplies measure work (up to ~2^depth), and `requestLayout` walks the whole ancestor path. Compose enforces single-pass measurement (intrinsics instead of re-measuring), so depth is roughly linear; the Compose cost to watch is how large a recomposition scope a state change invalidates.

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

## Chapter 12 — Heaps

**12.1** Compact complete tree; parent `(i-1)/2`, children `2i+1`, `2i+2`.

**12.2** Size-k **min-heap** of the largest-so-far; root is kth largest.

**12.3** O(log n) push and pop; peek O(1).

**12.4** O(N log k) with a k-heap vs O(N log N) full sort — better when k ≪ N.

**12.5** Max-heap for lower half, min-heap for upper half; rebalance sizes so medians sit at the tops.

---

## Chapter 13 — Two Pointers

**13.1** Invariant: no pair using an index outside `[lo, hi]` can be the answer. If `a[lo] + a[hi] < target`, then `a[lo]` plus any value at or below `a[hi]` is also too small (the array is sorted), so every pair that uses `lo` can be discarded and `lo++` is safe. The mirror argument covers `hi--`.

**13.2** Each `removeAt(i)` shifts every later element left, which is O(n). Doing it inside an O(n) loop gives O(n²). Replace it with a read/write compaction: copy kept items to `a[write++]`, then truncate once (or use `removeAll { }` / `removeAll(where:)` / `removeWhere`, which do exactly that).

**13.3** `fast` moves two nodes per step and `slow` moves one, so `slow` has always covered half of `fast`'s distance. When `fast` reaches the end, `slow` is at the middle.

**13.4** Hash map. Two pointers needs sorted input, and sorting destroys the original indices (unless you sort index pairs at O(n log n)). A value→index map gives O(n) time with the original indices.

**13.5** No auxiliary allocation means no GC/ARC pressure during scroll or binding, and a lower peak memory on low-RAM devices. Same Big-O time, smoother frames.

---

## Chapter 14 — Sliding Window

**14.1** `right` moves forward n times and `left` only ever moves forward, at most n times in total. The inner `while` loop's work is shared across all steps (amortized), so the total is O(2n) = O(n).

**14.2** Shrinking assumes that removing an element moves the window toward valid. With negative numbers, removing an element can **increase** the sum, so the rule isn't monotonic and the window can skip the answer. Use prefix sums plus a hash map (Chapter 15).

**14.3** Inside the shrink loop: while the window is valid (sum ≥ target), record `right - left + 1`, then shrink to try for something shorter.

**14.4** A map from character to count, plus its size (distinct count). On leave: decrement the count. If it reaches 0, remove the key (distinct drops by 1). Shrink while distinct > k.

**14.5** O(k) per frame plus a new array each time (GC churn). Keep a ring buffer of the last 60 values and a running sum: add the new value, subtract the evicted one, O(1) with no allocation.

---

## Chapter 15 — Prefix Sums & Difference Arrays

**15.1** `prefix[i]` is the sum of the first `i` elements (`a[0 until i]`). The extra leading `prefix[0] = 0` makes ranges starting at index 0 use the same formula, with no special case.

**15.2** `sum(a[l..r]) = prefix[r + 1] − prefix[l]`.

**15.3** A window relies on shrinking always moving toward valid, and negative numbers break that. The hash map approach uses `prefix[r+1] − prefix[l] = k` and looks up `count[current − k]`, which doesn't depend on the values' signs.

**15.4** A difference array: `diff[l] += v; diff[r + 1] −= v` per update (O(1)), then one running-sum pass. O(q + n) total instead of O(q · n).

**15.5** When values change often between queries. A prefix array must be rebuilt (O(n)) after each change. A Fenwick tree supports both update and range-sum in O(log n).

---

## Chapter 16 — Monotonic Stack & Deque

**16.1** Decreasing from bottom to top. When a larger value arrives, it pops every smaller value, and the larger value is exactly the "next greater" of each popped item. Items still on the stack are waiting for something bigger.

**16.2** Each index is pushed once and popped at most once, so the total number of pops across the whole run is ≤ n. The inner loop's work is O(n) in total, not per iteration.

**16.3** On pop: the popped item learns its **next** greater or smaller (the current element). Used for next-greater, days-until-warmer and histogram right boundaries. After popping: the remaining top is the current element's **previous** greater or smaller. Used for spans and left boundaries.

**16.4** A smaller element that arrived earlier will leave the window **before** the newer, larger one, so it can never be the window max again. Discarding it keeps the deque decreasing and small.

**16.5** Indices give distances (`i − top`), let you check whether an item has left the window (deque), and tell duplicates apart. You can always look up the value from the index.

---

## Chapter 17 — Intervals & Sweep Line

**17.1** The interval that ends earliest leaves the most room for the rest. By an exchange argument, replacing any optimal solution's first choice with the earliest-ending interval never causes a conflict. Sorting by start fails when an early-starting interval is very long (`[1,100)` blocks `[2,3)` and `[4,5)`).

**17.2** End events first. With half-open intervals, `[1,3)` and `[3,5)` don't overlap, so the end at 3 must be processed before the start at 3. Sorting `(time, delta)` with end = −1 does this automatically.

**17.3** `a1 < b2 && b1 < a2`.

**17.4** When times are small discrete integers (minutes in a day, seat positions 0..1000). A difference array over the range costs O(n + range) with no sort, and no heap or event list.

**17.5** Sorting in place mutates the list the UI is rendering. The UI may see the reorder without being notified, diffing can break (old and new are the same object), and in Compose/SwiftUI shared mutable state can cause stale or inconsistent frames. Copy, then sort.

---

## Chapter 18 — Caching

**18.1** Bitmaps are large; unbounded growth → jetsam/OOM despite fast lookups.

**18.2** **LRU** keeps the freshly prefetched window (recency = the scan). **LFU** better protects a *previously* hot set against that one-time pollution, but may leave cold-but-frequent noise in cache after the burst.

**18.3** Same URL decoded at different sizes/transforms are different bitmaps — wrong key ⇒ wrong pixels or huge oversized images.

**18.4** Disk hit: promote into memory. Critical memory warning: trim/clear memory; keep disk.

**18.5** TTL only expires by time; many fresh entries can still exhaust RAM without capacity eviction.

---

## Chapter 19 — List Rendering

**19.1** Full reload treats rows as new; loaders cancel/restart because identity was thrown away.

**19.2** Identity = same entity (stable ID). Contents = fields changed (needs rebind).

**19.3** Index keys remount widgets when order shifts — text fields lose focus/state.

**19.4** Offset pagination duplicates/skips rows when new items insert at the head; cursors stay stable.

**19.5** Array (order / random access) + Set (seen IDs for dedupe).

**19.6** `areItemsTheSame` → `items(key = { it.id })`. `areContentsTheSame` → recomposition skipping of a row whose stable parameters are equal. `getChangePayload` → no explicit API: only composables that read the changed field recompose, so split the row (e.g. a `LikeIcon` reading `liked`).

---

## Chapter 20 — Decision Guide

**20.1** **Set** — O(1) membership per bind; array `contains` is O(n) per row.

**20.2** When you need O(1) index for `itemBuilder` — linked lists make indexing O(n).

**20.3** Feed/chat: array order + set of IDs; cart: line order + map of SKU→qty.

**20.4** LIFO / “only care about the most recent end” → stack (undo, back navigation).

**20.5** Without eviction/bounds, memory grows without limit → OOM despite O(1) get/put.

---

## Chapter 21 — Searching & Sorting

**21.1** Unsorted, dynamic ID sets with many lookups — hash map O(1) avg without sorting cost.

**21.2** Lower bound of 5 → index of first 5 (2). Upper bound → first &gt; 5 (index 4 → 7).

**21.3** Platform sorts are tuned/tested; app QuickSort risks bugs, worst-case O(n²), wasted effort.

**21.4** Lexicographic string sort (`"10" < "2"`); numbers need `(a,b) => a-b`.

**21.5** Merge two sorted change streams like merge-sort merge — O(n+m) sync without full resorted.

**21.6** (1) The answer lies in a known numeric range, and (2) a cheap `feasible(x)` check is monotonic: once true it stays true as `x` grows (or the reverse). Then you lower-bound search for the first feasible `x`.

---

## Chapter 22 — Recursion & Backtracking

**22.1** Base case, progress toward base, recursive call(s).

**22.2** Elegant for view trees, but unbounded depth can overflow the call stack on mobile.

**22.3** Restores state so sibling branches see a clean slate.

**22.4** Deep/unknown depth, or when you must cap memory and show progress — use explicit stacks.

**22.5** Reasonable: maze/level editor, form dependency resolution on small graphs. Not: unconstrained password cracking UX, huge combinatorial search on device.

---

## Chapter 23 — Greedy

**23.1** Greedy picks the locally best choice once and commits; backtracking explores and retracts.

**23.2** Coins `{1,3,4}`, amount `6`: greedy 4+1+1=3 coins; optimal 3+3=2.

**23.3** Finishing earliest frees the timeline for the most subsequent intervals (classic exchange argument).

**23.4** Farthest index reachable so far from positions in the current jump range.

**23.5** Prefetch hints, approximate ranking, timeout-bounded pathfinding — good enough UX under budget.

---

## Chapter 24 — Dynamic Programming

**24.1** Optimal substructure + overlapping subproblems.

**24.2** Memoization is top-down recursion with cache (uses call stack); tabulation is bottom-up loops (usually less stack risk).

**24.3** `dp[i] = max(dp[i-1], dp[i-2] + nums[i])` (with base cases for i=0,1).

**24.4** Greedy can trap on local coin choices; DP considers all combinations of sub-amounts.

**24.5** Image memory cache / memoized selector — caching results is not DP unless you solve overlapping *subproblems* of an optimization/counting recurrence.

---

## Chapter 25 — Graphs Advanced

**25.1** No remaining prerequisites — the module/task is ready to build or run.

**25.2** A cheaper path found later could require decreasing an already finalized distance; non-negative weights guarantee the first finalization is optimal.

**25.3** Path compression flattens trees on find; union by rank keeps trees shallow when merging — together nearly O(1) amortized.

**25.4** If `find(u) == find(v)` before union, u and v are already connected — the edge is redundant (creates a cycle).

**25.5** A cycle in the directed prerequisite graph — Kahn could not order all courses.

---

## Chapter 26 — Strings

**26.1** O(k) keying vs O(k log k) sort when alphabet is small (e.g. 26 letters).

**26.2** 2n−1 centers: n odd centers (at each index) and n−1 even centers (between adjacent indices).

**26.3** Immutable strings copy the growing prefix on each `+=`, summing 1+2+…+n = Θ(n²).

**26.4** A `Character` is an extended grapheme cluster (user-perceived character), which may span multiple Unicode scalars / UTF-8 bytes.

**26.5** JS `length` counts UTF-16 code units; a flag emoji is often two code points (four units), not one grapheme.

---

## Chapter 27 — Bits & Matrix

**27.1** `x^x=0` and `x^0=x`; pairs cancel, the unique value remains.

**27.2** Powers of two have one set bit; clearing the lowest set bit via `n&(n-1)` yields zero iff exactly one bit was set (and n>0).

**27.3** Transpose, then reverse each row.

**27.4** Each unvisited land cell starts a flood that marks the whole connected component; count how many floods you start.

**27.5** A Swift protocol for bit-flag sets (`OptionSet`) — typed masks with set algebra.

---

## Chapter 28 — Concurrency

**28.1** Correctness depends on uncontrolled timing of concurrent accesses to shared mutable state.

**28.2** Only one context ever mutates the data (thread/instance/stack) — no concurrent access, so no race and no lock needed for that data.

**28.3** All increments/reads run as serial jobs on one queue — mutations never overlap.

**28.4** Prevents unbounded buffering when producers outpace consumers (memory blowups, latency spikes).

**28.5** `await` interleaves tasks on one thread; Workers / SharedArrayBuffer / native bridges add true parallelism.

---

## Chapter 30 — Hard Drill Bank

No Self-Check section (timed drills). Track misses in a log; re-solve after 48 hours. Approaches index: [`solutions/ch30`](../../solutions/ch30/README.md).

---

## Chapter 39 — Money, Idempotency & Reliability

**39.1** Binary floats cannot represent most decimals exactly (`0.1 + 0.2 ≠ 0.3`). Store **integer minor units** (`Long`) plus an ISO currency code; format only for display.

**39.2** Same payment intent → **same idempotency key** (and same semantic body). A *new* user intent (second deliberate pay) → **new key**.

**39.3** Networks give at-least-once delivery; the server dedupes by idempotency key so retries produce **one business effect** (exactly-once *effect*, not exactly-once *delivery*).

**39.4** An in-flight map keyed by intent returns the same `Future`/`Deferred` to overlapping callers, so a double-tap shares one POST instead of starting two.

**39.5** **Safe:** resume by querying status with the persisted key / intent id; replay POST only with the same key. **Unsafe:** mint a new key and POST again “to be sure,” or ignore pending and allow another charge UI path.

**39.6** **Authorize** holds/confirms with the rail; **capture** collects funds; **settlement** is inter-bank/merchant batch movement (often invisible). Pay success screen should follow **API payment status** (`succeeded`), not settlement file arrival.

**39.7** Capture/refund are **different operations** with different bodies and effects — reusing a create key risks wrong dedupe or blocked retries; use per-operation keys (e.g. `idem_capture_{payment_id}_…`).

---

## Chapter 40 — Mobile Fintech System Design

**40.1** Redirect URLs are forgeable / incomplete; PSP and webhooks may still be in flight. **Server payment status** is source of truth after deep-link return.

**40.2** Disabling Pay is a same-process UX guard. An **Idempotency-Key** protects across retries, process death, and duplicate POSTs.

**40.3** LWW is OK for non-authoritative fields (memo/notes). Not OK for amount/currency/settlement — use **server authority** / versioning.

**40.4** Upsert by stable `txn_id`; keep newer `updated_at`; collapse push + REST by the same id.

**40.5** Benefit: harder MITM with rogue CAs. Risk: pin rotation / backup-pin failure can brick API access until an app update.

**40.6** Biometrics prove **local device user** unlocked the Pay action — not that the card network charged successfully. **3DS/SCA** proves issuer/challenge for the card rail — not session login. Neither replaces **GET payment status** or idempotency on writes.

---

## Chapter 41 — Behavioral & Product (Fintech)

**41.1** After detection: **mitigation** (stop bleeding), **fix/root cause**, **prevention** (guardrail/process).

**41.2** Debounce is same-process only; duplicates still happen via retries, timeouts, and process death — need **idempotency** and status resume.

**41.3** Examples: never store PAN/CVV; scrub PII from logs; short-lived tokens; mask account numbers; minimize analytics properties.

**41.4** Push is a **hint** (trigger fetch/upsert), not source of truth for money. Server state is authoritative; pushes can drop, delay, or duplicate.

**41.5** Do not assert law. Implement compliance/risk guidance with engineering controls (minimize data, audit, least privilege, PSP tokenization) and escalate policy questions.

---

## Appendix E — UPI & India Rails

**E.1** User may cancel, app may not resume, or debit succeeds while webhook lags — only **server payment status** is authoritative.

**E.2** **Intent:** payer app launched with prefilled payee/amount (payer approves push). **Collect:** payee/merchant requests pull; payer approves in any UPI app.

**E.3** Show honest **processing**; poll GET; offer support with `payment_id`; do **not** POST create with a new idempotency key until server confirms no payment exists.

**E.4** IMPS/NEFT/RTGS are bank-transfer rails with different latency/settlement UX — not interchangeable with in-app UPI intent “instant paid” copy.

---

Back: [Appendix C](C-collections-internals.md) · Book map: [README](../../README.md).
