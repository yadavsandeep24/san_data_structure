# Chapter 14 — Model Solutions

Model solutions for Chapter 14 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-iv/14-sliding-window.md`](../../book/part-iv/14-sliding-window.md).

---

## P1: Maximum average subarray

Given `nums` and `1 ≤ k ≤ n`, return the maximum average of any `k` consecutive values.

### Approach

Fixed window. Keep the running sum of the last `k` values. The maximum average comes from the maximum sum, so track the best sum and divide once at the end. Dividing at every step adds floating-point noise and work.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- `k == n` → average of everything
- All negative values (the best sum is still the "least negative")
- Large values: use a 64-bit sum

### Mobile note

"Best 1-second FPS stretch" for a performance report. Keep sums as integers (frame counts or microseconds) and only convert to a floating-point value for display.

### Kotlin

```kotlin
fun findMaxAverage(nums: IntArray, k: Int): Double {
    var sum = 0L
    for (i in 0 until k) sum += nums[i]
    var best = sum
    for (r in k until nums.size) {
        sum += nums[r] - nums[r - k]
        if (sum > best) best = sum
    }
    return best.toDouble() / k
}
```

### Swift

```swift
func findMaxAverage(_ nums: [Int], _ k: Int) -> Double {
    var sum = 0
    for i in 0..<k { sum += nums[i] }
    var best = sum
    for r in k..<nums.count {
        sum += nums[r] - nums[r - k]
        best = max(best, sum)
    }
    return Double(best) / Double(k)
}
```

### Dart

```dart
double findMaxAverage(List<int> nums, int k) {
  var sum = 0;
  for (var i = 0; i < k; i++) {
    sum += nums[i];
  }
  var best = sum;
  for (var r = k; r < nums.length; r++) {
    sum += nums[r] - nums[r - k];
    if (sum > best) best = sum;
  }
  return best / k;
}
```

### TypeScript

```typescript
function findMaxAverage(nums: number[], k: number): number {
  let sum = 0;
  for (let i = 0; i < k; i++) sum += nums[i];
  let best = sum;
  for (let r = k; r < nums.length; r++) {
    sum += nums[r] - nums[r - k];
    best = Math.max(best, sum);
  }
  return best / k;
}
```

---

## P2: Max consecutive ones with k flips

Given a binary array and `k`, return the length of the longest run of 1s you can get by flipping at most `k` zeros.

### Approach

Variable window. Restate the problem: find the longest window containing **at most `k` zeros**. Expand `right` and count zeros. While `zeros > k`, shrink from the left, decrementing the count when a zero leaves. Record `right - left + 1` after shrinking.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- `k == 0` → longest run of existing 1s
- `k ≥` number of zeros → `n`
- All zeros → `min(k, n)`

### Mobile note

"Longest streak of days online, forgiving up to k missed days" for an engagement badge. It runs on device over a few hundred booleans, so main-thread cost is negligible.

### Kotlin

```kotlin
fun longestOnes(a: IntArray, k: Int): Int {
    var left = 0
    var zeros = 0
    var best = 0
    for (right in a.indices) {
        if (a[right] == 0) zeros++
        while (zeros > k) {
            if (a[left] == 0) zeros--
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
```

### Swift

```swift
func longestOnes(_ a: [Int], _ k: Int) -> Int {
    var left = 0, zeros = 0, best = 0
    for right in a.indices {
        if a[right] == 0 { zeros += 1 }
        while zeros > k {
            if a[left] == 0 { zeros -= 1 }
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
```

### Dart

```dart
int longestOnes(List<int> a, int k) {
  var left = 0, zeros = 0, best = 0;
  for (var right = 0; right < a.length; right++) {
    if (a[right] == 0) zeros++;
    while (zeros > k) {
      if (a[left] == 0) zeros--;
      left++;
    }
    if (right - left + 1 > best) best = right - left + 1;
  }
  return best;
}
```

### TypeScript

```typescript
function longestOnes(a: number[], k: number): number {
  let left = 0;
  let zeros = 0;
  let best = 0;
  for (let right = 0; right < a.length; right++) {
    if (a[right] === 0) zeros++;
    while (zeros > k) {
      if (a[left] === 0) zeros--;
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}
```

---

## P3: Fruit into baskets (at most two kinds)

Given `types`, return the length of the longest contiguous stretch that contains at most 2 distinct values.

### Approach

Variable window with a frequency map. Add `types[right]`. While the map has more than 2 keys, decrement `types[left]`, **remove the key when its count reaches 0**, and move `left`. Record the window length.

The general version ("at most k distinct") is the same code with `2` replaced by `k`.

### Complexity

- Time: O(n)
- Space: O(1) here (at most 3 keys at once); O(k) in general

### Edge cases

- One distinct value → `n`
- Alternating three values `[1,2,3,1,2,3]` → 2
- Empty input → 0

### Mobile note

"Longest browsing session that stayed within two categories" is a feature for on-device personalization. Raw events never leave the device. Only the summary is computed.

### Kotlin

```kotlin
fun totalFruit(types: IntArray): Int {
    val count = HashMap<Int, Int>()
    var left = 0
    var best = 0
    for (right in types.indices) {
        count[types[right]] = (count[types[right]] ?: 0) + 1
        while (count.size > 2) {
            val t = types[left]
            val c = count.getValue(t) - 1
            if (c == 0) count.remove(t) else count[t] = c
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
```

### Swift

```swift
func totalFruit(_ types: [Int]) -> Int {
    var count: [Int: Int] = [:]
    var left = 0, best = 0
    for right in types.indices {
        count[types[right], default: 0] += 1
        while count.count > 2 {
            let t = types[left]
            count[t]! -= 1
            if count[t] == 0 { count[t] = nil }
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
```

### Dart

```dart
int totalFruit(List<int> types) {
  final count = <int, int>{};
  var left = 0, best = 0;
  for (var right = 0; right < types.length; right++) {
    count[types[right]] = (count[types[right]] ?? 0) + 1;
    while (count.length > 2) {
      final t = types[left];
      final c = count[t]! - 1;
      if (c == 0) {
        count.remove(t);
      } else {
        count[t] = c;
      }
      left++;
    }
    if (right - left + 1 > best) best = right - left + 1;
  }
  return best;
}
```

### TypeScript

```typescript
function totalFruit(types: number[]): number {
  const count = new Map<number, number>();
  let left = 0;
  let best = 0;
  for (let right = 0; right < types.length; right++) {
    count.set(types[right], (count.get(types[right]) ?? 0) + 1);
    while (count.size > 2) {
      const t = types[left];
      const c = count.get(t)! - 1;
      if (c === 0) count.delete(t);
      else count.set(t, c);
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}
```
