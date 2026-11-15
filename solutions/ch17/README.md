# Chapter 17 — Model Solutions

Model solutions for Chapter 17 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-iv/17-intervals-sweep-line.md`](../../book/part-iv/17-intervals-sweep-line.md).

---

## P1: Can attend all meetings

Given half-open `[start, end)` meetings, return `true` if no two overlap.

### Approach

Sort by start, then check neighbours only: if any `meetings[i].start < meetings[i - 1].end`, two meetings overlap. After sorting, a meeting can only conflict with an earlier one if it conflicts with the one just before it in sorted order (or an overlap already shows up earlier in the scan).

### Complexity

- Time: O(n log n)
- Space: O(n) for the sorted copy (O(1) extra if sorting in place is allowed)

### Edge cases

- Back-to-back `[9, 10)`, `[10, 11)` → no conflict (half-open)
- Empty or single meeting → `true`
- Identical meetings → conflict

### Mobile note

Run this when the user saves an event to show a "conflicts with…" warning. For an incremental check (one new event against an already-sorted day), binary search the insertion point and compare only the two neighbours: O(log n).

### Kotlin

```kotlin
fun canAttendAll(meetings: List<IntArray>): Boolean {
    val sorted = meetings.sortedBy { it[0] }
    for (i in 1 until sorted.size) {
        if (sorted[i][0] < sorted[i - 1][1]) return false
    }
    return true
}
```

### Swift

```swift
func canAttendAll(_ meetings: [(start: Int, end: Int)]) -> Bool {
    let sorted = meetings.sorted { $0.start < $1.start }
    for i in sorted.indices.dropFirst() where sorted[i].start < sorted[i - 1].end {
        return false
    }
    return true
}
```

### Dart

```dart
bool canAttendAll(List<List<int>> meetings) {
  final sorted = [...meetings]..sort((a, b) => a[0].compareTo(b[0]));
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i][0] < sorted[i - 1][1]) return false;
  }
  return true;
}
```

### TypeScript

```typescript
function canAttendAll(meetings: [number, number][]): boolean {
  const sorted = [...meetings].sort((a, b) => a[0] - b[0]);
  for (let i = 1; i < sorted.length; i++) {
    if (sorted[i][0] < sorted[i - 1][1]) return false;
  }
  return true;
}
```

---

## P2: Remove covered intervals

Interval `[a, b)` is covered by `[c, d)` if `c ≤ a` and `b ≤ d`. Return how many intervals remain after removing every covered one.

### Approach

Sort by start **ascending**, and for equal starts by end **descending**. Then any interval that could cover the current one comes before it. Track `maxEnd`, the furthest end seen. If the current end is `≤ maxEnd`, the current interval is covered. Otherwise it survives and `maxEnd` grows.

The descending tie-break matters. For `[1, 4)` and `[1, 6)`, the longer one must be seen first so the shorter one is detected as covered.

### Complexity

- Time: O(n log n)
- Space: O(n) for the sorted copy

### Edge cases

- Identical intervals: one covers the other, so one remains
- Nested chain `[1,10) ⊃ [2,9) ⊃ [3,8)` → 1
- No overlaps → `n`

### Mobile note

Media players get buffered ranges from several fetches. Dropping covered ranges before merging keeps the progress-bar drawing to a handful of segments.

### Kotlin

```kotlin
fun removeCoveredIntervals(intervals: List<IntArray>): Int {
    val sorted = intervals.sortedWith(compareBy<IntArray>({ it[0] }, { -it[1] }))
    var maxEnd = Int.MIN_VALUE
    var kept = 0
    for ((_, end) in sorted) {
        if (end > maxEnd) {
            kept++
            maxEnd = end
        }
    }
    return kept
}
```

### Swift

```swift
func removeCoveredIntervals(_ intervals: [(start: Int, end: Int)]) -> Int {
    let sorted = intervals.sorted { $0.start != $1.start ? $0.start < $1.start : $0.end > $1.end }
    var maxEnd = Int.min, kept = 0
    for iv in sorted where iv.end > maxEnd {
        kept += 1
        maxEnd = iv.end
    }
    return kept
}
```

### Dart

```dart
int removeCoveredIntervals(List<List<int>> intervals) {
  final sorted = [...intervals]
    ..sort((a, b) => a[0] != b[0] ? a[0].compareTo(b[0]) : b[1].compareTo(a[1]));
  var maxEnd = -1 << 62;
  var kept = 0;
  for (final iv in sorted) {
    if (iv[1] > maxEnd) {
      kept++;
      maxEnd = iv[1];
    }
  }
  return kept;
}
```

### TypeScript

```typescript
function removeCoveredIntervals(intervals: [number, number][]): number {
  const sorted = [...intervals].sort((a, b) => a[0] - b[0] || b[1] - a[1]);
  let maxEnd = -Infinity;
  let kept = 0;
  for (const [, end] of sorted) {
    if (end > maxEnd) {
      kept++;
      maxEnd = end;
    }
  }
  return kept;
}
```

---

## P3: Meeting scheduler (two calendars)

`slotsA` and `slotsB` are each person's free slots, `[start, end)`, non-overlapping within each list. Return the earliest `[start, start + duration)` that fits inside a free slot of both people, or an empty result.

### Approach

Sort both lists by start, then use **two pointers**. The overlap of `A[i]` and `B[j]` is `[max(starts), min(ends))`. If it's at least `duration` long, return its start. Otherwise advance whichever slot **ends first**, because it can't overlap anything later in the other list beyond what we've already checked.

### Complexity

- Time: O(n log n + m log m) to sort, plus O(n + m) for the scan
- Space: O(n + m) for the sorted copies

### Edge cases

- Overlap exactly equal to `duration` → valid
- One list empty → no slot
- Slots that only touch (`[9, 10)` and `[10, 11)`) → overlap length 0

### Mobile note

This powers "suggest a time" in a scheduling sheet. Both availabilities are usually already sorted from the server, so the on-device cost is a linear scan on each drag.

### Kotlin

```kotlin
fun meetingScheduler(slotsA: List<IntArray>, slotsB: List<IntArray>, duration: Int): IntArray? {
    val a = slotsA.sortedBy { it[0] }
    val b = slotsB.sortedBy { it[0] }
    var i = 0
    var j = 0
    while (i < a.size && j < b.size) {
        val start = maxOf(a[i][0], b[j][0])
        val end = minOf(a[i][1], b[j][1])
        if (end - start >= duration) return intArrayOf(start, start + duration)
        if (a[i][1] < b[j][1]) i++ else j++
    }
    return null
}
```

### Swift

```swift
func meetingScheduler(_ slotsA: [(start: Int, end: Int)], _ slotsB: [(start: Int, end: Int)], _ duration: Int) -> (start: Int, end: Int)? {
    let a = slotsA.sorted { $0.start < $1.start }
    let b = slotsB.sorted { $0.start < $1.start }
    var i = 0, j = 0
    while i < a.count && j < b.count {
        let start = max(a[i].start, b[j].start)
        let end = min(a[i].end, b[j].end)
        if end - start >= duration { return (start, start + duration) }
        if a[i].end < b[j].end { i += 1 } else { j += 1 }
    }
    return nil
}
```

### Dart

```dart
List<int>? meetingScheduler(List<List<int>> slotsA, List<List<int>> slotsB, int duration) {
  final a = [...slotsA]..sort((x, y) => x[0].compareTo(y[0]));
  final b = [...slotsB]..sort((x, y) => x[0].compareTo(y[0]));
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    final start = a[i][0] > b[j][0] ? a[i][0] : b[j][0];
    final end = a[i][1] < b[j][1] ? a[i][1] : b[j][1];
    if (end - start >= duration) return [start, start + duration];
    if (a[i][1] < b[j][1]) {
      i++;
    } else {
      j++;
    }
  }
  return null;
}
```

### TypeScript

```typescript
function meetingScheduler(
  slotsA: [number, number][],
  slotsB: [number, number][],
  duration: number,
): [number, number] | null {
  const a = [...slotsA].sort((x, y) => x[0] - y[0]);
  const b = [...slotsB].sort((x, y) => x[0] - y[0]);
  let i = 0;
  let j = 0;
  while (i < a.length && j < b.length) {
    const start = Math.max(a[i][0], b[j][0]);
    const end = Math.min(a[i][1], b[j][1]);
    if (end - start >= duration) return [start, start + duration];
    if (a[i][1] < b[j][1]) i++;
    else j++;
  }
  return null;
}
```
