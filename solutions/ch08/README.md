# Chapter 8 — Model Solutions

## P1: Contains duplicate

### Approach

Scan the array; insert each value into a hash set. If `add` fails (already present), return true. If the scan finishes, return false.

### Complexity

- Time: O(n)
- Space: O(n)

### Edge cases

- Empty / single element → false
- Duplicate at ends vs adjacent
- Integers vs object identity (in JS store primitives or string ids)

### Mobile note

Same as detecting duplicate `messageId` in a websocket burst before appending to a chat list.

### Kotlin

```kotlin
fun containsDuplicate(nums: IntArray): Boolean {
    val seen = HashSet<Int>()
    for (x in nums) if (!seen.add(x)) return true
    return false
}
```

### Swift

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    var seen = Set<Int>()
    for x in nums {
        if !seen.insert(x).inserted { return true }
    }
    return false
}
```

### Dart

```dart
bool containsDuplicate(List<int> nums) {
  final seen = <int>{};
  for (final x in nums) {
    if (!seen.add(x)) return true;
  }
  return false;
}
```

### TypeScript

```typescript
function containsDuplicate(nums: number[]): boolean {
  const seen = new Set<number>();
  for (const x of nums) {
    if (seen.has(x)) return true;
    seen.add(x);
  }
  return false;
}
```

---

## P2: Intersection of two arrays

### Approach

Put elements of the smaller array into a set. Scan the larger array; if a value is in the set and not yet in the result set, add it. (Variant: intersection of multisets uses frequency maps.)

### Complexity

- Time: O(n + m)
- Space: O(min(n, m))

### Edge cases

- No overlap → empty
- All overlap → unique intersection
- Multiset problem statement (“intersection II”) — use counts, not a set
- Unsorted inputs — sets do not require sorting

### Mobile note

`selectedPhotoIds ∩ albumPhotoIds` after a library sync removes stale checkmarks without O(n·m) nested loops.

### Kotlin

```kotlin
fun intersection(a: IntArray, b: IntArray): IntArray {
    val setA = a.toHashSet()
    val out = HashSet<Int>()
    for (x in b) if (x in setA) out.add(x)
    return out.toIntArray()
}
```

### Swift

```swift
func intersection(_ a: [Int], _ b: [Int]) -> [Int] {
    Array(Set(a).intersection(Set(b)))
}
```

### Dart

```dart
List<int> intersection(List<int> a, List<int> b) {
  final setA = a.toSet();
  final out = <int>{};
  for (final x in b) {
    if (setA.contains(x)) out.add(x);
  }
  return out.toList();
}
```

### TypeScript

```typescript
function intersection(a: number[], b: number[]): number[] {
  const setA = new Set(a);
  const out = new Set<number>();
  for (const x of b) if (setA.has(x)) out.add(x);
  return [...out];
}
```

---

## P3: Longest consecutive sequence

### Approach

Insert all numbers into a hash set. For each `x` where `x - 1` is **not** in the set, `x` starts a streak; walk `x+1, x+2, …` while present, tracking length. Take the maximum. Each number is visited at most twice ⇒ O(n) average.

### Complexity

- Time: O(n) average
- Space: O(n)

### Edge cases

- Empty array → 0
- Single element → 1
- Negatives and zero — fine in a set
- Duplicates in input — set collapses them (length uses unique values)
- Already sorted long run — algorithm still O(n), no need to sort

### Mobile note

Streaks of consecutive “day active” timestamps (normalize to day ids first) use the same “only start at run heads” idea for retention badges.

### Kotlin

```kotlin
fun longestConsecutive(nums: IntArray): Int {
    val set = nums.toHashSet()
    var best = 0
    for (x in set) {
        if (x - 1 in set) continue
        var y = x
        var len = 1
        while (y + 1 in set) {
            y++
            len++
        }
        best = maxOf(best, len)
    }
    return best
}
```

### Swift

```swift
func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)
    var best = 0
    for x in set where !set.contains(x - 1) {
        var y = x
        var len = 1
        while set.contains(y + 1) {
            y += 1
            len += 1
        }
        best = max(best, len)
    }
    return best
}
```

### Dart

```dart
int longestConsecutive(List<int> nums) {
  final set = nums.toSet();
  var best = 0;
  for (final x in set) {
    if (set.contains(x - 1)) continue;
    var y = x;
    var len = 1;
    while (set.contains(y + 1)) {
      y++;
      len++;
    }
    best = len > best ? len : best;
  }
  return best;
}
```

### TypeScript

```typescript
function longestConsecutive(nums: number[]): number {
  const set = new Set(nums);
  let best = 0;
  for (const x of set) {
    if (set.has(x - 1)) continue;
    let y = x;
    let len = 1;
    while (set.has(y + 1)) {
      y++;
      len++;
    }
    best = Math.max(best, len);
  }
  return best;
}
```
