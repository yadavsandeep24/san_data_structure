# Chapter 17 — Greedy Thinking

## Mobile motivation

A download manager with limited concurrency picks the “best” next file. A calendar UI packs non-overlapping meetings into the fewest rooms. An image pipeline skips work that cannot affect pixels on screen. These are **greedy** instincts: at each step, take the locally best option and never revisit it.

Greedy code is short and fast when the problem structure allows it — and silently wrong when it does not. Coin change is the classic trap: for some coin systems the greedy choice fails. On mobile, a wrong greedy policy might mean starved uploads, unfair scheduling, or “jump game” style “can we reach the end of this onboarding page list?” logic that incorrectly blocks the user.

## What “greedy” means

A **greedy algorithm** builds a solution by repeatedly choosing the option that looks best **right now**, according to a fixed rule, without undoing that choice.

Contrast:

| Style | Revisits choices? | Typical cost |
|-------|-------------------|--------------|
| Greedy | No | Often O(n) or O(n log n) after sort |
| Backtracking | Yes (undo) | Exponential unless pruned |
| DP | Considers many subproblems systematically | Pseudo-polynomial / O(n·W) etc. |

Greedy needs a reason to trust the local rule: exchange argument, matroid structure, or a known theorem (interval scheduling by earliest end time). If you cannot sketch why it works, write a counterexample before shipping.

## When greedy works vs fails

### Works (standard patterns)

1. **Interval scheduling** — select maximum non-overlapping intervals: sort by **end** time, take next that starts ≥ last end.
2. **Jump game (reachability)** — track farthest reachable index; scan left to right.
3. **Assign cookies / simple matching** — sort both sides; greedily feed smallest sufficient cookie to each child.
4. **Huffman coding / some scheduling** — textbook cases with proofs.

### Fails

1. **Coin change for arbitrary denominations** — greedy “always largest coin” fails for coins `{1, 3, 4}` and amount `6` (greedy `4+1+1` vs optimal `3+3`).
2. **Shortest path with naive “always closest unvisited”** without Dijkstra’s careful structure — wrong on weighted graphs (use Dijkstra / Chapter 20).
3. **0/1 knapsack** — value/weight greedy is approximate only; exact needs DP.

**Mobile honesty:** product code often uses greedy *heuristics* (LRU is greedy in spirit) knowing they are not globally optimal — that is fine if the metric is “good enough under constraints.” Interview code must match the problem’s required optimality.

## Coin change — greedy caveat

```text
coins = [1, 3, 4], amount = 6
greedy: 4 + 1 + 1  → 3 coins
optimal: 3 + 3     → 2 coins
```

US coins happen to be **canonical** — greedy works. Do not generalize. Fewest coins for arbitrary sets → DP (Chapter 19) or BFS on remainders.

## Interval scheduling (calendar / meeting rooms lite)

**Maximum number of non-overlapping meetings** (keep as many as possible):

1. Sort by end time ascending.
2. `count = 0`, `lastEnd = −∞`
3. For each interval, if `start >= lastEnd`, take it; `lastEnd = end`.

**Minimum rooms (meeting rooms):** track concurrent load — sort starts and ends, or use a min-heap of end times (Chapter 18). Greedy “sort by start, assign to earliest free room” is the usual approach.

### Non-overlapping intervals to remove

To remove the fewest intervals so the rest do not overlap: equivalent to keep maximum non-overlapping, then `removals = n - kept`. Same earliest-end greedy.

## Jump game (mobile-relevant framing)

You have a list of onboarding pages; from index `i` you may jump forward at most `nums[i]` pages (feature flags / deep-link offsets). Can you reach the last page?

```text
farthest = 0
for i in 0..n-1:
  if i > farthest: return false
  farthest = max(farthest, i + nums[i])
  if farthest >= n-1: return true
return true
```

This is greedy: you only track the best reachability frontier, not every path. O(n) time, O(1) space — safe on main thread for typical list sizes.

### Four-language sketch

**Kotlin**

```kotlin
fun canJump(nums: IntArray): Boolean {
    var farthest = 0
    for (i in nums.indices) {
        if (i > farthest) return false
        farthest = maxOf(farthest, i + nums[i])
        if (farthest >= nums.lastIndex) return true
    }
    return true
}
```

**Swift**

```swift
func canJump(_ nums: [Int]) -> Bool {
    var farthest = 0
    for i in nums.indices {
        if i > farthest { return false }
        farthest = max(farthest, i + nums[i])
        if farthest >= nums.count - 1 { return true }
    }
    return true
}
```

**Dart**

```dart
bool canJump(List<int> nums) {
  var farthest = 0;
  for (var i = 0; i < nums.length; i++) {
    if (i > farthest) return false;
    farthest = farthest > i + nums[i] ? farthest : i + nums[i];
    if (farthest >= nums.length - 1) return true;
  }
  return true;
}
```

**TypeScript**

```typescript
function canJump(nums: number[]): boolean {
  let farthest = 0;
  for (let i = 0; i < nums.length; i++) {
    if (i > farthest) return false;
    farthest = Math.max(farthest, i + nums[i]);
    if (farthest >= nums.length - 1) return true;
  }
  return true;
}
```

## Assign cookies (lite matching)

Children have greed factors `g[i]`; cookies have sizes `s[j]`. Maximize content children: sort both ascending; two pointers — assign smallest cookie that satisfies next child.

Same pattern appears when assigning download slots to the smallest pending jobs to maximize “completed count” under a size budget — still a heuristic unless proven.

## Platform bridges

| Idea | Where it shows up |
|------|-------------------|
| Earliest-deadline / end-time greedy | Calendar packing, local notification batching |
| Farthest-reach | Wizard / pager “can finish from here”; game levels |
| Greedy cache eviction | LRU / LFU approximations (Chapter 12) |
| Fair schedulers | Not pure greedy — often queues + weights (Chapter 6) |

## Common mistakes

1. Assuming “largest first” always optimizes coin or knapsack problems.
2. Sorting intervals by **start** when the theorem needs **end** for max non-overlap count.
3. Jump game: updating farthest after the reachability check is ordered wrong (`i > farthest` must come first).
4. Shipping a greedy heuristic while product/QA expects a globally optimal schedule.
5. Forgetting to sort before two-pointer greedy matching.

## Self-Check

**17.1** Define greedy in one sentence. How does it differ from backtracking?

**17.2** Give a coin-change counterexample where largest-coin-first fails.

**17.3** Why sort by end time for maximum non-overlapping intervals?

**17.4** What does the `farthest` variable represent in jump game?

**17.5** When is a greedy *heuristic* acceptable in an app even if not optimal?

*(Answers: Appendix D.)*

## Practice

1. **Jump game** — [solutions/ch17](../../solutions/ch17/README.md#p1-jump-game)
2. **Non-overlapping intervals** (min removals) — [solutions/ch17](../../solutions/ch17/README.md#p2-non-overlapping-intervals)
3. **Assign cookies** — [solutions/ch17](../../solutions/ch17/README.md#p3-assign-cookies)

Next: [Chapter 18 — Heaps and Priority Queues](../part-vi/18-heaps-priority-queues.md) — Top-K, scheduling, and binary-heap mechanics.
