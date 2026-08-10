# Chapter 22 — Bit Manipulation & Matrix Problems

## Mobile motivation

Bits show up as **permission flags**, **feature toggles packed into an Int**, and interview puzzles (`single number`, `power of two`). Matrices show up as **image buffers**, **game boards**, and **map tiles** — rotate a square avatar preview, flood-fill a paint bucket, count islands on a binary grid.

You do not need to be a bit-twiddling wizard daily; you need to read masks confidently and run DFS/BFS on grids without off-by-one disasters.

## Bit operations

Assume two’s complement integers (Kotlin/Swift/Dart/TS bitwise on 32-bit signed for `>>>` quirks in JS).

| Op | Symbol | Meaning | Example (`a=0b0101`, `b=0b0011`) |
|----|--------|---------|----------------------------------|
| AND | `&` | Bits set in both | `0b0001` |
| OR | `\|` | Bits set in either | `0b0111` |
| XOR | `^` | Bits differ | `0b0110` |
| NOT | `~` | Flip bits | platform-width dependent |
| Left shift | `<<` | Multiply by 2ⁿ (approx) | `0b1010` |
| Right shift | `>>` | Arithmetic (sign-extend) or logical | language-specific |
| Logical right | see note | Zero-fill | JS/TS `>>>`, Kotlin `ushr`, Swift `&>>`, Dart `>>>` (2.14+) |

```text
Set bit i:    x | (1 << i)
Clear bit i:  x & ~(1 << i)
Toggle bit i: x ^ (1 << i)
Test bit i:   (x & (1 << i)) != 0
```

### Platform flags / OptionSet

Pack independent booleans into one integer — network permissions, decoder options, UI bar button items.

**Kotlin**

```kotlin
object Perm {
    const val READ = 1 shl 0
    const val WRITE = 1 shl 1
    const val EXEC = 1 shl 2
}
fun canWrite(flags: Int) = flags and Perm.WRITE != 0
fun grantWrite(flags: Int) = flags or Perm.WRITE
```

**Swift — OptionSet**

```swift
struct Perm: OptionSet {
    let rawValue: Int
    static let read  = Perm(rawValue: 1 << 0)
    static let write = Perm(rawValue: 1 << 1)
    static let exec  = Perm(rawValue: 1 << 2)
}
var p: Perm = [.read, .write]
p.contains(.write) // true
p.remove(.write)
```

**Dart / TypeScript** — same shift masks with `&` / `|` / `^`; document bit meanings in one place.

## Classic bit tricks

### Single number (XOR)

Every element appears twice except one. XOR is associative/commutative and `x ^ x = 0`, `x ^ 0 = x` → XOR everything; result is the singleton.

```kotlin
fun singleNumber(nums: IntArray): Int =
    nums.fold(0) { acc, x -> acc xor x }
```

### Power of two

Positive `n` is a power of two iff it has exactly one bit set: `n > 0 && (n and (n - 1)) == 0`.

```swift
func isPowerOfTwo(_ n: Int) -> Bool {
    n > 0 && (n & (n - 1)) == 0
}
```

### Count bits (Brian Kernighan / built-ins)

Clear lowest set bit repeatedly: `n &= n - 1` until zero — loops once per set bit.

```dart
int hammingWeight(int n) {
  var c = 0;
  var x = n;
  while (x != 0) {
    x &= x - 1;
    c++;
  }
  return c;
}
```

```typescript
function hammingWeight(n: number): number {
  let c = 0;
  n = n >>> 0; // treat as uint32 if needed
  while (n) {
    n &= n - 1;
    c++;
  }
  return c;
}
```

Kotlin: `Integer.bitCount(n)` / `n.countOneBits()`. Swift: `n.nonzeroBitCount`.

## Matrix patterns

Treat a matrix as a graph: cells are nodes; 4-neighbors (up/down/left/right) are edges. Stay in bounds; optionally mark visited in-place.

### Rotate image 90° clockwise (in-place)

For an `n × n` matrix:

1. **Transpose:** `matrix[i][j] ↔ matrix[j][i]`
2. **Reverse each row**

Counter-clockwise: transpose then reverse each column (or reverse rows then transpose).

```text
1 2 3       1 4 7       7 4 1
4 5 6  →T→  2 5 8  →R→  8 5 2
7 8 9       3 6 9       9 6 3
```

### Flood fill

DFS or BFS from `(sr, sc)`: replace connected same-color cells with `newColor`. Skip if start color already equals `newColor` (infinite loop hazard).

### Number of islands

Grid of `'1'` land / `'0'` water. For each unvisited land cell, increment count and flood-fill (DFS/BFS) to mark the whole island visited (set to `'0'` or use a visited matrix).

Time O(rows · cols), space O(rows · cols) worst-case recursion/queue.

### Kotlin — islands

```kotlin
fun numIslands(grid: Array<CharArray>): Int {
    var count = 0
    fun dfs(r: Int, c: Int) {
        if (r !in grid.indices || c !in grid[0].indices || grid[r][c] != '1') return
        grid[r][c] = '0'
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    for (r in grid.indices) for (c in grid[0].indices) {
        if (grid[r][c] == '1') {
            count++
            dfs(r, c)
        }
    }
    return count
}
```

### Swift — rotate 90°

```swift
func rotate(_ matrix: inout [[Int]]) {
    let n = matrix.count
    for i in 0..<n {
        for j in i..<n {
            let t = matrix[i][j]
            matrix[i][j] = matrix[j][i]
            matrix[j][i] = t
        }
    }
    for i in 0..<n {
        matrix[i].reverse()
    }
}
```

### Dart — flood fill

```dart
void floodFill(List<List<int>> image, int sr, int sc, int newColor) {
  final old = image[sr][sc];
  if (old == newColor) return;
  void dfs(int r, int c) {
    if (r < 0 || c < 0 || r >= image.length || c >= image[0].length) return;
    if (image[r][c] != old) return;
    image[r][c] = newColor;
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }
  dfs(sr, sc);
}
```

### TypeScript — single number + islands sketch

```typescript
function singleNumber(nums: number[]): number {
  return nums.reduce((a, x) => a ^ x, 0);
}

function numIslands(grid: string[][]): number {
  let count = 0;
  const rows = grid.length, cols = grid[0]?.length ?? 0;
  const dfs = (r: number, c: number) => {
    if (r < 0 || c < 0 || r >= rows || c >= cols || grid[r][c] !== "1") return;
    grid[r][c] = "0";
    dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1);
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

## Complexity

| Problem | Time | Space |
|---------|------|-------|
| Single number XOR | O(n) | O(1) |
| Power of two | O(1) | O(1) |
| Count bits (Kernighan) | O(#set bits) | O(1) |
| Rotate n×n | O(n²) | O(1) extra |
| Flood fill / islands | O(R·C) | O(R·C) worst stack |

## Platform bridges

| Platform | Bits / grids |
|----------|--------------|
| **Android** | `PackageManager` flags; bitmap pixel buffers; Canvas transforms for rotate UI (prefer framework for real images) |
| **iOS** | `OptionSet`; Core Graphics / UIImage orientation — algorithm for interviews, APIs for product |
| **Flutter** | CustomPainter grids; `int` flags in FFI |
| **React Native** | Bitmasks in native modules; JS `>>>` for unsigned 32-bit |

## Common mistakes

1. Using `/` and floating math for “power of two” instead of bit test.
2. Flood fill without the `oldColor == newColor` guard.
3. 8-direction islands when the problem says 4-direction (or vice versa).
4. Rotating a non-square matrix with the square in-place recipe.
5. Sign-bit surprises with `>>` vs `>>>` in JavaScript.

## Self-Check

**22.1** Why does XOR of all elements yield the unique singleton when others appear twice?

**22.2** Explain `n & (n - 1)` for powers of two.

**22.3** Steps to rotate a square matrix 90° clockwise in-place?

**22.4** How does number-of-islands use flood fill?

**22.5** What is Swift’s `OptionSet` for?

*(Answers: Appendix D.)*

## Practice

1. **Single number** — [solutions/ch22](../../solutions/ch22/README.md#p1-single-number)
2. **Number of islands** — [solutions/ch22](../../solutions/ch22/README.md#p2-number-of-islands)
3. **Rotate image 90°** — [solutions/ch22](../../solutions/ch22/README.md#p3-rotate-image-90)

Next: [Chapter 23 — Concurrency](23-concurrency.md) — races, confinement, actors, and backpressure for network pipelines.
