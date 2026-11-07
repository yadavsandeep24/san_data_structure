# Chapter 19 — Dynamic Programming

## Mobile motivation

Dynamic programming (DP) is the algorithm topic that shows up hardest in interviews and **least often** in day-to-day UI code. Layout engines, scroll math, and image caches are not usually “write a DP table.” Be honest with yourself: you study DP to pass interviews, to recognize overlapping subproblems in pricing/loyalty engines, and to avoid reinventing exponential recursion when a product *does* need optimal counting (offline puzzle games, fare calculators, coupon stacking rules).

Still, the mental model — **optimal substructure + overlapping subproblems** — helps you spot when a recursive feature will melt a phone.

## Memoization vs tabulation

| Style | Direction | Storage | Feel |
|-------|-----------|---------|------|
| **Memoization** (top-down) | Recurse from the goal; cache results | Hash map / array filled on demand | Natural from recursive formulation |
| **Tabulation** (bottom-up) | Iterate from base cases to goal | Array/table filled in order | Often less stack risk; clearer complexity |

Both can achieve the same asymptotics. On mobile, **prefer tabulation or iterative** when depth would be large — memoized recursion still consumes call-stack frames.

```text
Memo:  f(n) = cache hit ? cache[n] : compute using f(n-1)...
Table: dp[0]=..., for i in 1..n: dp[i] = combine(dp[i-1], ...)
```

## Four-step method

1. **Define the subproblem** in plain language: “`dp[i]` = best answer using the first `i` items / ending at index `i`.”
2. **Write the recurrence** relating `dp[i]` to smaller indices.
3. **Identify base cases** (`dp[0]`, `dp[1]`, empty set).
4. **Compute in valid order** (or memoize) and extract the answer (`dp[n]`, `max(dp)`, etc.).

If you cannot state step 1 in one sentence, you are not ready to code.

## Climbing stairs

Ways to climb `n` stairs taking 1 or 2 steps: Fibonacci.

```text
dp[1] = 1, dp[2] = 2
dp[i] = dp[i-1] + dp[i-2]
```

Space can roll to two variables. O(n) time, O(1) space.

**Kotlin**

```kotlin
fun climbStairs(n: Int): Int {
    if (n <= 2) return n
    var a = 1
    var b = 2
    for (i in 3..n) {
        val c = a + b
        a = b
        b = c
    }
    return b
}
```

**Swift**

```swift
func climbStairs(_ n: Int) -> Int {
    if n <= 2 { return n }
    var a = 1, b = 2
    for _ in 3...n {
        let c = a + b; a = b; b = c
    }
    return b
}
```

**Dart**

```dart
int climbStairs(int n) {
  if (n <= 2) return n;
  var a = 1, b = 2;
  for (var i = 3; i <= n; i++) {
    final c = a + b;
    a = b;
    b = c;
  }
  return b;
}
```

**TypeScript**

```typescript
function climbStairs(n: number): number {
  if (n <= 2) return n;
  let a = 1, b = 2;
  for (let i = 3; i <= n; i++) {
    const c = a + b; a = b; b = c;
  }
  return b;
}
```

## House robber

Cannot rob two adjacent houses. `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`.

Same rolling two-variable optimization. Classic “linear DP on an array.”

## Coin change — fewest coins

`dp[x] = min coins to make amount x`.

```text
dp[0] = 0
dp[x] = min over coin c <= x of dp[x-c] + 1
unreachable = +∞
```

O(amount · coins) time. This is the correct approach when greedy fails (Chapter 17). On device, keep `amount` bounded — a huge amount table may be megabytes.

## Where DP appears in apps (honest list)

| Area | DP? | Notes |
|------|-----|-------|
| RecyclerView / `LazyColumn` / ListView layout | Rarely | Layout is constraint/measure passes, not knapsack DP |
| Text height caching | Not DP | Memoize measure results — caching, not optimal substructure |
| Image decode / resize | Not DP | Pipelines and caches |
| Offline games / puzzles | Sometimes | Levels, scoring, path counts |
| Pricing / promotions engine | Sometimes | Coupon combinations (watch exponential state spaces) |
| Diff algorithms (Myers) | Related | Edit-distance family; usually library code |
| Keyboard autocomplete | Related | Tries + language models; not classical table DP you write |

**Takeaway:** learn DP deeply for interviews and for the rare product subdomain that needs it. Do not force a DP table onto scroll performance problems — those are usually algorithmic complexity of the wrong structure (Chapters 3, 12, 13), not missing `dp[i]`.

## Complexity patterns to recognize

| Pattern | Typical time | Example |
|---------|--------------|---------|
| Linear DP | O(n) | Stairs, house robber |
| Grid DP | O(n·m) | Unique paths |
| Knapsack-like | O(n·W) | Coin change, 0/1 knapsack |
| Interval DP | O(n³) | Matrix chain (rare on mobile) |
| State compression | O(n·2ⁿ) | Tiny n only |

## Common mistakes

1. Diving into code before defining `dp[i]` in words.
2. Wrong loop order — using `dp[i-1]` before it exists.
3. Mutating a shared memo key incorrectly (string keys vs index tuples).
4. Using memoized recursion on huge `n` and overflowing the stack.
5. Applying greedy to coin change “because it’s faster” when optimality is required.

## Self-Check

**19.1** What two properties make a problem suitable for DP?

**19.2** Contrast memoization and tabulation regarding the call stack.

**19.3** State the house-robber recurrence.

**19.4** Why can coin-change DP succeed where greedy fails?

**19.5** Give an honest example of something in mobile UI that is *not* DP despite involving “remembered work.”

*(Answers: Appendix D.)*

## Practice

1. **Climbing stairs** — [solutions/ch19](../../solutions/ch19/README.md#p1-climbing-stairs)
2. **House robber** — [solutions/ch19](../../solutions/ch19/README.md#p2-house-robber)
3. **Coin change (fewest coins)** — [solutions/ch19](../../solutions/ch19/README.md#p3-coin-change-fewest-coins)

Next: [Chapter 20 — Graphs Advanced](20-graphs-advanced.md) — Dijkstra, topological ideas, and heavier graph algorithms.
