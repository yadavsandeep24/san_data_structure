# Chapter 15 — Model Solutions

Model solutions for Chapter 15 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-v/15-searching-sorting.md`](../../book/part-v/15-searching-sorting.md).

---

## P1: Search insert position

### Approach

Lower bound on a sorted ascending array: find the first index `i` where `nums[i] >= target` (or `n` if all elements are smaller). Binary search with half-open range `[lo, hi)` where `hi` starts at `n`.

### Complexity

- Time: O(log n)
- Space: O(1)

### Edge cases

- Empty array → `0`
- Target smaller than all → `0`
- Target larger than all → `n`
- Target equal to an existing element → index of that (leftmost if duplicates and using lower bound)

### Mobile note

Use when inserting a timestamped event into an already-sorted in-memory log without a full re-sort. Keep the array sorted on write path; do not binary-search unsorted UI state.

### Kotlin

```kotlin
fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0
    var hi = nums.size
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
```

### Swift

```swift
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
```

### Dart

```dart
int searchInsert(List<int> nums, int target) {
  var lo = 0, hi = nums.length;
  while (lo < hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}
```

### TypeScript

```typescript
function searchInsert(nums: number[], target: number): number {
  let lo = 0, hi = nums.length;
  while (lo < hi) {
    const mid = lo + ((hi - lo) >> 1);
    if (nums[mid] < target) lo = mid + 1;
    else hi = mid;
  }
  return lo;
}
```

---

## P2: First and last position

### Approach

On a sorted array, run lower bound for `target` (first `>= target`) and upper bound (first `> target`). If lower bound is in range and equals `target`, answer is `[first, upper - 1]`; else `[-1, -1]`.

### Complexity

- Time: O(log n)
- Space: O(1)

### Edge cases

- Missing target → `[-1, -1]`
- Single element match / miss
- Entire array equal to target
- Empty array

### Mobile note

Useful for “all events in this second” on a sorted timeline without scanning. Prefer DB range queries (`BETWEEN`) when data lives in SQLite rather than pulling full arrays to JS/Kotlin.

### Kotlin

```kotlin
fun searchRange(nums: IntArray, target: Int): IntArray {
    fun lower(): Int {
        var lo = 0
        var hi = nums.size
        while (lo < hi) {
            val mid = lo + (hi - lo) / 2
            if (nums[mid] < target) lo = mid + 1 else hi = mid
        }
        return lo
    }
    fun upper(): Int {
        var lo = 0
        var hi = nums.size
        while (lo < hi) {
            val mid = lo + (hi - lo) / 2
            if (nums[mid] <= target) lo = mid + 1 else hi = mid
        }
        return lo
    }
    val L = lower()
    if (L == nums.size || nums[L] != target) return intArrayOf(-1, -1)
    return intArrayOf(L, upper() - 1)
}
```

### Swift

```swift
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    func lower() -> Int {
        var lo = 0, hi = nums.count
        while lo < hi {
            let mid = lo + (hi - lo) / 2
            if nums[mid] < target { lo = mid + 1 } else { hi = mid }
        }
        return lo
    }
    func upper() -> Int {
        var lo = 0, hi = nums.count
        while lo < hi {
            let mid = lo + (hi - lo) / 2
            if nums[mid] <= target { lo = mid + 1 } else { hi = mid }
        }
        return lo
    }
    let L = lower()
    if L == nums.count || nums[L] != target { return [-1, -1] }
    return [L, upper() - 1]
}
```

### Dart

```dart
List<int> searchRange(List<int> nums, int target) {
  int lower() {
    var lo = 0, hi = nums.length;
    while (lo < hi) {
      final mid = lo + (hi - lo) ~/ 2;
      if (nums[mid] < target) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  int upper() {
    var lo = 0, hi = nums.length;
    while (lo < hi) {
      final mid = lo + (hi - lo) ~/ 2;
      if (nums[mid] <= target) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  final L = lower();
  if (L == nums.length || nums[L] != target) return [-1, -1];
  return [L, upper() - 1];
}
```

### TypeScript

```typescript
function searchRange(nums: number[], target: number): number[] {
  const lower = (): number => {
    let lo = 0, hi = nums.length;
    while (lo < hi) {
      const mid = lo + ((hi - lo) >> 1);
      if (nums[mid] < target) lo = mid + 1;
      else hi = mid;
    }
    return lo;
  };
  const upper = (): number => {
    let lo = 0, hi = nums.length;
    while (lo < hi) {
      const mid = lo + ((hi - lo) >> 1);
      if (nums[mid] <= target) lo = mid + 1;
      else hi = mid;
    }
    return lo;
  };
  const L = lower();
  if (L === nums.length || nums[L] !== target) return [-1, -1];
  return [L, upper() - 1];
}
```

---

## P3: Merge two sorted arrays

### Approach

Two-pointer merge: compare heads of `a` and `b`, append the smaller, advance that pointer. Append remainders. For equal keys, apply a documented tie-break (here: take from `a` first for stability toward the first array).

### Complexity

- Time: O(n + m)
- Space: O(n + m) for the output (O(1) extra if merging into a pre-sized buffer in place from the end — optional variant)

### Edge cases

- One array empty
- All of one array smaller than the other
- Interleaved equals — stable-ish tie-break
- Large n+m — allocate once if capacity known

### Mobile note

Mental model for offline sync: local and remote change-logs already ordered by `updatedAt`. Merge linearly instead of `concat + sort`. Run off the UI thread when merging tens of thousands of rows; publish an immutable result to the list adapter.

### Kotlin

```kotlin
fun mergeSorted(a: IntArray, b: IntArray): IntArray {
    val out = IntArray(a.size + b.size)
    var i = 0
    var j = 0
    var k = 0
    while (i < a.size && j < b.size) {
        if (a[i] <= b[j]) out[k++] = a[i++] else out[k++] = b[j++]
    }
    while (i < a.size) out[k++] = a[i++]
    while (j < b.size) out[k++] = b[j++]
    return out
}
```

### Swift

```swift
func mergeSorted(_ a: [Int], _ b: [Int]) -> [Int] {
    var i = 0, j = 0
    var out: [Int] = []
    out.reserveCapacity(a.count + b.count)
    while i < a.count && j < b.count {
        if a[i] <= b[j] {
            out.append(a[i]); i += 1
        } else {
            out.append(b[j]); j += 1
        }
    }
    if i < a.count { out.append(contentsOf: a[i...]) }
    if j < b.count { out.append(contentsOf: b[j...]) }
    return out
}
```

### Dart

```dart
List<int> mergeSorted(List<int> a, List<int> b) {
  final out = <int>[];
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    if (a[i] <= b[j]) {
      out.add(a[i++]);
    } else {
      out.add(b[j++]);
    }
  }
  while (i < a.length) {
    out.add(a[i++]);
  }
  while (j < b.length) {
    out.add(b[j++]);
  }
  return out;
}
```

### TypeScript

```typescript
function mergeSorted(a: number[], b: number[]): number[] {
  const out: number[] = [];
  let i = 0, j = 0;
  while (i < a.length && j < b.length) {
    if (a[i] <= b[j]) out.push(a[i++]);
    else out.push(b[j++]);
  }
  while (i < a.length) out.push(a[i++]);
  while (j < b.length) out.push(b[j++]);
  return out;
}
```
