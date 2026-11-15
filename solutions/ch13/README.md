# Chapter 13 — Model Solutions

Model solutions for Chapter 13 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-iv/13-two-pointers.md`](../../book/part-iv/13-two-pointers.md).

---

## P1: Move zeroes

Move every `0` to the end of the array in place, keeping the relative order of the non-zero items.

### Approach

Read/write pointers. `write` marks where the next non-zero item goes. Copy each non-zero item forward, then fill `write until n` with zeros. Invariant: `a[0 until write]` holds the non-zero items seen so far, in their original order.

A swap-based variant (`swap(a[read], a[write])`) does the same in one loop with fewer writes when there are few zeros.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- All zeros → unchanged
- No zeros → unchanged (each item is copied onto itself)
- Single element

### Mobile note

This is "dismissed cards sink to the bottom" without allocating a new list. With a stable ID per card, the diff only reports moves.

### Kotlin

```kotlin
fun moveZeroes(a: IntArray) {
    var write = 0
    for (read in a.indices) {
        if (a[read] != 0) a[write++] = a[read]
    }
    while (write < a.size) a[write++] = 0
}
```

### Swift

```swift
func moveZeroes(_ a: inout [Int]) {
    var write = 0
    for read in a.indices where a[read] != 0 {
        a[write] = a[read]
        write += 1
    }
    while write < a.count {
        a[write] = 0
        write += 1
    }
}
```

### Dart

```dart
void moveZeroes(List<int> a) {
  var write = 0;
  for (var read = 0; read < a.length; read++) {
    if (a[read] != 0) a[write++] = a[read];
  }
  while (write < a.length) {
    a[write++] = 0;
  }
}
```

### TypeScript

```typescript
function moveZeroes(a: number[]): void {
  let write = 0;
  for (let read = 0; read < a.length; read++) {
    if (a[read] !== 0) a[write++] = a[read];
  }
  while (write < a.length) a[write++] = 0;
}
```

---

## P2: Squares of a sorted array

Given a sorted array (may contain negatives), return the squares in sorted order in O(n).

### Approach

Opposite-end pointers. The largest square is at one of the two ends, because the most negative or the most positive value has the largest magnitude. Fill the result **from the back**: compare `|a[lo]|` and `|a[hi]|`, write the larger square at position `pos`, and move that pointer inward.

### Complexity

- Time: O(n) (vs O(n log n) for square-then-sort)
- Space: O(n) for the output (O(1) extra)

### Edge cases

- All negative → reversed order of squares
- All non-negative → squares in place order
- Zeros and duplicates

### Mobile note

The same "merge from both ends" move shows up when combining two sorted feeds where one is stored newest-first and the other oldest-first.

### Kotlin

```kotlin
fun sortedSquares(a: IntArray): IntArray {
    val out = IntArray(a.size)
    var lo = 0
    var hi = a.size - 1
    for (pos in a.size - 1 downTo 0) {
        val l = a[lo] * a[lo]
        val h = a[hi] * a[hi]
        if (l > h) { out[pos] = l; lo++ } else { out[pos] = h; hi-- }
    }
    return out
}
```

### Swift

```swift
func sortedSquares(_ a: [Int]) -> [Int] {
    var out = [Int](repeating: 0, count: a.count)
    var lo = 0, hi = a.count - 1
    var pos = a.count - 1
    while pos >= 0 {
        let l = a[lo] * a[lo], h = a[hi] * a[hi]
        if l > h { out[pos] = l; lo += 1 } else { out[pos] = h; hi -= 1 }
        pos -= 1
    }
    return out
}
```

### Dart

```dart
List<int> sortedSquares(List<int> a) {
  final out = List<int>.filled(a.length, 0);
  var lo = 0, hi = a.length - 1;
  for (var pos = a.length - 1; pos >= 0; pos--) {
    final l = a[lo] * a[lo], h = a[hi] * a[hi];
    if (l > h) {
      out[pos] = l;
      lo++;
    } else {
      out[pos] = h;
      hi--;
    }
  }
  return out;
}
```

### TypeScript

```typescript
function sortedSquares(a: number[]): number[] {
  const out = new Array<number>(a.length).fill(0);
  let lo = 0;
  let hi = a.length - 1;
  for (let pos = a.length - 1; pos >= 0; pos--) {
    const l = a[lo] * a[lo];
    const h = a[hi] * a[hi];
    if (l > h) {
      out[pos] = l;
      lo++;
    } else {
      out[pos] = h;
      hi--;
    }
  }
  return out;
}
```

---

## P3: Sort colors (three-way partition)

Values are `0`, `1` or `2` (unread, read, archived). Sort them in one pass, in place.

### Approach

Dutch national flag with three pointers:

- `a[0 until low]` are all 0
- `a[low until mid]` are all 1
- `a[mid..high]` are not yet examined
- `a[high+1 until n]` are all 2

Look at `a[mid]`. If it is 0, swap it to `low` and advance both. If it is 1, advance `mid`. If it is 2, swap it to `high` and shrink `high`, but **do not advance `mid`**, because the value just swapped in hasn't been examined yet.

### Complexity

- Time: O(n), one pass
- Space: O(1)

### Edge cases

- Empty array
- All the same value
- Already sorted / reverse sorted

### Mobile note

Grouping by a small enum (status, priority bucket) never needs a comparison sort. One pass, or counting sort, is enough, and the UI can show section headers right away.

### Kotlin

```kotlin
fun sortColors(a: IntArray) {
    var low = 0
    var mid = 0
    var high = a.size - 1
    while (mid <= high) {
        when (a[mid]) {
            0 -> { a[mid] = a[low].also { a[low] = a[mid] }; low++; mid++ }
            1 -> mid++
            else -> { a[mid] = a[high].also { a[high] = a[mid] }; high-- }
        }
    }
}
```

### Swift

```swift
func sortColors(_ a: inout [Int]) {
    var low = 0, mid = 0, high = a.count - 1
    while mid <= high {
        switch a[mid] {
        case 0:
            a.swapAt(low, mid); low += 1; mid += 1
        case 1:
            mid += 1
        default:
            a.swapAt(mid, high); high -= 1
        }
    }
}
```

### Dart

```dart
void sortColors(List<int> a) {
  var low = 0, mid = 0, high = a.length - 1;
  void swap(int i, int j) {
    final t = a[i];
    a[i] = a[j];
    a[j] = t;
  }

  while (mid <= high) {
    if (a[mid] == 0) {
      swap(low++, mid++);
    } else if (a[mid] == 1) {
      mid++;
    } else {
      swap(mid, high--);
    }
  }
}
```

### TypeScript

```typescript
function sortColors(a: number[]): void {
  let low = 0;
  let mid = 0;
  let high = a.length - 1;
  while (mid <= high) {
    if (a[mid] === 0) {
      [a[low], a[mid]] = [a[mid], a[low]];
      low++;
      mid++;
    } else if (a[mid] === 1) {
      mid++;
    } else {
      [a[mid], a[high]] = [a[high], a[mid]];
      high--;
    }
  }
}
```
