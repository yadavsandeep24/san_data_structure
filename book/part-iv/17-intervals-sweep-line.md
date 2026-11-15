# Chapter 17 — Intervals & Sweep Line

An interval is a `[start, end)` pair, such as a meeting, a booking, a download or a video segment. Almost every interval problem starts with the same move: **sort**, by start or by end depending on the question, and then make one linear pass. When the question is "how many overlap at once?", break each interval into two **events** (start = +1, end = −1), sort the events, and sweep across them keeping a running count. That technique is the **sweep line**.

---

## Mobile motivation

- **Calendar:** merge a user's overlapping busy blocks before drawing them, so the day view doesn't stack five translucent rectangles.
- **Scheduling across two people:** "find the first 30-minute slot when both are free" runs on device while the user drags a time picker.
- **Download manager:** what is the peak number of concurrent downloads in this session trace? If it exceeds the connection pool, requests queued.
- **Video player:** buffered ranges from multiple fetches arrive out of order. Merge them to draw the grey "buffered" bar and to decide what to fetch next.
- **Ads and banners:** choose the most non-overlapping promo slots (greedy by end time, Chapter 23).

---

## Conventions first

| Decide | Recommendation |
|--------|----------------|
| Open or closed end? | Use **half-open `[start, end)`** for time. A meeting ending at 10:00 and one starting at 10:00 **do not** overlap. State your choice in interviews. |
| Representation | `IntArray(2)` / tuple / small struct. Store times as **epoch millis or minutes**, never formatted strings. |
| Overlap test | `a.start < b.end && b.start < a.end` (half-open). For closed intervals, use `<=`. |
| Input sorted? | Ask. If the server already returns events sorted by start, the problem drops from O(n log n) to O(n). |

---

## The four moves

| Question | Sort by | Pass | Chapter / drill |
|----------|---------|------|-----------------|
| **Merge** overlapping intervals | start | Extend the last merged interval or start a new one | Worked example 1 |
| **Max non-overlapping** / fewest removals / fewest arrows | **end** | Greedy: keep the interval that ends earliest | Chapter 23, [Ch 32 Q11](../part-viii/32-two-pointers-windows-intervals.md) |
| **How many at once** (peak overlap, rooms needed) | events (time, delta) | Running count over the sorted events | Worked example 2, [Ch 29 Q27](../part-viii/29-interview-questions-q21-q30.md) |
| **Intersect** two sorted lists | already sorted | Two pointers. Advance whichever ends first | [Ch 32 Q12](../part-viii/32-two-pointers-windows-intervals.md), Practice 3 |

### Why sort by end for the greedy

To fit the most non-overlapping intervals, always take the one that **frees up the timeline soonest**. Swapping any optimal solution's first pick for the earliest-ending interval can't cause new conflicts, so the greedy is optimal (an exchange argument). Sorting by start fails on `[1, 100), [2, 3), [4, 5)`.

### Tie-breaking in the sweep

With half-open intervals, at the same timestamp, process **end events before start events**. Otherwise `[1, 3)` and `[3, 5)` briefly count as 2 concurrent. Sorting `(time, delta)` with `delta = −1` for ends does this automatically, because −1 sorts before +1.

---

## Complexity at a glance

| Problem | Time | Extra space |
|---------|------|-------------|
| Merge intervals | O(n log n) sort + O(n) | O(n) output |
| Max non-overlapping (greedy) | O(n log n) | O(1) besides the sort |
| Peak concurrency (sweep) | O(n log n) | O(n) events |
| Peak concurrency (min-heap of end times) | O(n log n) | O(n) |
| Intersection of two sorted lists | O(n + m) | O(output) |
| Insert one interval into a sorted, merged list | O(n) | O(n) |

If the time range is small and discrete (minutes in a day, 1,440 slots), a **difference array** (Chapter 15) gives O(n + range) peak concurrency with no sort.

---

## How to recognize it

1. Inputs are **pairs** of start and end (times, positions, ranges).
2. Words like "overlap", "merge", "conflict", "free slot", "rooms", "concurrent", "covered", "arrows".
3. "Minimum number of resources" means peak concurrency (sweep or heap).
4. "Maximum number of non-conflicting items" means greedy by end.
5. Two **sorted** schedules to combine means two pointers.

---

## Platform bridges

| Platform | Where intervals live |
|----------|----------------------|
| **Android** | `CalendarContract` instances, ExoPlayer/Media3 buffered ranges, WorkManager windows. Sort with `sortBy { it.start }` (stable TimSort) on a background dispatcher for long histories. |
| **iOS** | EventKit `EKEvent` start and end dates, `AVPlayerItem.loadedTimeRanges` (already `CMTimeRange` intervals). `sorted(by:)` is an introsort and not stable. Add a tie-breaker if order matters. |
| **Flutter** | Calendar packages (`table_calendar`, `syncfusion`) draw merged blocks. `video_player` exposes `buffered` as `DurationRange`s to merge. |
| **React Native** | Agenda views, `react-native-video` `onProgress` / buffered ranges. Convert ISO strings to numbers **once** before sorting, because `new Date()` inside a comparator is slow. |

**Time zones:** compare in UTC epoch values. Convert to local time only for display. DST changes make "local 1:30 AM" ambiguous.

---

## Worked example 1: merge busy blocks

Merge overlapping `[start, end)` blocks. Blocks that only touch (`[1, 3)` and `[3, 5)`) are merged too, so the day view shows one continuous busy bar. Use `<` instead of `<=` if touching blocks should stay separate.

### Kotlin

```kotlin
fun mergeBusy(blocks: List<IntArray>): List<IntArray> {
    if (blocks.isEmpty()) return emptyList()
    val sorted = blocks.sortedBy { it[0] }
    val out = mutableListOf(sorted[0].copyOf())
    for (i in 1 until sorted.size) {
        val cur = sorted[i]
        val last = out.last()
        if (cur[0] <= last[1]) {
            last[1] = maxOf(last[1], cur[1])   // overlap or touch: extend
        } else {
            out.add(cur.copyOf())              // gap: start a new block
        }
    }
    return out
}
```

### Swift

```swift
func mergeBusy(_ blocks: [(start: Int, end: Int)]) -> [(start: Int, end: Int)] {
    let sorted = blocks.sorted { $0.start < $1.start }
    var out: [(start: Int, end: Int)] = []
    for b in sorted {
        if let last = out.last, b.start <= last.end {
            out[out.count - 1].end = max(last.end, b.end)
        } else {
            out.append(b)
        }
    }
    return out
}
```

### Dart

```dart
List<List<int>> mergeBusy(List<List<int>> blocks) {
  final sorted = [...blocks]..sort((a, b) => a[0].compareTo(b[0]));
  final out = <List<int>>[];
  for (final b in sorted) {
    if (out.isNotEmpty && b[0] <= out.last[1]) {
      if (b[1] > out.last[1]) out.last[1] = b[1];
    } else {
      out.add([b[0], b[1]]);
    }
  }
  return out;
}
```

### TypeScript

```typescript
function mergeBusy(blocks: [number, number][]): [number, number][] {
  const sorted = [...blocks].sort((a, b) => a[0] - b[0]);
  const out: [number, number][] = [];
  for (const [s, e] of sorted) {
    const last = out[out.length - 1];
    if (last && s <= last[1]) last[1] = Math.max(last[1], e);
    else out.push([s, e]);
  }
  return out;
}
```

**Complexity:** O(n log n) time for the sort, O(n) for the output. **Mobile note:** copy before mutating (`copyOf`, spread). Sorting or extending the caller's list in place can corrupt state that Compose or SwiftUI is still rendering.

---

## Worked example 2: peak concurrent downloads (sweep line)

Given `[start, end)` download intervals, return the maximum number active at the same instant.

### Kotlin

```kotlin
fun peakConcurrent(intervals: List<IntArray>): Int {
    val events = ArrayList<IntArray>(intervals.size * 2)
    for ((s, e) in intervals) {
        events.add(intArrayOf(s, +1))
        events.add(intArrayOf(e, -1))
    }
    events.sortWith(compareBy<IntArray>({ it[0] }, { it[1] }))  // ends (-1) before starts at ties
    var active = 0
    var peak = 0
    for ((_, delta) in events) {
        active += delta
        peak = maxOf(peak, active)
    }
    return peak
}
```

### Swift

```swift
func peakConcurrent(_ intervals: [(start: Int, end: Int)]) -> Int {
    var events: [(time: Int, delta: Int)] = []
    events.reserveCapacity(intervals.count * 2)
    for iv in intervals {
        events.append((iv.start, 1))
        events.append((iv.end, -1))
    }
    events.sort { $0.time != $1.time ? $0.time < $1.time : $0.delta < $1.delta }
    var active = 0, peak = 0
    for e in events {
        active += e.delta
        peak = max(peak, active)
    }
    return peak
}
```

### Dart

```dart
int peakConcurrent(List<List<int>> intervals) {
  final events = <List<int>>[];
  for (final iv in intervals) {
    events.add([iv[0], 1]);
    events.add([iv[1], -1]);
  }
  events.sort((a, b) => a[0] != b[0] ? a[0].compareTo(b[0]) : a[1].compareTo(b[1]));
  var active = 0, peak = 0;
  for (final e in events) {
    active += e[1];
    if (active > peak) peak = active;
  }
  return peak;
}
```

### TypeScript

```typescript
function peakConcurrent(intervals: [number, number][]): number {
  const events: [number, number][] = [];
  for (const [s, e] of intervals) {
    events.push([s, 1], [e, -1]);
  }
  events.sort((a, b) => a[0] - b[0] || a[1] - b[1]);
  let active = 0;
  let peak = 0;
  for (const [, delta] of events) {
    active += delta;
    peak = Math.max(peak, active);
  }
  return peak;
}
```

**Complexity:** O(n log n) time, O(n) space. **Mobile note:** compare the result with your HTTP client's per-host connection limit (OkHttp's dispatcher allows 5 per host by default, `URLSession` usually 6). If the peak is higher, requests waited in a queue, which explains "slow" images that weren't slow on the network.

**Heap alternative:** sort by start, keep a min-heap of end times, pop every end that is ≤ the current start, then push. The heap size is the number active, and its maximum is the answer ([Ch 29 Q27](../part-viii/29-interview-questions-q21-q30.md)).

---

## Common mistakes

1. **Not stating open vs closed ends.** Half the bugs are `<` vs `<=`.
2. **Sorting by start for the max-non-overlapping greedy.** It must be by **end**.
3. **Wrong tie order in the sweep:** starts before ends at the same time over-counts back-to-back meetings.
4. **Mutating the input** while merging, which corrupts the caller's list or UI state.
5. **Comparing formatted time strings** (`"9:30" > "10:00"` as strings). Convert to numbers.
6. **Local-time arithmetic across DST.** Do interval maths in UTC.
7. **Overflow in comparators** (`a[0] - b[0]` with large epoch millis in Kotlin/Java `Int`). Use `compareBy` or `Long`.

---

## Self-Check

**17.1** Why does the "maximum number of non-overlapping intervals" greedy sort by end time rather than start time?

**17.2** In a sweep line over half-open intervals, which comes first at equal timestamps, end or start events? Why?

**17.3** Give the overlap test for two half-open intervals `[a1, a2)` and `[b1, b2)`.

**17.4** Peak concurrency can be solved with a sweep or with a min-heap of end times. When would a difference array beat both?

**17.5** Your calendar's merge function sorts the list it receives in place. What can go wrong in a declarative UI?

*(Answers: Appendix D.)*

---

## Practice

1. **Can attend all meetings** — given `[start, end)` meetings, report whether any two overlap (calendar conflict warning). [solutions/ch17](../../solutions/ch17/README.md#p1-can-attend-all-meetings)
2. **Remove covered intervals** — count the intervals that are not fully covered by another (hide redundant buffered ranges). [solutions/ch17](../../solutions/ch17/README.md#p2-remove-covered-intervals)
3. **Meeting scheduler (two calendars)** — given both people's free slots, return the earliest slot of at least `duration` that suits both. [solutions/ch17](../../solutions/ch17/README.md#p3-meeting-scheduler-two-calendars)

### More practice

- [Ch 23 — Greedy Thinking](../part-vi/23-greedy-thinking.md): interval scheduling, non-overlapping intervals
- [Ch 32 — Two Pointers, Windows & Intervals](../part-viii/32-two-pointers-windows-intervals.md): Q11 Minimum Number of Arrows · Q12 Interval List Intersections
- [Ch 29 — Interview Questions, Q21–Q30](../part-viii/29-interview-questions-q21-q30.md): Q27 Meeting Rooms / Min Platforms
- [Ch 30 — Hard Drill Bank, Q1–Q10](../part-viii/30-hard-drill-bank-q01-q10.md): Q8 Merge Intervals + Insert Interval

---

## What to remember

Decide whether ends are open or closed, convert everything to numbers in UTC, then sort. Sort by start to merge. Sort by end to pick the most non-overlapping items. Sort events (ends before starts at ties) to count concurrency. Two pointers intersect two sorted schedules. Copy before you mutate, because the list you were given may still be on screen.

---

Previous: [Chapter 16 — Monotonic Stack & Deque](16-monotonic-stack-deque.md) · Next: [Chapter 18 — Caching Strategies](../part-v/18-caching-strategies.md) · Solutions: [`solutions/ch17`](../../solutions/ch17/README.md)
