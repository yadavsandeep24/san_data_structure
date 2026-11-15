# Chapter 16 — Model Solutions

Model solutions for Chapter 16 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-iv/16-monotonic-stack-deque.md`](../../book/part-iv/16-monotonic-stack-deque.md).

---

## P1: Next greater element, circular

For each element, return the next strictly greater value when walking right and wrapping around to the start, or `-1`.

### Approach

Monotonic decreasing stack of indices, walked **twice** (`i` from `0` to `2n - 1`, using `i % n`). The first lap resolves the normal "to the right" answers. The second lap lets items near the end find a greater value near the start. Only push indices during the first lap, because on the second lap they are already on the stack or already answered.

### Complexity

- Time: O(n) (2n iterations, each index pushed and popped at most once)
- Space: O(n)

### Edge cases

- All equal → all `-1`
- The maximum element → always `-1`
- Single element → `[-1]`

### Mobile note

Carousels and looping playlists wrap around. "Next item with a higher rating" has to look past the end and back to the start.

### Kotlin

```kotlin
fun nextGreaterCircular(a: IntArray): IntArray {
    val n = a.size
    val ans = IntArray(n) { -1 }
    val stack = ArrayDeque<Int>()
    for (i in 0 until 2 * n) {
        val x = a[i % n]
        while (stack.isNotEmpty() && a[stack.last()] < x) ans[stack.removeLast()] = x
        if (i < n) stack.addLast(i)
    }
    return ans
}
```

### Swift

```swift
func nextGreaterCircular(_ a: [Int]) -> [Int] {
    let n = a.count
    var ans = [Int](repeating: -1, count: n)
    var stack: [Int] = []
    for i in 0..<(2 * n) {
        let x = a[i % n]
        while let top = stack.last, a[top] < x {
            ans[top] = x
            stack.removeLast()
        }
        if i < n { stack.append(i) }
    }
    return ans
}
```

### Dart

```dart
List<int> nextGreaterCircular(List<int> a) {
  final n = a.length;
  final ans = List<int>.filled(n, -1);
  final stack = <int>[];
  for (var i = 0; i < 2 * n; i++) {
    final x = a[i % n];
    while (stack.isNotEmpty && a[stack.last] < x) {
      ans[stack.removeLast()] = x;
    }
    if (i < n) stack.add(i);
  }
  return ans;
}
```

### TypeScript

```typescript
function nextGreaterCircular(a: number[]): number[] {
  const n = a.length;
  const ans = new Array<number>(n).fill(-1);
  const stack: number[] = [];
  for (let i = 0; i < 2 * n; i++) {
    const x = a[i % n];
    while (stack.length > 0 && a[stack[stack.length - 1]] < x) ans[stack.pop()!] = x;
    if (i < n) stack.push(i);
  }
  return ans;
}
```

---

## P2: Remove k digits

Given a non-negative integer as a string `num` and `k ≤ num.length`, remove exactly `k` digits so the result is the smallest possible number. Return it without leading zeros, or `"0"` if nothing is left.

### Approach

Greedy plus a monotonic **increasing** stack. Scan left to right. While `k > 0` and the top digit is **greater** than the current digit, pop it (removing a bigger digit earlier in the number always helps more than any later removal) and decrement `k`. Push the current digit. If `k` is still positive at the end, the stack is non-decreasing, so drop the last `k` digits. Then strip leading zeros.

### Complexity

- Time: O(n)
- Space: O(n)

### Edge cases

- `k == num.length` → `"0"`
- Leading zeros after removal (`"10200", k = 1` → `"200"`)
- Already non-decreasing (`"12345", k = 2` → `"123"`)

### Mobile note

The same greedy stack picks the "lexicographically smallest subsequence of length L" for things like compact display codes. It runs in O(n) with no backtracking, so it's fine on the main thread.

### Kotlin

```kotlin
fun removeKdigits(num: String, k: Int): String {
    var remaining = k
    val stack = StringBuilder()
    for (c in num) {
        while (remaining > 0 && stack.isNotEmpty() && stack.last() > c) {
            stack.setLength(stack.length - 1)
            remaining--
        }
        stack.append(c)
    }
    stack.setLength(stack.length - remaining)
    val result = stack.trimStart('0').toString()
    return result.ifEmpty { "0" }
}
```

### Swift

```swift
func removeKdigits(_ num: String, _ k: Int) -> String {
    var remaining = k
    var stack: [Character] = []
    for c in num {
        while remaining > 0, let top = stack.last, top > c {
            stack.removeLast()
            remaining -= 1
        }
        stack.append(c)
    }
    stack.removeLast(remaining)
    let result = String(stack.drop(while: { $0 == "0" }))
    return result.isEmpty ? "0" : result
}
```

### Dart

```dart
String removeKdigits(String num, int k) {
  var remaining = k;
  final stack = <int>[]; // code units
  for (final c in num.codeUnits) {
    while (remaining > 0 && stack.isNotEmpty && stack.last > c) {
      stack.removeLast();
      remaining--;
    }
    stack.add(c);
  }
  stack.removeRange(stack.length - remaining, stack.length);
  var start = 0;
  while (start < stack.length && stack[start] == 0x30) {
    start++;
  }
  final result = String.fromCharCodes(stack.sublist(start));
  return result.isEmpty ? '0' : result;
}
```

### TypeScript

```typescript
function removeKdigits(num: string, k: number): string {
  let remaining = k;
  const stack: string[] = [];
  for (const c of num) {
    while (remaining > 0 && stack.length > 0 && stack[stack.length - 1] > c) {
      stack.pop();
      remaining--;
    }
    stack.push(c);
  }
  stack.length -= remaining;
  let start = 0;
  while (start < stack.length && stack[start] === '0') start++;
  const result = stack.slice(start).join('');
  return result === '' ? '0' : result;
}
```

---

## P3: Sum of subarray minimums

Return `Σ min(sub)` over every contiguous subarray of `a`, modulo `1_000_000_007`.

### Approach

**Contribution counting.** `a[j]` is the minimum of every subarray that starts after its previous smaller element and ends before its next smaller-or-equal element. If `left = j - prevSmaller` and `right = nextSmallerOrEqual - j`, then `a[j]` contributes `a[j] · left · right`.

One pass with an increasing stack computes both at once. When the current index `i` (or a sentinel at `i = n` with value −∞) pops `j`, then `i` is `j`'s next smaller-or-equal, and the new top after popping, `k` (or `-1`), is `j`'s previous strictly-smaller. Use `>=` when popping, so equal values are owned by exactly one index.

### Complexity

- Time: O(n)
- Space: O(n)

### Edge cases

- Duplicates (`[2, 2, 2]` → 2·6 = 12): the `>=` / strict split prevents double counting
- Strictly increasing or decreasing inputs
- Overflow: `a[j]·left·right` can reach ~10¹³, so use 64-bit integers and take the mod after each addition

### Mobile note

The same "how many windows does this sample dominate?" counting attributes jank: how much each slow frame contributes to the worst-case latency across all time windows in a trace.

### Kotlin

```kotlin
fun sumSubarrayMins(a: IntArray): Int {
    val mod = 1_000_000_007L
    val stack = ArrayDeque<Int>()
    var total = 0L
    for (i in 0..a.size) {
        val cur = if (i == a.size) Int.MIN_VALUE else a[i]
        while (stack.isNotEmpty() && a[stack.last()] >= cur) {
            val j = stack.removeLast()
            val k = if (stack.isEmpty()) -1 else stack.last()
            total = (total + a[j].toLong() * (j - k) * (i - j)) % mod
        }
        stack.addLast(i)
    }
    return total.toInt()
}
```

### Swift

```swift
func sumSubarrayMins(_ a: [Int]) -> Int {
    let mod = 1_000_000_007
    var stack: [Int] = []
    var total = 0
    for i in 0...a.count {
        let cur = i == a.count ? Int.min : a[i]
        while let j = stack.last, a[j] >= cur {
            stack.removeLast()
            let k = stack.last ?? -1
            total = (total + a[j] * (j - k) * (i - j)) % mod
        }
        stack.append(i)
    }
    return total
}
```

### Dart

```dart
int sumSubarrayMins(List<int> a) {
  const mod = 1000000007;
  final stack = <int>[];
  var total = 0;
  for (var i = 0; i <= a.length; i++) {
    final cur = i == a.length ? -1 << 62 : a[i];
    while (stack.isNotEmpty && a[stack.last] >= cur) {
      final j = stack.removeLast();
      final k = stack.isEmpty ? -1 : stack.last;
      total = (total + a[j] * (j - k) * (i - j)) % mod;
    }
    stack.add(i);
  }
  return total;
}
```

### TypeScript

```typescript
function sumSubarrayMins(a: number[]): number {
  const MOD = 1_000_000_007;
  const stack: number[] = [];
  let total = 0;
  for (let i = 0; i <= a.length; i++) {
    const cur = i === a.length ? -Infinity : a[i];
    while (stack.length > 0 && a[stack[stack.length - 1]] >= cur) {
      const j = stack.pop()!;
      const k = stack.length > 0 ? stack[stack.length - 1] : -1;
      // a[j] ≤ 3·10^4 and (j-k)(i-j) ≤ 9·10^8 ⇒ product < 2^53, safe in a double
      total = (total + ((a[j] * (j - k) * (i - j)) % MOD)) % MOD;
    }
    stack.push(i);
  }
  return total;
}
```
