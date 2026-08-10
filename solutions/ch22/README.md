# Chapter 22 — Model Solutions

Model solutions for Chapter 22 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-vi/22-bits-matrix.md`](../../book/part-vi/22-bits-matrix.md).

---

## P1: Single number

### Approach

XOR every element. Pairs cancel (`x ^ x = 0`); identity `x ^ 0 = x` leaves the unique value. Works because XOR is associative and commutative.

### Complexity

- Time: O(n)
- Space: O(1)

### Edge cases

- Single-element array
- Negatives (two’s complement XOR still works for equal pairs)
- Zero as the singleton or as a duplicated value

### Mobile note

Teaching/interview pattern. Real “find unique ID in a stream” on device still favors hashing if appearances are not exactly twice — XOR assumes the classic constraint.

### Kotlin

```kotlin
fun singleNumber(nums: IntArray): Int =
    nums.fold(0) { acc, x -> acc xor x }
```

### Swift

```swift
func singleNumber(_ nums: [Int]) -> Int {
    nums.reduce(0, ^)
}
```

### Dart

```dart
int singleNumber(List<int> nums) {
  var x = 0;
  for (final n in nums) {
    x ^= n;
  }
  return x;
}
```

### TypeScript

```typescript
function singleNumber(nums: number[]): number {
  return nums.reduce((a, x) => a ^ x, 0);
}
```

---

## P2: Number of islands

### Approach

Scan each cell. When you find land `'1'`, increment the island count and **DFS (or BFS) flood** the connected 4-direction component, marking visited by setting cells to `'0'` (or a visited matrix). Continue scan.

### Complexity

- Time: O(R · C) — each cell visited constantly often
- Space: O(R · C) worst-case recursion/queue depth

### Edge cases

- Empty grid
- All water / all land (one island if 4-connected)
- Diagonal-only touches — **not** the same island under 4-neighbor rules
- Single cell island

### Mobile note

Map tile / game board / heat-map region counting. Prefer iterative BFS if grids are large (avoid deep recursion on mobile stacks). Mutating the grid in place saves memory; copy first if the caller needs the original.

### Kotlin

```kotlin
fun numIslands(grid: Array<CharArray>): Int {
    if (grid.isEmpty()) return 0
    var count = 0
    fun dfs(r: Int, c: Int) {
        if (r !in grid.indices || c !in grid[0].indices || grid[r][c] != '1') return
        grid[r][c] = '0'
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, c - 1)
    }
    for (r in grid.indices) {
        for (c in grid[0].indices) {
            if (grid[r][c] == '1') {
                count++
                dfs(r, c)
            }
        }
    }
    return count
}
```

### Swift

```swift
func numIslands(_ grid: [[Character]]) -> Int {
    var g = grid
    guard !g.isEmpty else { return 0 }
    let rows = g.count, cols = g[0].count
    var count = 0
    func dfs(_ r: Int, _ c: Int) {
        if r < 0 || c < 0 || r >= rows || c >= cols || g[r][c] != "1" { return }
        g[r][c] = "0"
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    for r in 0..<rows {
        for c in 0..<cols where g[r][c] == "1" {
            count += 1
            dfs(r, c)
        }
    }
    return count
}
```

### Dart

```dart
int numIslands(List<List<String>> grid) {
  if (grid.isEmpty) return 0;
  final rows = grid.length, cols = grid[0].length;
  var count = 0;
  void dfs(int r, int c) {
    if (r < 0 || c < 0 || r >= rows || c >= cols || grid[r][c] != '1') return;
    grid[r][c] = '0';
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (grid[r][c] == '1') {
        count++;
        dfs(r, c);
      }
    }
  }
  return count;
}
```

### TypeScript

```typescript
function numIslands(grid: string[][]): number {
  if (!grid.length) return 0;
  const rows = grid.length, cols = grid[0].length;
  let count = 0;
  const dfs = (r: number, c: number) => {
    if (r < 0 || c < 0 || r >= rows || c >= cols || grid[r][c] !== "1") return;
    grid[r][c] = "0";
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  };
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] === "1") {
        count++;
        dfs(r, c);
      }
    }
  }
  return count;
}
```

---

## P3: Rotate image 90°

### Approach

In-place for `n × n`: (1) **transpose** along the main diagonal; (2) **reverse each row**. That yields 90° clockwise. (Counter-clockwise: transpose then reverse columns, or reverse rows then transpose.)

### Complexity

- Time: O(n²)
- Space: O(1) extra

### Edge cases

- `n == 1` — no-op
- Even vs odd `n` (center cell fixed under 90° for odd n)
- Non-square — this algorithm does not apply; need a new matrix

### Mobile note

Interview version mutates an int matrix. Real camera/avatar rotation should use platform image APIs (orientation flags, GPU transforms) — do not manually rotate megapixel buffers on the UI thread with this nested loop.

### Kotlin

```kotlin
fun rotate(matrix: Array<IntArray>) {
    val n = matrix.size
    for (i in 0 until n) {
        for (j in i until n) {
            val tmp = matrix[i][j]
            matrix[i][j] = matrix[j][i]
            matrix[j][i] = tmp
        }
    }
    for (row in matrix) row.reverse()
}
```

### Swift

```swift
func rotate(_ matrix: inout [[Int]]) {
    let n = matrix.count
    for i in 0..<n {
        for j in i..<n {
            let tmp = matrix[i][j]
            matrix[i][j] = matrix[j][i]
            matrix[j][i] = tmp
        }
    }
    for i in 0..<n {
        matrix[i].reverse()
    }
}
```

### Dart

```dart
void rotate(List<List<int>> matrix) {
  final n = matrix.length;
  for (var i = 0; i < n; i++) {
    for (var j = i; j < n; j++) {
      final tmp = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = tmp;
    }
  }
  for (var i = 0; i < n; i++) {
    final row = matrix[i];
    var L = 0, R = n - 1;
    while (L < R) {
      final tmp = row[L];
      row[L] = row[R];
      row[R] = tmp;
      L++;
      R--;
    }
  }
}
```

### TypeScript

```typescript
function rotate(matrix: number[][]): void {
  const n = matrix.length;
  for (let i = 0; i < n; i++) {
    for (let j = i; j < n; j++) {
      const tmp = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = tmp;
    }
  }
  for (const row of matrix) row.reverse();
}
```
