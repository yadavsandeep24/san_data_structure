# Chapter 19 — Model Solutions

Model solutions for Chapter 19 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-vi/19-dynamic-programming.md`](../../book/part-vi/19-dynamic-programming.md).

---

## P1: Climbing stairs

### Approach

Linear DP / Fibonacci: `dp[i] = dp[i-1] + dp[i-2]` with `dp[1]=1`, `dp[2]=2`. Roll two variables to use O(1) space. Iterative — no recursion stack.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- `n == 1` or `2`
- Large `n` — watch 32-bit overflow if the problem asks for full integer count; Kotlin/Swift `Int` may overflow; use wider type if required

### Mobile note

Teaching example. Unlikely to appear as stairs in product code; the pattern matches “number of ways to schedule two-length actions.” Prefer closed form or matrix exponentiation only if n is huge and you need exact counts.

### Kotlin

```kotlin
fun climbStairs(n: Int): Int {
    if (n <= 2) return n
    var a = 1
    var b = 2
    repeat(n - 2) {
        val c = a + b
        a = b
        b = c
    }
    return b
}
```

### Swift

```swift
func climbStairs(_ n: Int) -> Int {
    if n <= 2 { return n }
    var a = 1, b = 2
    for _ in 3...n {
        let c = a + b
        a = b
        b = c
    }
    return b
}
```

### Dart

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

### TypeScript

```typescript
function climbStairs(n: number): number {
  if (n <= 2) return n;
  let a = 1, b = 2;
  for (let i = 3; i <= n; i++) {
    const c = a + b;
    a = b;
    b = c;
  }
  return b;
}
```

---

## P2: House robber

### Approach

`dp[i] = max(dp[i-1], dp[i-2] + nums[i])` — skip current vs rob current (+ best two back). Implement with two rolling variables `prev2`, `prev1`.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- Empty → 0
- Single house
- Two houses → max of them
- Zeros / all equal

### Mobile note

Interview classic. Product analogues (pick non-adjacent notification slots, non-adjacent ad placements) exist but usually need extra constraints — do not force this recurrence onto layout.

### Kotlin

```kotlin
fun rob(nums: IntArray): Int {
    var prev2 = 0
    var prev1 = 0
    for (x in nums) {
        val cur = maxOf(prev1, prev2 + x)
        prev2 = prev1
        prev1 = cur
    }
    return prev1
}
```

### Swift

```swift
func rob(_ nums: [Int]) -> Int {
    var prev2 = 0, prev1 = 0
    for x in nums {
        let cur = max(prev1, prev2 + x)
        prev2 = prev1
        prev1 = cur
    }
    return prev1
}
```

### Dart

```dart
int rob(List<int> nums) {
  var prev2 = 0, prev1 = 0;
  for (final x in nums) {
    final cur = prev1 > prev2 + x ? prev1 : prev2 + x;
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}
```

### TypeScript

```typescript
function rob(nums: number[]): number {
  let prev2 = 0, prev1 = 0;
  for (const x of nums) {
    const cur = Math.max(prev1, prev2 + x);
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}
```

---

## P3: Coin change (fewest coins)

### Approach

Tabulation: `dp[x] = minimum coins to make amount x`. Initialize `dp[0] = 0`, others to `amount + 1` (sentinel “infinity”). For each amount `x` from 1..amount, for each coin `c <= x`, set `dp[x] = min(dp[x], dp[x - c] + 1)`. If `dp[amount]` still sentinel, return `-1`.

This is correct for arbitrary denominations (unlike greedy).

### Complexity

- Time: O(amount · coins)
- Space: O(amount)

### Edge cases

- `amount == 0` → 0
- Impossible amount → `-1`
- Single coin equals amount
- Coin larger than amount (ignored)
- Many small coins — table size dominates memory; bound amount on device

### Mobile note

Use for loyalty-point redemption math with weird denominations. Keep `amount` modest (e.g. ≤ 10⁴–10⁵). Huge amounts belong on the backend. Do not run nested loops on the UI thread for large tables.

### Kotlin

```kotlin
fun coinChange(coins: IntArray, amount: Int): Int {
    val inf = amount + 1
    val dp = IntArray(amount + 1) { inf }
    dp[0] = 0
    for (x in 1..amount) {
        for (c in coins) {
            if (c <= x) dp[x] = minOf(dp[x], dp[x - c] + 1)
        }
    }
    return if (dp[amount] >= inf) -1 else dp[amount]
}
```

### Swift

```swift
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    let inf = amount + 1
    var dp = Array(repeating: inf, count: amount + 1)
    dp[0] = 0
    if amount == 0 { return 0 }
    for x in 1...amount {
        for c in coins where c <= x {
            dp[x] = min(dp[x], dp[x - c] + 1)
        }
    }
    return dp[amount] >= inf ? -1 : dp[amount]
}
```

### Dart

```dart
int coinChange(List<int> coins, int amount) {
  final inf = amount + 1;
  final dp = List<int>.filled(amount + 1, inf);
  dp[0] = 0;
  for (var x = 1; x <= amount; x++) {
    for (final c in coins) {
      if (c <= x && dp[x - c] + 1 < dp[x]) {
        dp[x] = dp[x - c] + 1;
      }
    }
  }
  return dp[amount] >= inf ? -1 : dp[amount];
}
```

### TypeScript

```typescript
function coinChange(coins: number[], amount: number): number {
  const inf = amount + 1;
  const dp = Array(amount + 1).fill(inf);
  dp[0] = 0;
  for (let x = 1; x <= amount; x++) {
    for (const c of coins) {
      if (c <= x) dp[x] = Math.min(dp[x], dp[x - c] + 1);
    }
  }
  return dp[amount] >= inf ? -1 : dp[amount];
}
```
