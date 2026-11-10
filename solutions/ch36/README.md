# Chapter 36 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-x/36-heaps-tries-greedy.md`](../../book/part-x/36-heaps-tries-greedy.md). This file adds a timed-review index plus a standalone copy of the **Swift/Dart** versions of the most interview-heavy problems. All four languages are also inline in the chapter.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-x/36-heaps-tries-greedy.md#q1-kth-largest-element-in-a-stream-live-leaderboard-cutoff) | Kth Largest Element in a Stream | Heap (bounded min-heap) | Min-heap of size k; root is the answer |
| [Q2](../../book/part-x/36-heaps-tries-greedy.md#q2-k-closest-points-to-origin-nearest-stores-on-the-map) | K Closest Points to Origin | Heap (bounded max-heap) | Max-heap of size k on squared distance |
| [Q3](../../book/part-x/36-heaps-tries-greedy.md#q3-task-scheduler-notification-cooldown-slots) | Task Scheduler | Greedy / counting | max(tasks.length, (maxF-1)(n+1) + #maxF) |
| [Q4](../../book/part-x/36-heaps-tries-greedy.md#q4-design-add-and-search-words-data-structure-wildcard-contact-search) | Design Add and Search Words Data Structure | Trie + DFS | Trie; `.` fans out to every child |
| [Q5](../../book/part-x/36-heaps-tries-greedy.md#q5-word-search-ii-word-game-board-scan) | Word Search II | Trie + backtracking | One trie, one DFS per cell; clear word on hit |
| [Q6](../../book/part-x/36-heaps-tries-greedy.md#q6-jump-game-ii-fewest-deep-link-hops) | Jump Game II | Greedy (BFS by ranges) | Implicit BFS: curEnd / farthest window |
| [Q7](../../book/part-x/36-heaps-tries-greedy.md#q7-gas-station-ev-delivery-loop-start) | Gas Station | Greedy (prefix reset) | Total ≥ 0 check; reset start when tank < 0 |
| [Q8](../../book/part-x/36-heaps-tries-greedy.md#q8-hand-of-straights-consecutive-ticket-batches) | Hand of Straights | Greedy + ordered map | Smallest card starts a run; consume from ordered counts |
| [Q9](../../book/part-x/36-heaps-tries-greedy.md#q9-merge-triplets-to-form-target-triplet-release-gate-versions) | Merge Triplets to Form Target Triplet | Greedy (filter) | Drop overshooting triplets; each slot must be hit exactly |
| [Q10](../../book/part-x/36-heaps-tries-greedy.md#q10-partition-labels-chunking-a-sync-log) | Partition Labels | Greedy (last occurrence) | Last index per letter; close chunk when i == end |
| [Q11](../../book/part-x/36-heaps-tries-greedy.md#q11-valid-parenthesis-string-template-brackets-with-wildcards) | Valid Parenthesis String | Greedy (range of balances) | Track [lo, hi] open-count range; clamp lo |

---

## Q3 — Task Scheduler (Swift / Dart)

### Swift

```swift
func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
    var freq = [Int](repeating: 0, count: 26)
    for t in tasks {
        guard let v = t.asciiValue, v >= 65, v <= 90 else { continue } // labels are 'A'...'Z'
        freq[Int(v) - 65] += 1
    }
    guard let maxF = freq.max(), maxF > 0 else { return 0 }
    let maxCount = freq.filter { $0 == maxF }.count
    return max(tasks.count, (maxF - 1) * (n + 1) + maxCount)
}
```

### Dart

```dart
int leastInterval(List<String> tasks, int n) {
  if (tasks.isEmpty) return 0;
  final freq = List<int>.filled(26, 0);
  for (final t in tasks) {
    freq[t.codeUnitAt(0) - 65]++;
  }
  final maxF = freq.reduce(max);
  final maxCount = freq.where((f) => f == maxF).length;
  return max(tasks.length, (maxF - 1) * (n + 1) + maxCount);
}
```

---

## Q5 — Word Search II (Swift / Dart)

### Swift

```swift
final class WordNode {
    var next: [Character: WordNode] = [:]
    var word: String?
}

func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
    let root = WordNode()
    for w in words {
        var cur = root
        for c in w {
            if let nx = cur.next[c] {
                cur = nx
            } else {
                let nx = WordNode()
                cur.next[c] = nx
                cur = nx
            }
        }
        cur.word = w
    }
    var grid = board // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    var found: [String] = []
    func dfs(_ r: Int, _ c: Int, _ parent: WordNode) {
        let ch = grid[r][c]
        guard let node = parent.next[ch] else { return } // '#' is never a trie edge
        if let w = node.word {
            found.append(w)
            node.word = nil // report once
        }
        grid[r][c] = "#"
        if r > 0 { dfs(r - 1, c, node) }
        if r < rows - 1 { dfs(r + 1, c, node) }
        if c > 0 { dfs(r, c - 1, node) }
        if c < cols - 1 { dfs(r, c + 1, node) }
        grid[r][c] = ch
    }
    for r in 0..<rows { for c in 0..<cols { dfs(r, c, root) } }
    return found
}
```

### Dart

```dart
class WordNode {
  final next = <String, WordNode>{};
  String? word;
}

List<String> findWords(List<List<String>> board, List<String> words) {
  final root = WordNode();
  for (final w in words) {
    var cur = root;
    for (final c in w.split('')) {
      cur = cur.next.putIfAbsent(c, () => WordNode());
    }
    cur.word = w;
  }
  final rows = board.length, cols = board[0].length;
  final found = <String>[];
  void dfs(int r, int c, WordNode parent) {
    final ch = board[r][c];
    final node = parent.next[ch]; // '#' is never a trie edge
    if (node == null) return;
    final w = node.word;
    if (w != null) {
      found.add(w);
      node.word = null; // report once
    }
    board[r][c] = '#';
    if (r > 0) dfs(r - 1, c, node);
    if (r < rows - 1) dfs(r + 1, c, node);
    if (c > 0) dfs(r, c - 1, node);
    if (c < cols - 1) dfs(r, c + 1, node);
    board[r][c] = ch;
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      dfs(r, c, root);
    }
  }
  return found;
}
```

---

## Q8 — Hand of Straights (Swift / Dart)

### Swift

```swift
func isNStraightHand(_ hand: [Int], _ groupSize: Int) -> Bool {
    if hand.count % groupSize != 0 { return false }
    var count: [Int: Int] = [:]
    for h in hand { count[h, default: 0] += 1 }
    for first in count.keys.sorted() {
        let need = count[first] ?? 0 // groups that must start here
        if need == 0 { continue }
        for v in first..<(first + groupSize) {
            let have = count[v] ?? 0
            if have < need { return false }
            count[v] = have - need
        }
    }
    return true
}
```

### Dart

```dart
bool isNStraightHand(List<int> hand, int groupSize) {
  if (hand.length % groupSize != 0) return false;
  final count = <int, int>{};
  for (final h in hand) {
    count[h] = (count[h] ?? 0) + 1;
  }
  final keys = count.keys.toList()..sort();
  for (final first in keys) {
    final need = count[first] ?? 0; // groups that must start here
    if (need == 0) continue;
    for (var v = first; v < first + groupSize; v++) {
      final have = count[v] ?? 0;
      if (have < need) return false;
      count[v] = have - need;
    }
  }
  return true;
}
```

---

Back to [Chapter 36](../../book/part-x/36-heaps-tries-greedy.md).
