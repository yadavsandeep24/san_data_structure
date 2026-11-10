# Chapter 37 — Graphs & Dynamic Programming (12-Day Plan Gap-Closer)

Part X closes the gaps between this book and the public **12-day DSA plan** (120 problems): it holds only the plan problems no earlier chapter solved. The rest already live elsewhere — the [Chapter 24 question bank](../part-vii/24-interview-questions.md), the [Chapter 27 hard bank](../part-viii/27-hard-drill-bank.md), and the topic chapters [17 greedy](../part-v/17-greedy-thinking.md), [18 heaps](../part-vi/18-heaps-priority-queues.md), [19 DP](../part-vi/19-dynamic-programming.md), [20 graphs](../part-vi/20-graphs-advanced.md) and [10 tries](../part-iii/10-trees-practical.md). Same mobile framing habit as the rest of the book; statements are rewritten, not copied.

Companion index: [`solutions/ch37/README.md`](../../solutions/ch37/README.md)

---

## How to use

| Plan day | Problems in this chapter | Same-day problems already in the book |
|----------|--------------------------|---------------------------------------|
| **Day 10** | Q1 Max Area of Island; Q2 Rotting Oranges; Q3 Pacific Atlantic Water Flow; Q4 Surrounded Regions | Number of Islands ([Ch 22](../part-vi/22-bits-matrix.md)), Clone Graph ([Ch 24](../part-vii/24-interview-questions.md)), Course Schedule ([Ch 24 Q23](../part-vii/24-interview-questions.md#q23-course-schedule-cycle-detect)); the greedy half of Day 10 is in [Ch 36](36-heaps-tries-greedy.md) |
| **Day 11** | Q5 Graph Valid Tree; Q6 Min Cost Climbing Stairs; Q7 House Robber II; Q8 Decode Ways | Course Schedule II ([Ch 27 Q6](../part-viii/27-hard-drill-bank.md)), Redundant Connection ([`solutions/ch20`](../../solutions/ch20/README.md)), Climbing Stairs and House Robber ([Ch 19](../part-vi/19-dynamic-programming.md)), Longest Palindromic Substring ([Ch 21](../part-vi/21-strings.md)); Connected Components uses the Q5 union-find with a component count |
| **Day 12** | Q9 Longest Increasing Subsequence; Q10 Combination Sum IV; Q11 Longest Common Subsequence; Q12 Best Time to Buy and Sell Stock with Cooldown; Q13 Coin Change II; Q14 Target Sum | Coin Change ([Ch 24 Q30](../part-vii/24-interview-questions.md#q30-coin-change)), Word Break ([Ch 27 Q4](../part-viii/27-hard-drill-bank.md)), Unique Paths ([Ch 24](../part-vii/24-interview-questions.md)), Edit Distance ([Ch 27 Q12](../part-viii/27-hard-drill-bank.md)) |

Protocol is the Chapter 27 one: restate + edges (3–5 min), say **time/space before code**, code the happy path, then edges. **Languages:** every problem is shown in Kotlin (Android/KMP), Swift (iOS), Dart (Flutter) and TypeScript (React Native), in that order, with the same names and behaviour. Dart snippets assume `import 'dart:math';` for `max`/`min`. Work a plan day's problems together — they share one technique.

---

## Q1. Max Area of Island (Largest Heatmap Region)

**Topic:** Grid DFS (iterative)

**Plan day:** Day 10

**Statement**

A tap heatmap is a 0/1 grid, where `1` marks a hot cell. Return the size of the largest group of hot cells connected up, down, left or right, or `0` if there is none. Example: a grid with islands of sizes 4 and 5 → `5`.

**Approach**

Brute force: start a fresh flood from every cell without marking cells visited, O((R·C)²).

Scan the grid. At each unvisited `1`, flood its island with an **explicit stack**, marking cells `2` as they are pushed and counting pops. Keep the largest count.

**Complexity:** Time O(R·C), Space O(R·C) worst-case stack

### Kotlin

```kotlin
fun maxAreaOfIsland(grid: Array<IntArray>): Int {
    val rows = grid.size
    val cols = grid[0].size
    val dirs = intArrayOf(1, 0, -1, 0, 1)
    val stack = ArrayDeque<Int>()
    var best = 0
    for (r in 0 until rows) for (c in 0 until cols) {
        if (grid[r][c] != 1) continue
        grid[r][c] = 2 // visited
        stack.addLast(r * cols + c)
        var area = 0
        while (stack.isNotEmpty()) {
            val cell = stack.removeLast()
            area++
            for (d in 0..3) {
                val nr = cell / cols + dirs[d]
                val nc = cell % cols + dirs[d + 1]
                if (nr in 0 until rows && nc in 0 until cols && grid[nr][nc] == 1) {
                    grid[nr][nc] = 2
                    stack.addLast(nr * cols + nc)
                }
            }
        }
        best = maxOf(best, area)
    }
    return best
}
```

### Swift

```swift
func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
    var grid = grid // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    let dirs = [1, 0, -1, 0, 1]
    var best = 0
    for r in 0..<rows {
        for c in 0..<cols where grid[r][c] == 1 {
            grid[r][c] = 2 // visited
            var stack = [r * cols + c]
            var area = 0
            while let cell = stack.popLast() {
                area += 1
                for d in 0..<4 {
                    let nr = cell / cols + dirs[d], nc = cell % cols + dirs[d + 1]
                    if nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1 {
                        grid[nr][nc] = 2
                        stack.append(nr * cols + nc)
                    }
                }
            }
            best = max(best, area)
        }
    }
    return best
}
```

### Dart

```dart
int maxAreaOfIsland(List<List<int>> grid) {
  final rows = grid.length, cols = grid[0].length;
  const dirs = [1, 0, -1, 0, 1];
  var best = 0;
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (grid[r][c] != 1) continue;
      grid[r][c] = 2; // visited
      final stack = [r * cols + c];
      var area = 0;
      while (stack.isNotEmpty) {
        final cell = stack.removeLast();
        area++;
        for (var d = 0; d < 4; d++) {
          final nr = cell ~/ cols + dirs[d], nc = cell % cols + dirs[d + 1];
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1) {
            grid[nr][nc] = 2;
            stack.add(nr * cols + nc);
          }
        }
      }
      best = max(best, area);
    }
  }
  return best;
}
```

### TypeScript

```typescript
function maxAreaOfIsland(grid: number[][]): number {
  const rows = grid.length, cols = grid[0].length;
  const dirs = [1, 0, -1, 0, 1];
  let best = 0;
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] !== 1) continue;
      grid[r][c] = 2; // visited
      const stack = [r * cols + c];
      let area = 0;
      while (stack.length > 0) {
        const cell = stack.pop()!;
        area++;
        const cr = Math.floor(cell / cols), cc = cell % cols;
        for (let d = 0; d < 4; d++) {
          const nr = cr + dirs[d], nc = cc + dirs[d + 1];
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] === 1) {
            grid[nr][nc] = 2;
            stack.push(nr * cols + nc);
          }
        }
      }
      best = Math.max(best, area);
    }
  }
  return best;
}
```

**Mobile note:** Use an explicit stack rather than recursion: a 1000×1000 all-ones grid would overflow the default thread stack on Android. The Kotlin, Dart and TypeScript versions change the grid in place, so pass in a copy if the UI still renders the original; Swift arrays are values, so the Swift version works on a local copy.

---

## Q2. Rotting Oranges (Offline Update Spread)

**Topic:** Multi-source BFS

**Plan day:** Day 10

**Statement**

Devices sit on a grid: `0` empty, `1` stale, `2` updated. Each minute, every updated device pushes the update to the stale devices next to it (up, down, left, right). Return the minutes until no stale device remains, or `-1` if some can never be reached. Example: `[[2,1,1],[1,1,0],[0,1,1]]` → `4`.

**Approach**

Brute force: simulate minute by minute, rescanning the whole grid each time, O((R·C)²).

Run a **multi-source BFS**: enqueue every `2` at once and process the queue layer by layer, where one layer is one minute. Count the stale devices up front and decrement as they flip. If the count is still above 0 at the end, return `-1`.

**Complexity:** Time O(R·C), Space O(R·C)

### Kotlin

```kotlin
fun orangesRotting(grid: Array<IntArray>): Int {
    val rows = grid.size
    val cols = grid[0].size
    val queue = ArrayDeque<Int>()
    var fresh = 0
    for (r in 0 until rows) for (c in 0 until cols) {
        if (grid[r][c] == 2) queue.addLast(r * cols + c)
        else if (grid[r][c] == 1) fresh++
    }
    val dirs = intArrayOf(1, 0, -1, 0, 1)
    var minutes = 0
    while (queue.isNotEmpty() && fresh > 0) {
        repeat(queue.size) { // one BFS layer = one minute
            val cell = queue.removeFirst()
            for (d in 0..3) {
                val nr = cell / cols + dirs[d]
                val nc = cell % cols + dirs[d + 1]
                if (nr in 0 until rows && nc in 0 until cols && grid[nr][nc] == 1) {
                    grid[nr][nc] = 2
                    fresh--
                    queue.addLast(nr * cols + nc)
                }
            }
        }
        minutes++
    }
    return if (fresh == 0) minutes else -1
}
```

### Swift

```swift
func orangesRotting(_ grid: [[Int]]) -> Int {
    var grid = grid // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    var queue: [Int] = []
    var fresh = 0
    for r in 0..<rows {
        for c in 0..<cols {
            if grid[r][c] == 2 { queue.append(r * cols + c) }
            else if grid[r][c] == 1 { fresh += 1 }
        }
    }
    let dirs = [1, 0, -1, 0, 1]
    var minutes = 0
    while !queue.isEmpty && fresh > 0 {
        var next: [Int] = [] // the next BFS layer = the next minute
        for cell in queue {
            for d in 0..<4 {
                let nr = cell / cols + dirs[d], nc = cell % cols + dirs[d + 1]
                if nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1 {
                    grid[nr][nc] = 2
                    fresh -= 1
                    next.append(nr * cols + nc)
                }
            }
        }
        queue = next
        minutes += 1
    }
    return fresh == 0 ? minutes : -1
}
```

### Dart

```dart
int orangesRotting(List<List<int>> grid) {
  final rows = grid.length, cols = grid[0].length;
  var queue = <int>[];
  var fresh = 0;
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (grid[r][c] == 2) {
        queue.add(r * cols + c);
      } else if (grid[r][c] == 1) {
        fresh++;
      }
    }
  }
  const dirs = [1, 0, -1, 0, 1];
  var minutes = 0;
  while (queue.isNotEmpty && fresh > 0) {
    final next = <int>[]; // the next BFS layer = the next minute
    for (final cell in queue) {
      for (var d = 0; d < 4; d++) {
        final nr = cell ~/ cols + dirs[d], nc = cell % cols + dirs[d + 1];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1) {
          grid[nr][nc] = 2;
          fresh--;
          next.add(nr * cols + nc);
        }
      }
    }
    queue = next;
    minutes++;
  }
  return fresh == 0 ? minutes : -1;
}
```

### TypeScript

```typescript
function orangesRotting(grid: number[][]): number {
  const rows = grid.length, cols = grid[0].length;
  let queue: number[] = [];
  let fresh = 0;
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] === 2) queue.push(r * cols + c);
      else if (grid[r][c] === 1) fresh++;
    }
  }
  const dirs = [1, 0, -1, 0, 1];
  let minutes = 0;
  while (queue.length > 0 && fresh > 0) {
    const next: number[] = []; // the next BFS layer = the next minute
    for (const cell of queue) {
      for (let d = 0; d < 4; d++) {
        const nr = Math.floor(cell / cols) + dirs[d], nc = (cell % cols) + dirs[d + 1];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] === 1) {
          grid[nr][nc] = 2;
          fresh--;
          next.push(nr * cols + nc);
        }
      }
    }
    queue = next;
    minutes++;
  }
  return fresh === 0 ? minutes : -1;
}
```

---

## Q3. Pacific Atlantic Water Flow (Map Tiles Draining to Both Coasts)

**Topic:** Reverse BFS from borders

**Plan day:** Day 10

**Statement**

A terrain grid `heights` borders the Pacific on its top and left edges and the Atlantic on its bottom and right edges. Water flows to a neighbour of equal or lower height. Return every cell `[r, c]` (in row-major order) from which water can reach both oceans.

**Approach**

Brute force: from every cell, search downhill and check which oceans it touches, O((R·C)²).

**Reverse the flow**: run a BFS *uphill* (to neighbours `>=` the current height) from all Pacific border cells, and a second one from all Atlantic border cells. The answer is the cells marked by both searches.

**Complexity:** Time O(R·C), Space O(R·C)

### Kotlin

```kotlin
fun pacificAtlantic(heights: Array<IntArray>): List<List<Int>> {
    val rows = heights.size
    val cols = heights[0].size
    val dirs = intArrayOf(1, 0, -1, 0, 1)
    fun flood(seeds: List<Int>): BooleanArray { // walk uphill from the ocean
        val seen = BooleanArray(rows * cols)
        val queue = ArrayDeque<Int>()
        for (s in seeds) if (!seen[s]) { seen[s] = true; queue.addLast(s) }
        while (queue.isNotEmpty()) {
            val cell = queue.removeFirst()
            val r = cell / cols
            val c = cell % cols
            for (d in 0..3) {
                val nr = r + dirs[d]
                val nc = c + dirs[d + 1]
                if (nr !in 0 until rows || nc !in 0 until cols) continue
                val next = nr * cols + nc
                if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
                    seen[next] = true
                    queue.addLast(next)
                }
            }
        }
        return seen
    }
    val pacific = flood((0 until cols).toList() + (0 until rows).map { it * cols })
    val atlantic = flood((0 until cols).map { (rows - 1) * cols + it } + (0 until rows).map { it * cols + cols - 1 })
    val out = mutableListOf<List<Int>>()
    for (i in 0 until rows * cols) if (pacific[i] && atlantic[i]) out += listOf(i / cols, i % cols)
    return out
}
```

### Swift

```swift
func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
    let rows = heights.count, cols = heights.first?.count ?? 0
    let dirs = [1, 0, -1, 0, 1]
    func flood(_ seeds: [Int]) -> [Bool] { // walk uphill from the ocean
        var seen = [Bool](repeating: false, count: rows * cols)
        var queue: [Int] = []
        for s in seeds where !seen[s] { seen[s] = true; queue.append(s) }
        var head = 0
        while head < queue.count {
            let cell = queue[head]; head += 1
            let r = cell / cols, c = cell % cols
            for d in 0..<4 {
                let nr = r + dirs[d], nc = c + dirs[d + 1]
                if nr < 0 || nr >= rows || nc < 0 || nc >= cols { continue }
                let next = nr * cols + nc
                if !seen[next] && heights[nr][nc] >= heights[r][c] {
                    seen[next] = true
                    queue.append(next)
                }
            }
        }
        return seen
    }
    let pacific = flood(Array(0..<cols) + (0..<rows).map { $0 * cols })
    let atlantic = flood((0..<cols).map { (rows - 1) * cols + $0 } + (0..<rows).map { $0 * cols + cols - 1 })
    return (0..<(rows * cols)).filter { pacific[$0] && atlantic[$0] }.map { [$0 / cols, $0 % cols] }
}
```

### Dart

```dart
List<List<int>> pacificAtlantic(List<List<int>> heights) {
  final rows = heights.length, cols = heights[0].length;
  const dirs = [1, 0, -1, 0, 1];
  List<bool> flood(List<int> seeds) { // walk uphill from the ocean
    final seen = List<bool>.filled(rows * cols, false);
    final queue = <int>[];
    for (final s in seeds) {
      if (!seen[s]) { seen[s] = true; queue.add(s); }
    }
    for (var head = 0; head < queue.length; head++) {
      final cell = queue[head];
      final r = cell ~/ cols, c = cell % cols;
      for (var d = 0; d < 4; d++) {
        final nr = r + dirs[d], nc = c + dirs[d + 1];
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
        final next = nr * cols + nc;
        if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
          seen[next] = true;
          queue.add(next);
        }
      }
    }
    return seen;
  }
  final pacific = flood([for (var c = 0; c < cols; c++) c, for (var r = 0; r < rows; r++) r * cols]);
  final atlantic = flood([
    for (var c = 0; c < cols; c++) (rows - 1) * cols + c,
    for (var r = 0; r < rows; r++) r * cols + cols - 1,
  ]);
  return [
    for (var i = 0; i < rows * cols; i++)
      if (pacific[i] && atlantic[i]) [i ~/ cols, i % cols],
  ];
}
```

### TypeScript

```typescript
function pacificAtlantic(heights: number[][]): number[][] {
  const rows = heights.length, cols = heights[0].length;
  const dirs = [1, 0, -1, 0, 1];
  const flood = (seeds: number[]): boolean[] => { // walk uphill from the ocean
    const seen = new Array<boolean>(rows * cols).fill(false);
    const queue: number[] = [];
    for (const s of seeds) if (!seen[s]) { seen[s] = true; queue.push(s); }
    for (let head = 0; head < queue.length; head++) {
      const cell = queue[head];
      const r = Math.floor(cell / cols), c = cell % cols;
      for (let d = 0; d < 4; d++) {
        const nr = r + dirs[d], nc = c + dirs[d + 1];
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
        const next = nr * cols + nc;
        if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
          seen[next] = true;
          queue.push(next);
        }
      }
    }
    return seen;
  };
  const pacSeeds: number[] = [], atlSeeds: number[] = [];
  for (let c = 0; c < cols; c++) { pacSeeds.push(c); atlSeeds.push((rows - 1) * cols + c); }
  for (let r = 0; r < rows; r++) { pacSeeds.push(r * cols); atlSeeds.push(r * cols + cols - 1); }
  const pacific = flood(pacSeeds), atlantic = flood(atlSeeds);
  const out: number[][] = [];
  for (let i = 0; i < rows * cols; i++) if (pacific[i] && atlantic[i]) out.push([Math.floor(i / cols), i % cols]);
  return out;
}
```

**Mobile note:** This multi-source reverse search is a useful trick in its own right: whenever you are asked "which cells can reach X?", start from X once instead of starting from every cell.

---

## Q4. Surrounded Regions (Paint Bucket Capture)

**Topic:** Border flood fill

**Plan day:** Day 10

**Statement**

A drawing canvas is a grid of `X` and `O`. Every group of `O` cells that does not touch the border is fully enclosed, so recolour it to `X`, modifying the grid in place. Example: `XXXX/XOOX/XXOX/XOXX` → `XXXX/XXXX/XXXX/XOXX`.

**Approach**

Brute force: flood each `O` region and check whether it touches the border, O(R·C) but with two passes per region and extra bookkeeping.

Invert the question. Flood from every border `O` and mark those cells `S` (safe). Every `O` left afterwards is enclosed, so in one final pass turn `O` into `X` and `S` back into `O`.

**Complexity:** Time O(R·C), Space O(R·C) worst-case stack

### Kotlin

```kotlin
fun solve(board: Array<CharArray>) {
    val rows = board.size
    val cols = board[0].size
    val stack = ArrayDeque<Int>()
    fun mark(r: Int, c: Int) {
        if (r !in 0 until rows || c !in 0 until cols || board[r][c] != 'O') return
        board[r][c] = 'S' // safe: connected to the border
        stack.addLast(r * cols + c)
    }
    for (r in 0 until rows) { mark(r, 0); mark(r, cols - 1) }
    for (c in 0 until cols) { mark(0, c); mark(rows - 1, c) }
    while (stack.isNotEmpty()) {
        val cell = stack.removeLast()
        val r = cell / cols
        val c = cell % cols
        mark(r + 1, c); mark(r - 1, c); mark(r, c + 1); mark(r, c - 1)
    }
    for (r in 0 until rows) for (c in 0 until cols) {
        board[r][c] = when (board[r][c]) {
            'S' -> 'O'
            'O' -> 'X' // enclosed
            else -> board[r][c]
        }
    }
}
```

### Swift

```swift
func solve(_ board: inout [[Character]]) {
    let rows = board.count, cols = board.first?.count ?? 0
    var stack: [Int] = []
    func mark(_ r: Int, _ c: Int) {
        if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != "O" { return }
        board[r][c] = "S" // safe: connected to the border
        stack.append(r * cols + c)
    }
    for r in 0..<rows { mark(r, 0); mark(r, cols - 1) }
    for c in 0..<cols { mark(0, c); mark(rows - 1, c) }
    while let cell = stack.popLast() {
        let r = cell / cols, c = cell % cols
        mark(r + 1, c); mark(r - 1, c); mark(r, c + 1); mark(r, c - 1)
    }
    for r in 0..<rows {
        for c in 0..<cols {
            if board[r][c] == "S" { board[r][c] = "O" }
            else if board[r][c] == "O" { board[r][c] = "X" } // enclosed
        }
    }
}
```

### Dart

```dart
void solve(List<List<String>> board) {
  final rows = board.length, cols = board[0].length;
  final stack = <int>[];
  void mark(int r, int c) {
    if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O') return;
    board[r][c] = 'S'; // safe: connected to the border
    stack.add(r * cols + c);
  }

  for (var r = 0; r < rows; r++) {
    mark(r, 0);
    mark(r, cols - 1);
  }
  for (var c = 0; c < cols; c++) {
    mark(0, c);
    mark(rows - 1, c);
  }
  while (stack.isNotEmpty) {
    final cell = stack.removeLast();
    final r = cell ~/ cols, c = cell % cols;
    mark(r + 1, c);
    mark(r - 1, c);
    mark(r, c + 1);
    mark(r, c - 1);
  }
  for (final row in board) {
    for (var c = 0; c < cols; c++) {
      row[c] = row[c] == 'S' ? 'O' : (row[c] == 'O' ? 'X' : row[c]); // leftover 'O' is enclosed
    }
  }
}
```

### TypeScript

```typescript
function solve(board: string[][]): void {
  const rows = board.length, cols = board[0].length;
  const stack: number[] = [];
  const mark = (r: number, c: number): void => {
    if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] !== "O") return;
    board[r][c] = "S"; // safe: connected to the border
    stack.push(r * cols + c);
  };
  for (let r = 0; r < rows; r++) { mark(r, 0); mark(r, cols - 1); }
  for (let c = 0; c < cols; c++) { mark(0, c); mark(rows - 1, c); }
  while (stack.length > 0) {
    const cell = stack.pop()!;
    const r = Math.floor(cell / cols), c = cell % cols;
    mark(r + 1, c); mark(r - 1, c); mark(r, c + 1); mark(r, c - 1);
  }
  for (const row of board) {
    for (let c = 0; c < cols; c++) row[c] = row[c] === "S" ? "O" : row[c] === "O" ? "X" : row[c];
  }
}
```

**Mobile note:** A paint-bucket tool on a large bitmap should run this on a background thread. On Android, post the finished `Bitmap` to an `ImageView`, or in Compose swap the `ImageBitmap` held in state, so the canvas never shows a half-filled frame.

---

## Q5. Graph Valid Tree (Folder Hierarchy Sanity Check)

**Topic:** Union-Find

**Plan day:** Day 11

**Statement**

A sync payload describes `n` folders (`0..n-1`) and undirected parent–child links `edges`. Return whether the links form exactly one tree: connected and without cycles. Example: `n = 5`, `[[0,1],[0,2],[0,3],[1,4]]` → `true`.

**Approach**

Brute force: build an adjacency list, run a DFS for cycle detection, then check that every node was reached, O(n + e) but with more code.

A tree has exactly **n − 1 edges**, so reject any other count straight away. Then **union-find** the edges (union by size + path halving): if both endpoints already share a root, that edge closes a cycle. With n − 1 edges and no cycle, the graph must be connected.

**Complexity:** Time O(n · α(n)), Space O(n)

### Kotlin

```kotlin
fun validTree(n: Int, edges: Array<IntArray>): Boolean {
    if (edges.size != n - 1) return false
    val parent = IntArray(n) { it }
    val size = IntArray(n) { 1 }
    fun find(x: Int): Int {
        var r = x
        while (parent[r] != r) {
            parent[r] = parent[parent[r]] // path halving
            r = parent[r]
        }
        return r
    }
    for ((a, b) in edges) {
        val ra = find(a)
        val rb = find(b)
        if (ra == rb) return false // edge closes a cycle
        if (size[ra] < size[rb]) { // union by size: hang the smaller tree
            parent[ra] = rb
            size[rb] += size[ra]
        } else {
            parent[rb] = ra
            size[ra] += size[rb]
        }
    }
    return true
}
```

### Swift

```swift
func validTree(_ n: Int, _ edges: [[Int]]) -> Bool {
    if edges.count != n - 1 { return false }
    var parent = Array(0..<n)
    var size = [Int](repeating: 1, count: n)
    func find(_ x: Int) -> Int {
        var r = x
        while parent[r] != r {
            parent[r] = parent[parent[r]] // path halving
            r = parent[r]
        }
        return r
    }
    for e in edges {
        let ra = find(e[0]), rb = find(e[1])
        if ra == rb { return false } // edge closes a cycle
        if size[ra] < size[rb] { // union by size: hang the smaller tree
            parent[ra] = rb
            size[rb] += size[ra]
        } else {
            parent[rb] = ra
            size[ra] += size[rb]
        }
    }
    return true
}
```

### Dart

```dart
bool validTree(int n, List<List<int>> edges) {
  if (edges.length != n - 1) return false;
  final parent = List<int>.generate(n, (i) => i);
  final size = List<int>.filled(n, 1);
  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]]; // path halving
      x = parent[x];
    }
    return x;
  }

  for (final e in edges) {
    final ra = find(e[0]), rb = find(e[1]);
    if (ra == rb) return false; // edge closes a cycle
    if (size[ra] < size[rb]) { // union by size: hang the smaller tree
      parent[ra] = rb;
      size[rb] += size[ra];
    } else {
      parent[rb] = ra;
      size[ra] += size[rb];
    }
  }
  return true;
}
```

### TypeScript

```typescript
function validTree(n: number, edges: number[][]): boolean {
  if (edges.length !== n - 1) return false;
  const parent = Array.from({ length: n }, (_, i) => i);
  const size = new Array<number>(n).fill(1);
  const find = (x: number): number => {
    while (parent[x] !== x) {
      parent[x] = parent[parent[x]]; // path halving
      x = parent[x];
    }
    return x;
  };
  for (const [a, b] of edges) {
    const ra = find(a), rb = find(b);
    if (ra === rb) return false; // edge closes a cycle
    if (size[ra] < size[rb]) { // union by size: hang the smaller tree
      parent[ra] = rb;
      size[rb] += size[ra];
    } else {
      parent[rb] = ra;
      size[ra] += size[rb];
    }
  }
  return true;
}
```

**Mobile note:** Validate server-sent hierarchies (folders, comment threads, org charts) before rendering an expandable tree. A cycle there turns into an infinite recursion in the tree adapter.

---

## Q6. Min Cost Climbing Stairs (Cheapest Onboarding Path)

**Topic:** 1-D DP

**Plan day:** Day 11

**Statement**

`cost[i]` is the friction of onboarding step `i`. From a step you may advance 1 or 2 steps, and you may start at step 0 or step 1. Return the minimum total cost to go past the last step. Example: `[10,15,20]` → `15`.

**Approach**

Brute force: recurse over both choices from both starts, O(2^n).

**State:** `dp[i]` = minimum cost to stand on step `i` (`i = n` is the top). `dp[0] = dp[1] = 0`.
**Transition:** `dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2])`. Keep only the last two values.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun minCostClimbingStairs(cost: IntArray): Int {
    var twoBack = 0 // dp[i-2]
    var oneBack = 0 // dp[i-1]
    for (i in 2..cost.size) {
        val cur = minOf(oneBack + cost[i - 1], twoBack + cost[i - 2])
        twoBack = oneBack
        oneBack = cur
    }
    return oneBack
}
```

### Swift

```swift
func minCostClimbingStairs(_ cost: [Int]) -> Int {
    var twoBack = 0, oneBack = 0 // dp[i-2], dp[i-1]
    for i in stride(from: 2, through: cost.count, by: 1) {
        let cur = min(oneBack + cost[i - 1], twoBack + cost[i - 2])
        twoBack = oneBack
        oneBack = cur
    }
    return oneBack
}
```

### Dart

```dart
int minCostClimbingStairs(List<int> cost) {
  var twoBack = 0, oneBack = 0; // dp[i-2], dp[i-1]
  for (var i = 2; i <= cost.length; i++) {
    final cur = min(oneBack + cost[i - 1], twoBack + cost[i - 2]);
    twoBack = oneBack;
    oneBack = cur;
  }
  return oneBack;
}
```

### TypeScript

```typescript
function minCostClimbingStairs(cost: number[]): number {
  let twoBack = 0, oneBack = 0; // dp[i-2], dp[i-1]
  for (let i = 2; i <= cost.length; i++) {
    const cur = Math.min(oneBack + cost[i - 1], twoBack + cost[i - 2]);
    twoBack = oneBack;
    oneBack = cur;
  }
  return oneBack;
}
```

---

## Q7. House Robber II (Circular Carousel Ad Slots)

**Topic:** 1-D DP (two passes)

**Plan day:** Day 11

**Statement**

Ad slots sit in a circular carousel with revenue `nums[i]`. Two adjacent slots cannot both carry ads, and the first and last slots are adjacent. Return the maximum revenue. Example: `[2,3,2]` → `3`.

**Approach**

Brute force: try every non-adjacent subset, O(2^n).

The first and last slots cannot both be taken, so solve the **linear** problem twice: once on `0..n-2` and once on `1..n-1`. Return the larger result (a single slot is a special case).
**State:** `best(i)` = maximum revenue using slots up to `i`.
**Transition:** `best(i) = max(best(i-1), best(i-2) + nums[i])`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun rob(nums: IntArray): Int {
    if (nums.size == 1) return nums[0]
    fun robLine(from: Int, to: Int): Int {
        var prev = 0 // best up to i-2
        var best = 0 // best up to i-1
        for (i in from..to) {
            val take = prev + nums[i]
            prev = best
            best = maxOf(best, take)
        }
        return best
    }
    return maxOf(robLine(0, nums.size - 2), robLine(1, nums.size - 1))
}
```

### Swift

```swift
func rob(_ nums: [Int]) -> Int {
    if nums.count == 1 { return nums[0] }
    func robLine(_ from: Int, _ to: Int) -> Int {
        var prev = 0, best = 0 // best up to i-2, best up to i-1
        for i in stride(from: from, through: to, by: 1) {
            let take = prev + nums[i]
            prev = best
            best = max(best, take)
        }
        return best
    }
    return max(robLine(0, nums.count - 2), robLine(1, nums.count - 1))
}
```

### Dart

```dart
int rob(List<int> nums) {
  if (nums.length == 1) return nums[0];
  int robLine(int from, int to) {
    var prev = 0, best = 0; // best up to i-2, best up to i-1
    for (var i = from; i <= to; i++) {
      final take = prev + nums[i];
      prev = best;
      best = max(best, take);
    }
    return best;
  }

  return max(robLine(0, nums.length - 2), robLine(1, nums.length - 1));
}
```

### TypeScript

```typescript
function rob(nums: number[]): number {
  if (nums.length === 1) return nums[0];
  const robLine = (from: number, to: number): number => {
    let prev = 0, best = 0; // best up to i-2, best up to i-1
    for (let i = from; i <= to; i++) {
      const take = prev + nums[i];
      prev = best;
      best = Math.max(best, take);
    }
    return best;
  };
  return Math.max(robLine(0, nums.length - 2), robLine(1, nums.length - 1));
}
```

---

## Q8. Decode Ways (Ambiguous Numeric Codes)

**Topic:** 1-D DP

**Plan day:** Day 11

**Statement**

A message was encoded with `A→1 … Z→26` and the digits were concatenated. Given a non-empty digit string, return how many ways it can be decoded. Example: `226` → `3` (`BZ`, `VF`, `BBF`), `06` → `0`.

**Approach**

Brute force: recursive split into 1- or 2-digit pieces, O(2^n).

**State:** `dp[i]` = number of decodings of the first `i` digits, with `dp[0] = 1`.
**Transition:** `dp[i] = (s[i-1] != '0' ? dp[i-1] : 0) + (10 <= s[i-2..i-1] <= 26 ? dp[i-2] : 0)`. Keep only the last two values.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun numDecodings(s: String): Int {
    var prev2 = 1                          // dp[i-2]
    var prev1 = if (s[0] == '0') 0 else 1  // dp[i-1]
    for (i in 2..s.length) {
        var cur = 0
        if (s[i - 1] != '0') cur += prev1
        val two = (s[i - 2] - '0') * 10 + (s[i - 1] - '0')
        if (two in 10..26) cur += prev2
        prev2 = prev1
        prev1 = cur
    }
    return prev1
}
```

### Swift

```swift
func numDecodings(_ s: String) -> Int {
    let d = s.compactMap { $0.wholeNumberValue }
    guard d.count == s.count, let first = d.first else { return 0 } // digits only
    var prev2 = 1                   // dp[i-2]
    var prev1 = first == 0 ? 0 : 1  // dp[i-1]
    for i in stride(from: 2, through: d.count, by: 1) {
        var cur = 0
        if d[i - 1] != 0 { cur += prev1 }
        let two = d[i - 2] * 10 + d[i - 1]
        if two >= 10 && two <= 26 { cur += prev2 }
        prev2 = prev1
        prev1 = cur
    }
    return prev1
}
```

### Dart

```dart
int numDecodings(String s) {
  var prev2 = 1; // dp[i-2]
  var prev1 = s[0] == '0' ? 0 : 1; // dp[i-1]
  for (var i = 2; i <= s.length; i++) {
    var cur = 0;
    if (s[i - 1] != '0') cur += prev1;
    final two = int.parse(s.substring(i - 2, i));
    if (two >= 10 && two <= 26) cur += prev2;
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}
```

### TypeScript

```typescript
function numDecodings(s: string): number {
  let prev2 = 1;                      // dp[i-2]
  let prev1 = s[0] === "0" ? 0 : 1;   // dp[i-1]
  for (let i = 2; i <= s.length; i++) {
    let cur = 0;
    if (s[i - 1] !== "0") cur += prev1;
    const two = Number(s.slice(i - 2, i));
    if (two >= 10 && two <= 26) cur += prev2;
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}
```

---

## Q9. Longest Increasing Subsequence (Longest Rising Streak)

**Topic:** DP + binary search (patience)

**Plan day:** Day 12

**Statement**

Given daily step counts, return the length of the longest strictly increasing subsequence (the days do not need to be adjacent). Example: `[10,9,2,5,3,7,101,18]` → `4` (`2,3,7,18`).

**Approach**

Brute force: O(n²) DP where `dp[i] = 1 + max(dp[j])` over `j < i` with `a[j] < a[i]`.

**Patience sorting:** `tails[k]` holds the smallest possible tail of an increasing run of length `k+1`, and it stays sorted. For each `x`, binary-search the first tail `>= x` and replace it, or append `x` if every tail is smaller. The answer is the number of tails.

**Complexity:** Time O(n log n), Space O(n)

### Kotlin

```kotlin
fun lengthOfLIS(nums: IntArray): Int {
    val tails = IntArray(nums.size) // tails[k] = smallest tail of an increasing run of length k+1
    var size = 0
    for (x in nums) {
        var lo = 0
        var hi = size
        while (lo < hi) {
            val mid = (lo + hi) ushr 1
            if (tails[mid] < x) lo = mid + 1 else hi = mid
        }
        tails[lo] = x
        if (lo == size) size++
    }
    return size
}
```

### Swift

```swift
func lengthOfLIS(_ nums: [Int]) -> Int {
    var tails: [Int] = [] // tails[k] = smallest tail of an increasing run of length k+1
    for x in nums {
        var lo = 0, hi = tails.count
        while lo < hi {
            let mid = (lo + hi) / 2
            if tails[mid] < x { lo = mid + 1 } else { hi = mid }
        }
        if lo == tails.count { tails.append(x) } else { tails[lo] = x }
    }
    return tails.count
}
```

### Dart

```dart
int lengthOfLIS(List<int> nums) {
  final tails = <int>[]; // tails[k] = smallest tail of an increasing run of length k+1
  for (final x in nums) {
    var lo = 0, hi = tails.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (tails[mid] < x) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    if (lo == tails.length) {
      tails.add(x);
    } else {
      tails[lo] = x;
    }
  }
  return tails.length;
}
```

### TypeScript

```typescript
function lengthOfLIS(nums: number[]): number {
  const tails: number[] = []; // tails[k] = smallest tail of an increasing run of length k+1
  for (const x of nums) {
    let lo = 0, hi = tails.length;
    while (lo < hi) {
      const mid = (lo + hi) >> 1;
      if (tails[mid] < x) lo = mid + 1;
      else hi = mid;
    }
    tails[lo] = x; // extends when lo === tails.length
  }
  return tails.length;
}
```

**Mobile note:** `tails` is not itself an LIS. If the UI must highlight the actual days, also store a predecessor index for each element and walk back from the end.

---

## Q10. Combination Sum IV (Ordered Top-Up Sequences)

**Topic:** 1-D DP (order matters)

**Plan day:** Day 12

**Statement**

A wallet accepts top-ups in distinct positive amounts `nums`. Count the **ordered** sequences of top-ups that add up to exactly `target`, so `1+2` and `2+1` are different. Assume the final count fits in a signed 64-bit integer: Kotlin uses `Long`, Swift and Dart use their 64-bit `Int`/`int`, and TypeScript uses `bigint` because `number` loses precision past 2^53. Example: `[1,2,3]`, target `4` → `7`.

**Approach**

Brute force: recursion over the next top-up, exponential.

**State:** `ways[t]` = number of ordered sequences summing to `t`, with `ways[0] = 1`.
**Transition:** `ways[t] = Σ ways[t - x]` over `x ∈ nums` with `x <= t`, where `x` is the *last* step. Put the amount loop on the **outside** so that every ordering is counted (contrast with Q13). Intermediate counts that never feed the target can overflow 64 bits, so Kotlin and Dart wrap silently and Swift uses `&+=` instead of trapping. Wrapping is safe here: the arithmetic is only additions, so the result is exact modulo 2^64, and the final count fits.

**Complexity:** Time O(target · |nums|), Space O(target)

### Kotlin

```kotlin
fun combinationSum4(nums: IntArray, target: Int): Long {
    val ways = LongArray(target + 1)
    ways[0] = 1
    for (t in 1..target) {
        for (x in nums) if (x <= t) ways[t] += ways[t - x] // x is the last step
    }
    return ways[target]
}
```

### Swift

```swift
func combinationSum4(_ nums: [Int], _ target: Int) -> Int {
    var ways = [Int](repeating: 0, count: target + 1)
    ways[0] = 1
    for t in stride(from: 1, through: target, by: 1) {
        for x in nums where x <= t { ways[t] &+= ways[t - x] } // x is the last step; &+= wraps, never traps
    }
    return ways[target]
}
```

### Dart

```dart
int combinationSum4(List<int> nums, int target) {
  final ways = List<int>.filled(target + 1, 0);
  ways[0] = 1;
  for (var t = 1; t <= target; t++) {
    for (final x in nums) {
      if (x <= t) ways[t] += ways[t - x]; // x is the last step
    }
  }
  return ways[target];
}
```

### TypeScript

```typescript
function combinationSum4(nums: number[], target: number): bigint {
  const ways = new Array<bigint>(target + 1).fill(0n); // bigint: counts pass 2^53 fast
  ways[0] = 1n;
  for (let t = 1; t <= target; t++) {
    for (const x of nums) if (x <= t) ways[t] += ways[t - x]; // x is the last step
  }
  return ways[target];
}
```

---

## Q11. Longest Common Subsequence (Diffing Two Lists)

**Topic:** 2-D DP (rolled to 1-D)

**Plan day:** Day 12

**Statement**

Return the length of the longest subsequence common to strings `a` and `b`. Example: `abcde`, `ace` → `3`.

**Approach**

Brute force: enumerate subsequences of one string, O(2^n · m).

**State:** `dp[i][j]` = LCS length of `a[0..i)` and `b[0..j)`.
**Transition:** if `a[i-1] == b[j-1]`, then `dp[i][j] = dp[i-1][j-1] + 1`; otherwise `max(dp[i-1][j], dp[i][j-1])`. Keep one row, carrying `diag` for `dp[i-1][j-1]`.

**Complexity:** Time O(n·m), Space O(m)

### Kotlin

```kotlin
fun longestCommonSubsequence(a: String, b: String): Int {
    val dp = IntArray(b.length + 1) // row i-1, overwritten into row i
    for (i in 1..a.length) {
        var diag = 0 // dp[i-1][j-1]
        for (j in 1..b.length) {
            val up = dp[j] // dp[i-1][j]
            dp[j] = if (a[i - 1] == b[j - 1]) diag + 1 else maxOf(up, dp[j - 1])
            diag = up
        }
    }
    return dp[b.length]
}
```

### Swift

```swift
func longestCommonSubsequence(_ a: String, _ b: String) -> Int {
    let a = Array(a), b = Array(b)
    var dp = [Int](repeating: 0, count: b.count + 1) // row i-1, overwritten into row i
    for i in stride(from: 1, through: a.count, by: 1) {
        var diag = 0 // dp[i-1][j-1]
        for j in stride(from: 1, through: b.count, by: 1) {
            let up = dp[j] // dp[i-1][j]
            dp[j] = a[i - 1] == b[j - 1] ? diag + 1 : max(up, dp[j - 1])
            diag = up
        }
    }
    return dp[b.count]
}
```

### Dart

```dart
int longestCommonSubsequence(String a, String b) {
  final dp = List<int>.filled(b.length + 1, 0); // row i-1, overwritten into row i
  for (var i = 1; i <= a.length; i++) {
    var diag = 0; // dp[i-1][j-1]
    for (var j = 1; j <= b.length; j++) {
      final up = dp[j]; // dp[i-1][j]
      dp[j] = a[i - 1] == b[j - 1] ? diag + 1 : max(up, dp[j - 1]);
      diag = up;
    }
  }
  return dp[b.length];
}
```

### TypeScript

```typescript
function longestCommonSubsequence(a: string, b: string): number {
  const dp = new Array<number>(b.length + 1).fill(0); // row i-1, overwritten into row i
  for (let i = 1; i <= a.length; i++) {
    let diag = 0; // dp[i-1][j-1]
    for (let j = 1; j <= b.length; j++) {
      const up = dp[j]; // dp[i-1][j]
      dp[j] = a[i - 1] === b[j - 1] ? diag + 1 : Math.max(up, dp[j - 1]);
      diag = up;
    }
  }
  return dp[b.length];
}
```

**Mobile note:** List diffing is built on the same idea. `DiffUtil` (RecyclerView / `ListAdapter`) uses Myers' algorithm, which finds a shortest edit script, the dual of an LCS. Compose's `LazyColumn` instead relies on stable `key`s to match items. Either way, the work belongs off the main thread for long lists.

---

## Q12. Best Time to Buy and Sell Stock with Cooldown (Price Chart Cooldown Rule)

**Topic:** State-machine DP

**Plan day:** Day 12

**Statement**

Given a daily price series, return the maximum profit from any number of buy/sell pairs, holding at most one unit at a time. After a sell you must skip the next day before buying again. Example: `[1,2,3,0,2]` → `3` (buy, sell, cooldown, buy, sell). This is a pure algorithm exercise, not trading guidance.

**Approach**

Brute force: recursion over buy/sell/skip choices, O(2^n).

**States** at the end of each day: `hold` (own one unit), `sold` (sold today), `rest` (no unit, free to buy).
**Transitions:** `hold = max(hold, rest - p)`, `sold = hold_prev + p`, `rest = max(rest, sold_prev)`. The answer is `max(sold, rest)`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun maxProfit(prices: IntArray): Int {
    var hold = Int.MIN_VALUE / 2 // own a share
    var sold = 0                 // sold today (cooldown tomorrow)
    var rest = 0                 // no share, free to buy
    for (p in prices) {
        val prevHold = hold
        hold = maxOf(hold, rest - p)
        rest = maxOf(rest, sold)
        sold = prevHold + p
    }
    return maxOf(sold, rest)
}
```

### Swift

```swift
func maxProfit(_ prices: [Int]) -> Int {
    var hold = Int.min / 2 // own a share
    var sold = 0           // sold today (cooldown tomorrow)
    var rest = 0           // no share, free to buy
    for p in prices {
        let prevHold = hold
        hold = max(hold, rest - p)
        rest = max(rest, sold)
        sold = prevHold + p
    }
    return max(sold, rest)
}
```

### Dart

```dart
int maxProfit(List<int> prices) {
  var hold = -(1 << 40); // own a share (effectively minus infinity)
  var sold = 0; // sold today (cooldown tomorrow)
  var rest = 0; // no share, free to buy
  for (final p in prices) {
    final prevHold = hold;
    hold = max(hold, rest - p);
    rest = max(rest, sold);
    sold = prevHold + p;
  }
  return max(sold, rest);
}
```

### TypeScript

```typescript
function maxProfit(prices: number[]): number {
  let hold = -Infinity; // own a share
  let sold = 0;         // sold today (cooldown tomorrow)
  let rest = 0;         // no share, free to buy
  for (const p of prices) {
    const prevHold = hold;
    hold = Math.max(hold, rest - p);
    rest = Math.max(rest, sold);
    sold = prevHold + p;
  }
  return Math.max(sold, rest);
}
```

---

## Q13. Coin Change II (Ways to Make Change at the Till)

**Topic:** 1-D DP (unbounded knapsack)

**Plan day:** Day 12

**Statement**

A point-of-sale app has unlimited coins of each denomination in `coins`. Count the **combinations** (order ignored) that make `amount`. Example: `amount = 5`, `[1,2,5]` → `4`.

**Approach**

Brute force: recursion over how many of each coin to use, exponential.

**State:** `ways[a]` = number of combinations making `a` from the coins processed so far, with `ways[0] = 1`.
**Transition:** for each coin, in an **outer** loop, update `a` upward from `coin` to `amount` with `ways[a] += ways[a - coin]`. Because the coins are added one at a time, each multiset is counted once. As in Q10, unused intermediate counts can overflow, so Swift uses `&+=`.

**Complexity:** Time O(amount · |coins|), Space O(amount)

### Kotlin

```kotlin
fun change(amount: Int, coins: IntArray): Int {
    val ways = IntArray(amount + 1)
    ways[0] = 1
    for (coin in coins) { // coins outer => combinations, not orderings
        for (a in coin..amount) ways[a] += ways[a - coin] // Int wraps silently on unused intermediates
    }
    return ways[amount]
}
```

### Swift

```swift
func change(_ amount: Int, _ coins: [Int]) -> Int {
    var ways = [Int](repeating: 0, count: amount + 1)
    ways[0] = 1
    for coin in coins where coin <= amount { // coins outer => combinations, not orderings
        for a in coin...amount { ways[a] &+= ways[a - coin] } // &+= wraps: unused intermediates may overflow
    }
    return ways[amount]
}
```

### Dart

```dart
int change(int amount, List<int> coins) {
  final ways = List<int>.filled(amount + 1, 0);
  ways[0] = 1;
  for (final coin in coins) { // coins outer => combinations, not orderings
    for (var a = coin; a <= amount; a++) {
      ways[a] += ways[a - coin];
    }
  }
  return ways[amount];
}
```

### TypeScript

```typescript
function change(amount: number, coins: number[]): number {
  const ways = new Array<number>(amount + 1).fill(0);
  ways[0] = 1;
  for (const coin of coins) { // coins outer => combinations, not orderings
    for (let a = coin; a <= amount; a++) ways[a] += ways[a - coin];
  }
  return ways[amount];
}
```

**Mobile note:** Real money should be held in minor units (paise or cents) as integers, never `Double`. See [Ch 26](../part-viii/26-money-idempotency-reliability.md).

---

## Q14. Target Sum (Signed Ledger Adjustments)

**Topic:** 0/1 knapsack (subset count)

**Plan day:** Day 12

**Statement**

Put a `+` or `-` in front of each non-negative amount in `nums` and count the sign assignments whose total equals `target`. Example: `[1,1,1,1,1]`, target `3` → `5`.

**Approach**

Brute force: try all 2^n sign choices.

Let `P` be the plus group: `P - (total - P) = target`, so `P = (total + target) / 2`. If that is negative or not an integer, the answer is 0. Otherwise count the subsets that sum to `P`.
**State:** `ways[s]` = number of subsets of the items seen so far that sum to `s`.
**Transition:** for each `x`, `ways[s] += ways[s - x]` with `s` going **downward**, so each item is used at most once. Zeros double the count automatically.

**Complexity:** Time O(n · P), Space O(P)

### Kotlin

```kotlin
import kotlin.math.abs

fun findTargetSumWays(nums: IntArray, target: Int): Int {
    val total = nums.sum()
    if (abs(target) > total || (total + target) % 2 != 0) return 0
    val want = (total + target) / 2 // sum of the '+' group
    val ways = IntArray(want + 1)
    ways[0] = 1
    for (x in nums) {
        for (s in want downTo x) ways[s] += ways[s - x] // 0/1 knapsack, backwards
    }
    return ways[want]
}
```

### Swift

```swift
func findTargetSumWays(_ nums: [Int], _ target: Int) -> Int {
    let total = nums.reduce(0, +)
    if abs(target) > total || (total + target) % 2 != 0 { return 0 }
    let want = (total + target) / 2 // sum of the '+' group
    var ways = [Int](repeating: 0, count: want + 1)
    ways[0] = 1
    for x in nums {
        var s = want
        while s >= x { ways[s] += ways[s - x]; s -= 1 } // 0/1 knapsack, backwards
    }
    return ways[want]
}
```

### Dart

```dart
int findTargetSumWays(List<int> nums, int target) {
  final total = nums.fold(0, (a, b) => a + b);
  if (target.abs() > total || (total + target) % 2 != 0) return 0;
  final want = (total + target) ~/ 2; // sum of the '+' group
  final ways = List<int>.filled(want + 1, 0);
  ways[0] = 1;
  for (final x in nums) {
    for (var s = want; s >= x; s--) {
      ways[s] += ways[s - x]; // 0/1 knapsack, backwards
    }
  }
  return ways[want];
}
```

### TypeScript

```typescript
function findTargetSumWays(nums: number[], target: number): number {
  const total = nums.reduce((a, b) => a + b, 0);
  if (Math.abs(target) > total || (total + target) % 2 !== 0) return 0;
  const want = (total + target) / 2; // sum of the '+' group
  const ways = new Array<number>(want + 1).fill(0);
  ways[0] = 1;
  for (const x of nums) {
    for (let s = want; s >= x; s--) ways[s] += ways[s - x]; // 0/1 knapsack, backwards
  }
  return ways[want];
}
```

---

## Drill checklist (say aloud)

1. Name the plan day's pattern before coding (heap bound, trie walk, greedy invariant, BFS layer, DP state).  
2. Complexity **before** code.  
3. For DP: state, transition, base case, iteration order — in that order.  
4. One mobile sentence: main thread, memory bound, or recursion depth.  
5. Edges: empty input, single element, all-equal values, unreachable target.

Previous: [Chapter 36 — Heaps, Tries & Greedy](36-heaps-tries-greedy.md) · Index: [`solutions/ch37`](../../solutions/ch37/README.md) · Plan map: [Appendix G — 12-Day DSA Plan Map](../appendices/G-12-day-dsa-plan-map.md).
