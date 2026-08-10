# Chapter 17 — Model Solutions

Model solutions for Chapter 17 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-v/17-greedy-thinking.md`](../../book/part-v/17-greedy-thinking.md).

---

## P1: Jump game

### Approach

Greedy farthest-reach: scan left to right. If index `i` is beyond `farthest`, it is unreachable → false. Otherwise extend `farthest` to `max(farthest, i + nums[i])`. Success when `farthest >= last index`.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- Single element → true
- `nums[0] == 0` and n > 1 → false
- Zeros in the middle that block the path
- Large jumps that skip past the end → true

### Mobile note

Same idea as “can the user finish this pager / wizard given skip allowances?” Safe on main thread for normal list sizes. Do not recurse every jump path — that is exponential.

### Kotlin

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

### Swift

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

### Dart

```dart
bool canJump(List<int> nums) {
  var farthest = 0;
  for (var i = 0; i < nums.length; i++) {
    if (i > farthest) return false;
    final reach = i + nums[i];
    if (reach > farthest) farthest = reach;
    if (farthest >= nums.length - 1) return true;
  }
  return true;
}
```

### TypeScript

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

---

## P2: Non-overlapping intervals

### Approach

Minimum removals so intervals do not overlap ≡ `n - maximum non-overlapping count`. Sort by **end** time ascending. Greedily keep an interval if its start ≥ last kept end; otherwise remove (count++). On conflict, the earlier-ending interval is already kept — discard the current one.

### Complexity

- Time: O(n log n) sort + O(n) scan
- Space: O(1) extra beyond sort (language-dependent)

### Edge cases

- Empty / single interval → 0 removals
- All overlapping at one point — careful with touching endpoints: treat `[1,2]` and `[2,3]` as non-overlapping if half-open or `start >= lastEnd`
- Identical intervals → keep one

### Mobile note

Calendar “remove fewest conflicting local drafts” before sync. Sort/copy off the main thread if the user has thousands of events; the greedy scan itself is cheap.

### Kotlin

```kotlin
fun eraseOverlapIntervals(intervals: Array<IntArray>): Int {
    if (intervals.isEmpty()) return 0
    intervals.sortBy { it[1] }
    var keptEnd = intervals[0][1]
    var removals = 0
    for (i in 1 until intervals.size) {
        if (intervals[i][0] >= keptEnd) {
            keptEnd = intervals[i][1]
        } else {
            removals++
        }
    }
    return removals
}
```

### Swift

```swift
func eraseOverlapIntervals(_ intervals: [[Int]]) -> Int {
    if intervals.isEmpty { return 0 }
    let sorted = intervals.sorted { $0[1] < $1[1] }
    var keptEnd = sorted[0][1]
    var removals = 0
    for i in 1..<sorted.count {
        if sorted[i][0] >= keptEnd {
            keptEnd = sorted[i][1]
        } else {
            removals += 1
        }
    }
    return removals
}
```

### Dart

```dart
int eraseOverlapIntervals(List<List<int>> intervals) {
  if (intervals.isEmpty) return 0;
  intervals.sort((a, b) => a[1].compareTo(b[1]));
  var keptEnd = intervals[0][1];
  var removals = 0;
  for (var i = 1; i < intervals.length; i++) {
    if (intervals[i][0] >= keptEnd) {
      keptEnd = intervals[i][1];
    } else {
      removals++;
    }
  }
  return removals;
}
```

### TypeScript

```typescript
function eraseOverlapIntervals(intervals: number[][]): number {
  if (!intervals.length) return 0;
  intervals.sort((a, b) => a[1] - b[1]);
  let keptEnd = intervals[0][1];
  let removals = 0;
  for (let i = 1; i < intervals.length; i++) {
    if (intervals[i][0] >= keptEnd) keptEnd = intervals[i][1];
    else removals++;
  }
  return removals;
}
```

---

## P3: Assign cookies

### Approach

Sort greed factors and cookie sizes ascending. Two pointers: for each child in order, advance the cookie pointer until the cookie is large enough or cookies run out. Assign when `s[j] >= g[i]`; count++.

### Complexity

- Time: O(n log n + m log m)
- Space: O(1) extra if sorting in place

### Edge cases

- No cookies / no children
- All cookies too small
- One huge cookie for the greediest child only — sorting still correct
- Equal sizes and greeds

### Mobile note

Lite matching pattern: assign limited download slots or promo codes to the “smallest need first” to maximize satisfied users. Document that this maximizes *count*, not total utility.

### Kotlin

```kotlin
fun findContentChildren(g: IntArray, s: IntArray): Int {
    g.sort()
    s.sort()
    var i = 0
    var j = 0
    while (i < g.size && j < s.size) {
        if (s[j] >= g[i]) i++
        j++
    }
    return i
}
```

### Swift

```swift
func findContentChildren(_ g: [Int], _ s: [Int]) -> Int {
    let kids = g.sorted()
    let cookies = s.sorted()
    var i = 0, j = 0
    while i < kids.count && j < cookies.count {
        if cookies[j] >= kids[i] { i += 1 }
        j += 1
    }
    return i
}
```

### Dart

```dart
int findContentChildren(List<int> g, List<int> s) {
  g.sort();
  s.sort();
  var i = 0, j = 0;
  while (i < g.length && j < s.length) {
    if (s[j] >= g[i]) i++;
    j++;
  }
  return i;
}
```

### TypeScript

```typescript
function findContentChildren(g: number[], s: number[]): number {
  g.sort((a, b) => a - b);
  s.sort((a, b) => a - b);
  let i = 0, j = 0;
  while (i < g.length && j < s.length) {
    if (s[j] >= g[i]) i++;
    j++;
  }
  return i;
}
```
