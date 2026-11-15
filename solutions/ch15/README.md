# Chapter 15 — Model Solutions

Model solutions for Chapter 15 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-iv/15-prefix-sums.md`](../../book/part-iv/15-prefix-sums.md).

---

## P1: Find pivot index

Return the leftmost index `i` where `sum(a[0 until i]) == sum(a[i+1 until n])`, or `-1`.

### Approach

Prefix sum without storing the array. Compute `total` once. Walk left to right keeping `left`, the sum before `i`. The right side is `total - left - a[i]`. Compare, then add `a[i]` to `left`.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- Index 0 is the pivot when the sum of the rest is 0 (the left sum is an empty 0)
- Negative values are fine. This is not a window.
- No pivot → `-1`

### Mobile note

"Where does the timeline balance?" A split marker on a budget chart that puts equal spend on each side, computed once when the data loads.

### Kotlin

```kotlin
fun pivotIndex(a: IntArray): Int {
    val total = a.sumOf { it.toLong() }
    var left = 0L
    for (i in a.indices) {
        if (left == total - left - a[i]) return i
        left += a[i]
    }
    return -1
}
```

### Swift

```swift
func pivotIndex(_ a: [Int]) -> Int {
    let total = a.reduce(0, +)
    var left = 0
    for i in a.indices {
        if left == total - left - a[i] { return i }
        left += a[i]
    }
    return -1
}
```

### Dart

```dart
int pivotIndex(List<int> a) {
  final total = a.fold<int>(0, (s, x) => s + x);
  var left = 0;
  for (var i = 0; i < a.length; i++) {
    if (left == total - left - a[i]) return i;
    left += a[i];
  }
  return -1;
}
```

### TypeScript

```typescript
function pivotIndex(a: number[]): number {
  const total = a.reduce((s, x) => s + x, 0);
  let left = 0;
  for (let i = 0; i < a.length; i++) {
    if (left === total - left - a[i]) return i;
    left += a[i];
  }
  return -1;
}
```

---

## P2: Contiguous array (equal 0s and 1s)

Given a binary array, return the length of the longest subarray with an equal number of 0s and 1s.

### Approach

Treat `0` as `-1`. Then "equal counts" means "subarray sum 0", which in turn means "two equal prefix values". Store the **first index** at which each prefix value appears, seeded with `{0: -1}` (the empty prefix sits before index 0). When a prefix value repeats at `i`, the subarray `(first + 1)..i` sums to 0, so its length is `i - first`.

Store the first index only. A later index would give a shorter subarray.

### Complexity

- Time: O(n)
- Space: O(n) for the map (an array of size `2n + 1` indexed by `prefix + n` also works and avoids hashing)

### Edge cases

- All 0s or all 1s → 0
- The whole array balances → `n` (thanks to the `-1` seed)

### Mobile note

The same shape answers "longest stretch where up-votes equal down-votes" or "longest period where inflow equals outflow" on a small on-device series.

### Kotlin

```kotlin
fun findMaxLength(a: IntArray): Int {
    val first = HashMap<Int, Int>().apply { put(0, -1) }
    var prefix = 0
    var best = 0
    for (i in a.indices) {
        prefix += if (a[i] == 1) 1 else -1
        val f = first[prefix]
        if (f != null) best = maxOf(best, i - f) else first[prefix] = i
    }
    return best
}
```

### Swift

```swift
func findMaxLength(_ a: [Int]) -> Int {
    var first: [Int: Int] = [0: -1]
    var prefix = 0, best = 0
    for i in a.indices {
        prefix += a[i] == 1 ? 1 : -1
        if let f = first[prefix] {
            best = max(best, i - f)
        } else {
            first[prefix] = i
        }
    }
    return best
}
```

### Dart

```dart
int findMaxLength(List<int> a) {
  final first = <int, int>{0: -1};
  var prefix = 0, best = 0;
  for (var i = 0; i < a.length; i++) {
    prefix += a[i] == 1 ? 1 : -1;
    final f = first[prefix];
    if (f != null) {
      if (i - f > best) best = i - f;
    } else {
      first[prefix] = i;
    }
  }
  return best;
}
```

### TypeScript

```typescript
function findMaxLength(a: number[]): number {
  const first = new Map<number, number>([[0, -1]]);
  let prefix = 0;
  let best = 0;
  for (let i = 0; i < a.length; i++) {
    prefix += a[i] === 1 ? 1 : -1;
    const f = first.get(prefix);
    if (f !== undefined) best = Math.max(best, i - f);
    else first.set(prefix, i);
  }
  return best;
}
```

---

## P3: Car pooling (capacity check)

`trips[i] = [passengers, from, to]`. Passengers board at `from` and leave at `to`, so they are **not** on board at `to`. Locations are `0..1000`. Return whether a vehicle with `capacity` seats can serve every trip.

### Approach

Difference array over locations. `diff[from] += passengers`, `diff[to] -= passengers` (the drop-off point is exclusive, so there's no `+1`). Take a running sum across locations, and if it ever exceeds `capacity`, return `false`.

If the location range is huge or sparse, sort the `(location, delta)` events instead (a sweep line, Chapter 17). That costs O(t log t) and doesn't depend on the range.

### Complexity

- Time: O(t + L) where L is the location range (1001)
- Space: O(L)

### Edge cases

- A drop-off and a pickup at the same location: the drop-off frees seats first. The difference array handles this because both deltas land in the same slot.
- One trip larger than capacity → `false`
- No trips → `true`

### Mobile note

This is a seat-booking check for a shuttle or ride-share app, and it can run on device for instant feedback before the server confirms.

### Kotlin

```kotlin
fun carPooling(trips: Array<IntArray>, capacity: Int): Boolean {
    val diff = IntArray(1001)
    for ((p, from, to) in trips) {
        diff[from] += p
        diff[to] -= p
    }
    var onBoard = 0
    for (d in diff) {
        onBoard += d
        if (onBoard > capacity) return false
    }
    return true
}
```

### Swift

```swift
func carPooling(_ trips: [[Int]], _ capacity: Int) -> Bool {
    var diff = [Int](repeating: 0, count: 1001)
    for t in trips {
        diff[t[1]] += t[0]
        diff[t[2]] -= t[0]
    }
    var onBoard = 0
    for d in diff {
        onBoard += d
        if onBoard > capacity { return false }
    }
    return true
}
```

### Dart

```dart
bool carPooling(List<List<int>> trips, int capacity) {
  final diff = List<int>.filled(1001, 0);
  for (final t in trips) {
    diff[t[1]] += t[0];
    diff[t[2]] -= t[0];
  }
  var onBoard = 0;
  for (final d in diff) {
    onBoard += d;
    if (onBoard > capacity) return false;
  }
  return true;
}
```

### TypeScript

```typescript
function carPooling(trips: [number, number, number][], capacity: number): boolean {
  const diff = new Array<number>(1001).fill(0);
  for (const [p, from, to] of trips) {
    diff[from] += p;
    diff[to] -= p;
  }
  let onBoard = 0;
  for (const d of diff) {
    onBoard += d;
    if (onBoard > capacity) return false;
  }
  return true;
}
```
