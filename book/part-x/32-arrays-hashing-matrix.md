# Chapter 32 — Arrays, Hashing & Matrix (12-Day Plan Gap-Closer)

Part X fills the gaps between this book and a widely shared **12-day DSA plan** (120 standard problems). Most of that plan is already covered: Contains Duplicate and Longest Consecutive Sequence in [Chapter 8](../part-iii/08-sets.md), Two Sum in [Chapter 7](../part-iii/07-hash-tables.md), Group Anagrams in [Chapter 21](../part-vi/21-strings.md), Rotate Image in [Chapter 22](../part-vi/22-bits-matrix.md), Top K Frequent and Subarray Sum Equals K in the [Chapter 24 question bank](../part-vii/24-interview-questions.md), and the hard ones in the [Chapter 27 hard bank](../part-viii/27-hard-drill-bank.md). This chapter adds the **ten Day 1–2 array, hashing and matrix problems** the book was missing, in the same drill format.

Companion index: [`solutions/ch32/README.md`](../../solutions/ch32/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Plan days** | Day 1 (arrays & hashing): Q1–Q4 · Day 2 (Kadane, matrix, prefix sums): Q5–Q10 |
| **Time** | 20–30 minutes per problem; these are mediums with one or two easies |
| **Speak first** | Brute force in one line, then the optimal idea and its **time/space** before code |
| **Languages** | Every problem shows **Kotlin, Swift, Dart, TypeScript** (Android, iOS, Flutter, React Native), same algorithm and names |
| **Edges** | Empty input, single element, zeros, negatives, duplicates, `Int` overflow |
| **Mobile tell** | One sentence on where the pattern shows up in an app, only when it is real |

Do these on the plan's Day 1 and Day 2 alongside the problems linked above, not as a separate block.

---

## Q1. Product of Array Except Self (Basket Price Multipliers)

**Topic:** Prefix / suffix products

**Plan day:** Day 1

**Statement**

Given an integer array `nums`, return `out` where `out[i]` is the product of every element except `nums[i]`. Do not use division, and run in O(n). Framing: each cart line has a multiplier; for each line, show what the basket total multiplier would be if that line were removed.

**Approach**

Brute force: for each `i`, multiply all other elements, O(n²). Optimal: one left-to-right pass writes the product of everything before `i` into `out[i]`; a right-to-left pass multiplies in the product of everything after `i`. No division, so zeros need no special case.

**Complexity:** Time O(n), Space O(1) extra (output excluded)

### Kotlin

```kotlin
fun productExceptSelf(nums: IntArray): IntArray {
    val out = IntArray(nums.size) { 1 }
    var prefix = 1
    for (i in nums.indices) {
        out[i] = prefix
        prefix *= nums[i]
    }
    var suffix = 1
    for (i in nums.indices.reversed()) {
        out[i] *= suffix
        suffix *= nums[i]
    }
    return out
}
```

### Swift

```swift
func productExceptSelf(_ nums: [Int]) -> [Int] {
    var out = [Int](repeating: 1, count: nums.count)
    var prefix = 1
    for i in 0..<nums.count {
        out[i] = prefix
        prefix *= nums[i]
    }
    var suffix = 1
    for i in stride(from: nums.count - 1, through: 0, by: -1) {
        out[i] *= suffix
        suffix *= nums[i]
    }
    return out
}
```

### Dart

```dart
List<int> productExceptSelf(List<int> nums) {
  final out = List<int>.filled(nums.length, 1);
  var prefix = 1;
  for (var i = 0; i < nums.length; i++) {
    out[i] = prefix;
    prefix *= nums[i];
  }
  var suffix = 1;
  for (var i = nums.length - 1; i >= 0; i--) {
    out[i] *= suffix;
    suffix *= nums[i];
  }
  return out;
}
```

### TypeScript

```typescript
function productExceptSelf(nums: number[]): number[] {
  const out = new Array<number>(nums.length).fill(1);
  let prefix = 1;
  for (let i = 0; i < nums.length; i++) {
    out[i] = prefix;
    prefix *= nums[i];
  }
  let suffix = 1;
  for (let i = nums.length - 1; i >= 0; i--) {
    out[i] *= suffix;
    suffix *= nums[i];
  }
  return out;
}
```

**Mobile note:** The division trick fails on a zero multiplier (a free item) and loses precision on money; prefix/suffix avoids both.

---

## Q2. Valid Sudoku (Puzzle Board Check)

**Topic:** Hashing / bitmasks

**Plan day:** Day 1

**Statement**

A 9×9 board holds digits `'1'`–`'9'` or `'.'` for empty. Return whether the filled cells are valid: no digit repeats in any row, column, or 3×3 box. The board does not need to be solvable. Framing: an offline puzzle game validates a saved board before syncing it.

**Approach**

Brute force: for each filled cell, scan its row, column and box, about 81 × 27 checks. Optimal: one pass with a 9-bit mask per row, column and box; box index is `(r / 3) * 3 + c / 3`. A bit already set means a duplicate.

**Complexity:** Time O(81) = O(1), Space O(27) = O(1)

### Kotlin

```kotlin
fun isValidSudoku(board: Array<CharArray>): Boolean {
    val rows = IntArray(9)
    val cols = IntArray(9)
    val boxes = IntArray(9)
    for (r in 0 until 9) {
        for (c in 0 until 9) {
            val ch = board[r][c]
            if (ch == '.') continue
            val bit = 1 shl (ch - '1')
            val b = (r / 3) * 3 + c / 3
            if ((rows[r] or cols[c] or boxes[b]) and bit != 0) return false
            rows[r] = rows[r] or bit
            cols[c] = cols[c] or bit
            boxes[b] = boxes[b] or bit
        }
    }
    return true
}
```

### Swift

```swift
func isValidSudoku(_ board: [[Character]]) -> Bool {
    var rows = [Int](repeating: 0, count: 9)
    var cols = [Int](repeating: 0, count: 9)
    var boxes = [Int](repeating: 0, count: 9)
    for r in 0..<9 {
        for c in 0..<9 {
            guard let d = board[r][c].wholeNumberValue, (1...9).contains(d) else { continue }
            let bit = 1 << (d - 1)
            let b = (r / 3) * 3 + c / 3
            if (rows[r] | cols[c] | boxes[b]) & bit != 0 { return false }
            rows[r] |= bit
            cols[c] |= bit
            boxes[b] |= bit
        }
    }
    return true
}
```

### Dart

```dart
bool isValidSudoku(List<List<String>> board) {
  final rows = List<int>.filled(9, 0);
  final cols = List<int>.filled(9, 0);
  final boxes = List<int>.filled(9, 0);
  for (var r = 0; r < 9; r++) {
    for (var c = 0; c < 9; c++) {
      final ch = board[r][c];
      if (ch == '.') continue;
      final bit = 1 << (ch.codeUnitAt(0) - 49);
      final b = (r ~/ 3) * 3 + c ~/ 3;
      if ((rows[r] | cols[c] | boxes[b]) & bit != 0) return false;
      rows[r] |= bit;
      cols[c] |= bit;
      boxes[b] |= bit;
    }
  }
  return true;
}
```

### TypeScript

```typescript
function isValidSudoku(board: string[][]): boolean {
  const rows = new Array<number>(9).fill(0);
  const cols = new Array<number>(9).fill(0);
  const boxes = new Array<number>(9).fill(0);
  for (let r = 0; r < 9; r++) {
    for (let c = 0; c < 9; c++) {
      const ch = board[r][c];
      if (ch === ".") continue;
      const bit = 1 << (ch.charCodeAt(0) - 49);
      const b = Math.floor(r / 3) * 3 + Math.floor(c / 3);
      if (((rows[r] | cols[c] | boxes[b]) & bit) !== 0) return false;
      rows[r] |= bit;
      cols[c] |= bit;
      boxes[b] |= bit;
    }
  }
  return true;
}
```

**Mobile note:** For live feedback while typing, check only the edited cell's row, column and box, not the whole board; on Android Views or Compose, mark the conflicting cells instead of rejecting the input.

---

## Q3. Encode and Decode Strings (Offline Queue Serialization)

**Topic:** String design / length prefix

**Plan day:** Day 1

**Statement**

Design `encode(list) → String` and `decode(String) → list` so that any list of strings round-trips exactly, including empty strings and strings containing any delimiter you might choose. Framing: pack a queue of pending messages into one string for a single key-value slot (SharedPreferences, UserDefaults, AsyncStorage).

**Approach**

Brute force: join with a delimiter such as `,` — breaks as soon as a message contains `,`. Escaping works but is fiddly. Optimal: write each string as `length#content`, where `length` is the content's size in **UTF-8 bytes** in all four languages, so a payload written on one platform decodes on another (`["é", "😀"]` encodes to `2#é4#😀`). The decoder walks the UTF-8 bytes: it reads digits up to the first `#`, then takes exactly `length` bytes, so the content may contain `#` or digits freely.

**Complexity:** Time O(total length), Space O(total length)

### Kotlin

```kotlin
fun encode(strs: List<String>): String {
    val sb = StringBuilder()
    for (s in strs) sb.append(s.toByteArray(Charsets.UTF_8).size).append('#').append(s)
    return sb.toString()
}

fun decode(s: String): List<String> {
    val bytes = s.toByteArray(Charsets.UTF_8)
    val out = mutableListOf<String>()
    var i = 0
    while (i < bytes.size) {
        var hash = i
        var len = 0
        while (bytes[hash] != '#'.code.toByte()) len = len * 10 + (bytes[hash++] - '0'.code.toByte())
        out.add(String(bytes, hash + 1, len, Charsets.UTF_8))
        i = hash + 1 + len
    }
    return out
}
```

### Swift

```swift
func encode(_ strs: [String]) -> String {
    strs.map { "\($0.utf8.count)#\($0)" }.joined()
}

func decode(_ s: String) -> [String] {
    let bytes = Array(s.utf8)
    var out: [String] = []
    var i = 0
    while i < bytes.count {
        var hash = i
        while bytes[hash] != UInt8(ascii: "#") { hash += 1 }
        let len = bytes[i..<hash].reduce(0) { $0 * 10 + Int($1 - UInt8(ascii: "0")) }
        out.append(String(decoding: bytes[(hash + 1)..<(hash + 1 + len)], as: UTF8.self))
        i = hash + 1 + len
    }
    return out
}
```

### Dart

```dart
import 'dart:convert';

String encode(List<String> strs) => strs.map((s) => '${utf8.encode(s).length}#$s').join();

List<String> decode(String s) {
  final bytes = utf8.encode(s);
  final out = <String>[];
  var i = 0;
  while (i < bytes.length) {
    var hash = i;
    var len = 0;
    while (bytes[hash] != 0x23) {
      len = len * 10 + (bytes[hash++] - 0x30);
    }
    out.add(utf8.decode(bytes.sublist(hash + 1, hash + 1 + len)));
    i = hash + 1 + len;
  }
  return out;
}
```

### TypeScript

```typescript
const utf8 = new TextEncoder();
const fromUtf8 = new TextDecoder();

function encode(strs: string[]): string {
  return strs.map((s) => `${utf8.encode(s).length}#${s}`).join("");
}

function decode(s: string): string[] {
  const bytes = utf8.encode(s);
  const out: string[] = [];
  let i = 0;
  while (i < bytes.length) {
    let hash = i;
    let len = 0;
    while (bytes[hash] !== 35) len = len * 10 + (bytes[hash++] - 48);
    out.push(fromUtf8.decode(bytes.subarray(hash + 1, hash + 1 + len)));
    i = hash + 1 + len;
  }
  return out;
}
```

**Mobile note:** Counting UTF-16 units (Kotlin, Dart, TypeScript `length`) or Swift `Character`s instead would give different prefixes for the same text and break cross-platform sync. The TypeScript version needs `TextEncoder` / `TextDecoder`, which Node and browsers provide; check that your React Native JS engine does too. In real code prefer JSON or protobuf; this question tests whether you see why a naive delimiter is not safe.

---

## Q4. String Compression (Run-Length Log Packing)

**Topic:** Two pointers (read / write)

**Plan day:** Day 1

**Statement**

Compress a character array in place: each run of a repeated character becomes the character followed by the run length, with the length omitted when it is 1, and lengths of 10 or more written as several digit characters. Return the new length. Framing: shrink a repetitive event trace before attaching it to a crash report.

**Approach**

Brute force: build a new string and copy it back, O(n) extra space. Optimal: a `read` pointer walks each run, a `write` pointer writes the character and then the digits of the count. The writer never overtakes the reader, because a run of length k writes at most k characters.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun compress(chars: CharArray): Int {
    var write = 0
    var read = 0
    while (read < chars.size) {
        val ch = chars[read]
        var run = 0
        while (read < chars.size && chars[read] == ch) {
            read++
            run++
        }
        chars[write++] = ch
        if (run > 1) for (d in run.toString()) chars[write++] = d
    }
    return write
}
```

### Swift

```swift
func compress(_ chars: inout [Character]) -> Int {
    var write = 0
    var read = 0
    while read < chars.count {
        let ch = chars[read]
        var run = 0
        while read < chars.count && chars[read] == ch {
            read += 1
            run += 1
        }
        chars[write] = ch
        write += 1
        if run > 1 {
            for d in String(run) {
                chars[write] = d
                write += 1
            }
        }
    }
    return write
}
```

### Dart

```dart
int compress(List<String> chars) {
  var write = 0;
  var read = 0;
  while (read < chars.length) {
    final ch = chars[read];
    var run = 0;
    while (read < chars.length && chars[read] == ch) {
      read++;
      run++;
    }
    chars[write++] = ch;
    if (run > 1) {
      for (final d in run.toString().split('')) {
        chars[write++] = d;
      }
    }
  }
  return write;
}
```

### TypeScript

```typescript
function compress(chars: string[]): number {
  let write = 0;
  let read = 0;
  while (read < chars.length) {
    const ch = chars[read];
    let run = 0;
    while (read < chars.length && chars[read] === ch) {
      read++;
      run++;
    }
    chars[write++] = ch;
    if (run > 1) for (const d of String(run)) chars[write++] = d;
  }
  return write;
}
```

---

## Q5. Maximum Subarray (Best Trading Streak)

**Topic:** Kadane's algorithm

**Plan day:** Day 2 (repeated on Day 9 under greedy)

**Statement**

Given a non-empty integer array, return the largest sum of any contiguous non-empty subarray. Framing: daily net P&L for a portfolio; find the best run of consecutive days.

**Approach**

Brute force: try every `(i, j)` pair with a running sum, O(n²). Optimal (Kadane): at each index, either extend the best run ending at the previous index or start fresh here — `cur = max(x, cur + x)` — and track the best `cur`. Starting from `nums[0]` handles the all-negative case.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun maxSubArray(nums: IntArray): Int {
    var best = nums[0]
    var cur = nums[0]
    for (i in 1 until nums.size) {
        cur = maxOf(nums[i], cur + nums[i])
        best = maxOf(best, cur)
    }
    return best
}
```

### Swift

```swift
func maxSubArray(_ nums: [Int]) -> Int {
    var best = nums[0]
    var cur = nums[0]
    for x in nums.dropFirst() {
        cur = max(x, cur + x)
        best = max(best, cur)
    }
    return best
}
```

### Dart

```dart
import 'dart:math';

int maxSubArray(List<int> nums) {
  var best = nums[0];
  var cur = nums[0];
  for (var i = 1; i < nums.length; i++) {
    cur = max(nums[i], cur + nums[i]);
    best = max(best, cur);
  }
  return best;
}
```

### TypeScript

```typescript
function maxSubArray(nums: number[]): number {
  let best = nums[0];
  let cur = nums[0];
  for (let i = 1; i < nums.length; i++) {
    cur = Math.max(nums[i], cur + nums[i]);
    best = Math.max(best, cur);
  }
  return best;
}
```

**Mobile note:** For money, keep amounts in minor units as `Long`; Kadane is the same.

---

## Q6. Maximum Product Subarray (Compounded Multiplier Streak)

**Topic:** DP (track max and min)

**Plan day:** Day 2

**Statement**

Given an integer array, return the largest product of any contiguous non-empty subarray. Framing: daily growth multipliers, some negative (reversals) and some zero (resets); find the best compounded run.

**Approach**

Brute force: every `(i, j)` pair with a running product, O(n²). Optimal: Kadane needs the **minimum** product too, because a negative number turns the most negative product into the largest. At each step the new max and min are among `x`, `max * x`, `min * x`. A zero resets both.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun maxProduct(nums: IntArray): Int {
    var hi = nums[0]
    var lo = nums[0]
    var best = nums[0]
    for (i in 1 until nums.size) {
        val x = nums[i]
        val a = hi * x
        val b = lo * x
        hi = maxOf(x, a, b)
        lo = minOf(x, a, b)
        best = maxOf(best, hi)
    }
    return best
}
```

### Swift

```swift
func maxProduct(_ nums: [Int]) -> Int {
    var hi = nums[0], lo = nums[0], best = nums[0]
    for x in nums.dropFirst() {
        let a = hi * x, b = lo * x
        hi = max(x, a, b)
        lo = min(x, a, b)
        best = max(best, hi)
    }
    return best
}
```

### Dart

```dart
import 'dart:math';

int maxProduct(List<int> nums) {
  var hi = nums[0], lo = nums[0], best = nums[0];
  for (final x in nums.skip(1)) {
    final a = hi * x, b = lo * x;
    hi = max(x, max(a, b));
    lo = min(x, min(a, b));
    best = max(best, hi);
  }
  return best;
}
```

### TypeScript

```typescript
function maxProduct(nums: number[]): number {
  let hi = nums[0];
  let lo = nums[0];
  let best = nums[0];
  for (let i = 1; i < nums.length; i++) {
    const x = nums[i];
    const a = hi * x;
    const b = lo * x;
    hi = Math.max(x, a, b);
    lo = Math.min(x, a, b);
    best = Math.max(best, hi);
  }
  return best;
}
```

---

## Q7. Set Matrix Zeroes (Invalidate Grid Rows and Columns)

**Topic:** Matrix / in-place markers

**Plan day:** Day 2

**Statement**

Given an m×n integer matrix, if a cell is 0, set its whole row and column to 0. Do it in place. Framing: in a seat-map grid, one blocked seat closes its row and its aisle column.

**Approach**

Brute force: copy the matrix, or keep a row set and a column set, O(m + n) space. Optimal: use the first row and first column as the marker arrays. First remember whether row 0 or column 0 already has a zero, then mark, then clear the inner cells from the markers, and finally clear row 0 and column 0 if needed.

**Complexity:** Time O(m·n), Space O(1)

### Kotlin

```kotlin
fun setZeroes(matrix: Array<IntArray>) {
    if (matrix.isEmpty()) return
    val m = matrix.size
    val n = matrix[0].size
    val firstRowZero = (0 until n).any { matrix[0][it] == 0 }
    val firstColZero = (0 until m).any { matrix[it][0] == 0 }
    for (r in 1 until m) for (c in 1 until n) {
        if (matrix[r][c] == 0) {
            matrix[r][0] = 0
            matrix[0][c] = 0
        }
    }
    for (r in 1 until m) for (c in 1 until n) {
        if (matrix[r][0] == 0 || matrix[0][c] == 0) matrix[r][c] = 0
    }
    if (firstRowZero) for (c in 0 until n) matrix[0][c] = 0
    if (firstColZero) for (r in 0 until m) matrix[r][0] = 0
}
```

### Swift

```swift
func setZeroes(_ matrix: inout [[Int]]) {
    guard !matrix.isEmpty else { return }
    let m = matrix.count
    let n = matrix[0].count
    let firstRowZero = matrix[0].contains(0)
    let firstColZero = matrix.contains { $0[0] == 0 }
    for r in 1..<m {
        for c in 1..<n where matrix[r][c] == 0 {
            matrix[r][0] = 0
            matrix[0][c] = 0
        }
    }
    for r in 1..<m {
        for c in 1..<n where matrix[r][0] == 0 || matrix[0][c] == 0 {
            matrix[r][c] = 0
        }
    }
    if firstRowZero { for c in 0..<n { matrix[0][c] = 0 } }
    if firstColZero { for r in 0..<m { matrix[r][0] = 0 } }
}
```

### Dart

```dart
void setZeroes(List<List<int>> matrix) {
  if (matrix.isEmpty) return;
  final m = matrix.length;
  final n = matrix[0].length;
  final firstRowZero = matrix[0].contains(0);
  final firstColZero = matrix.any((row) => row[0] == 0);
  for (var r = 1; r < m; r++) {
    for (var c = 1; c < n; c++) {
      if (matrix[r][c] == 0) {
        matrix[r][0] = 0;
        matrix[0][c] = 0;
      }
    }
  }
  for (var r = 1; r < m; r++) {
    for (var c = 1; c < n; c++) {
      if (matrix[r][0] == 0 || matrix[0][c] == 0) matrix[r][c] = 0;
    }
  }
  if (firstRowZero) matrix[0].fillRange(0, n, 0);
  if (firstColZero) {
    for (final row in matrix) {
      row[0] = 0;
    }
  }
}
```

### TypeScript

```typescript
function setZeroes(matrix: number[][]): void {
  if (matrix.length === 0) return;
  const m = matrix.length;
  const n = matrix[0].length;
  const firstRowZero = matrix[0].some((v) => v === 0);
  const firstColZero = matrix.some((row) => row[0] === 0);
  for (let r = 1; r < m; r++) {
    for (let c = 1; c < n; c++) {
      if (matrix[r][c] === 0) {
        matrix[r][0] = 0;
        matrix[0][c] = 0;
      }
    }
  }
  for (let r = 1; r < m; r++) {
    for (let c = 1; c < n; c++) {
      if (matrix[r][0] === 0 || matrix[0][c] === 0) matrix[r][c] = 0;
    }
  }
  if (firstRowZero) matrix[0].fill(0);
  if (firstColZero) for (const row of matrix) row[0] = 0;
}
```

**Mobile note:** In the UI layer you would not mutate in place; you would derive a new immutable grid for Compose state or a `RecyclerView` adapter. The in-place version is the interview constraint.

---

## Q8. Spiral Matrix (Onboarding Tile Reveal Order)

**Topic:** Matrix traversal / boundaries

**Plan day:** Day 2

**Statement**

Return all elements of an m×n matrix in clockwise spiral order, starting at the top-left. Framing: tiles of a grid animate in one by one along a spiral.

**Approach**

Brute force: walk with a direction vector and a `visited` matrix, O(m·n) extra space. Optimal: keep four boundaries `top`, `bottom`, `left`, `right`. Walk the top row, the right column, then (if rows remain) the bottom row backwards, then (if columns remain) the left column upwards, shrinking each boundary after its side. The two checks stop single rows or columns being visited twice.

**Complexity:** Time O(m·n), Space O(1) extra

### Kotlin

```kotlin
fun spiralOrder(matrix: Array<IntArray>): List<Int> {
    val out = mutableListOf<Int>()
    if (matrix.isEmpty()) return out
    var top = 0
    var bottom = matrix.size - 1
    var left = 0
    var right = matrix[0].size - 1
    while (top <= bottom && left <= right) {
        for (c in left..right) out.add(matrix[top][c])
        top++
        for (r in top..bottom) out.add(matrix[r][right])
        right--
        if (top <= bottom) {
            for (c in right downTo left) out.add(matrix[bottom][c])
            bottom--
        }
        if (left <= right) {
            for (r in bottom downTo top) out.add(matrix[r][left])
            left++
        }
    }
    return out
}
```

### Swift

```swift
func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    var out: [Int] = []
    guard !matrix.isEmpty else { return out }
    var top = 0, bottom = matrix.count - 1
    var left = 0, right = matrix[0].count - 1
    while top <= bottom && left <= right {
        for c in stride(from: left, through: right, by: 1) { out.append(matrix[top][c]) }
        top += 1
        for r in stride(from: top, through: bottom, by: 1) { out.append(matrix[r][right]) }
        right -= 1
        if top <= bottom {
            for c in stride(from: right, through: left, by: -1) { out.append(matrix[bottom][c]) }
            bottom -= 1
        }
        if left <= right {
            for r in stride(from: bottom, through: top, by: -1) { out.append(matrix[r][left]) }
            left += 1
        }
    }
    return out
}
```

### Dart

```dart
List<int> spiralOrder(List<List<int>> matrix) {
  final out = <int>[];
  if (matrix.isEmpty) return out;
  var top = 0, bottom = matrix.length - 1;
  var left = 0, right = matrix[0].length - 1;
  while (top <= bottom && left <= right) {
    for (var c = left; c <= right; c++) out.add(matrix[top][c]);
    top++;
    for (var r = top; r <= bottom; r++) out.add(matrix[r][right]);
    right--;
    if (top <= bottom) {
      for (var c = right; c >= left; c--) out.add(matrix[bottom][c]);
      bottom--;
    }
    if (left <= right) {
      for (var r = bottom; r >= top; r--) out.add(matrix[r][left]);
      left++;
    }
  }
  return out;
}
```

### TypeScript

```typescript
function spiralOrder(matrix: number[][]): number[] {
  const out: number[] = [];
  if (matrix.length === 0) return out;
  let top = 0;
  let bottom = matrix.length - 1;
  let left = 0;
  let right = matrix[0].length - 1;
  while (top <= bottom && left <= right) {
    for (let c = left; c <= right; c++) out.push(matrix[top][c]);
    top++;
    for (let r = top; r <= bottom; r++) out.push(matrix[r][right]);
    right--;
    if (top <= bottom) {
      for (let c = right; c >= left; c--) out.push(matrix[bottom][c]);
      bottom--;
    }
    if (left <= right) {
      for (let r = bottom; r >= top; r--) out.push(matrix[r][left]);
      left++;
    }
  }
  return out;
}
```

**Mobile note:** Compute the order once, then use each tile's index in the list as its animation delay (a staggered `animate*AsState` in Compose, or `ViewPropertyAnimator.setStartDelay` with Views).

---

## Q9. Range Sum Query — Immutable (Statement Range Totals)

**Topic:** Prefix sums

**Plan day:** Day 2

**Statement**

Build a class from an integer array that answers many `sumRange(left, right)` queries, inclusive, on an array that never changes. Framing: a statement screen shows the total for whichever date range the user drags the slider to.

**Approach**

Brute force: loop from `left` to `right` per query, O(n) each. Optimal: precompute `prefix[i + 1] = prefix[i] + nums[i]` once; a query is `prefix[right + 1] − prefix[left]`. The extra leading 0 removes the `left == 0` special case. Use `Long` so large values cannot overflow.

**Complexity:** Time O(n) build, O(1) per query; Space O(n)

### Kotlin

```kotlin
class NumArray(nums: IntArray) {
    private val prefix = LongArray(nums.size + 1)

    init {
        for (i in nums.indices) prefix[i + 1] = prefix[i] + nums[i]
    }

    fun sumRange(left: Int, right: Int): Long = prefix[right + 1] - prefix[left]
}
```

### Swift

```swift
final class NumArray {
    private var prefix: [Int]

    init(_ nums: [Int]) {
        prefix = [Int](repeating: 0, count: nums.count + 1)
        for i in 0..<nums.count { prefix[i + 1] = prefix[i] + nums[i] }
    }

    func sumRange(_ left: Int, _ right: Int) -> Int {
        prefix[right + 1] - prefix[left]
    }
}
```

### Dart

```dart
class NumArray {
  final List<int> _prefix;

  NumArray(List<int> nums) : _prefix = List<int>.filled(nums.length + 1, 0) {
    for (var i = 0; i < nums.length; i++) {
      _prefix[i + 1] = _prefix[i] + nums[i];
    }
  }

  int sumRange(int left, int right) => _prefix[right + 1] - _prefix[left];
}
```

### TypeScript

```typescript
class NumArray {
  private prefix: number[];

  constructor(nums: number[]) {
    this.prefix = new Array<number>(nums.length + 1).fill(0);
    for (let i = 0; i < nums.length; i++) this.prefix[i + 1] = this.prefix[i] + nums[i];
  }

  sumRange(left: number, right: number): number {
    return this.prefix[right + 1] - this.prefix[left];
  }
}
```

**Mobile note:** Build the prefix array off the main thread when the data loads; slider drags then cost O(1) each and never drop a frame.

---

## Q10. First Missing Positive (Next Free Ticket Number)

**Topic:** Cyclic sort / index as hash

**Plan day:** Day 2

**Statement**

Given an unsorted integer array, return the smallest positive integer that does not appear. Run in O(n) time with O(1) extra space. Framing: find the lowest unused local ticket number among drafts created offline.

**Approach**

Brute force: put everything in a hash set and count up from 1 (O(n) space), or sort (O(n log n)). Optimal: the answer is in `1..n+1`, so use the array as its own hash. Swap each value `v` in `1..n` into slot `v − 1` until every slot holds its value or a value that cannot be placed. The first slot `i` without `i + 1` gives the answer; if all are filled, it is `n + 1`. Each swap places a value for good, so the total work is O(n).

**Complexity:** Time O(n), Space O(1)

The Kotlin and TypeScript versions reorder the caller's array in place; the Swift and Dart versions copy it first (Swift parameters are immutable), which costs O(n) extra space.

### Kotlin

```kotlin
fun firstMissingPositive(nums: IntArray): Int {
    val n = nums.size
    for (i in 0 until n) {
        while (nums[i] in 1..n && nums[nums[i] - 1] != nums[i]) {
            val j = nums[i] - 1
            nums[i] = nums[j].also { nums[j] = nums[i] }
        }
    }
    for (i in 0 until n) if (nums[i] != i + 1) return i + 1
    return n + 1
}
```

### Swift

```swift
func firstMissingPositive(_ input: [Int]) -> Int {
    var nums = input
    let n = nums.count
    for i in 0..<n {
        while nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] != nums[i] {
            nums.swapAt(i, nums[i] - 1)
        }
    }
    for i in 0..<n where nums[i] != i + 1 { return i + 1 }
    return n + 1
}
```

### Dart

```dart
int firstMissingPositive(List<int> input) {
  final nums = List<int>.of(input);
  final n = nums.length;
  for (var i = 0; i < n; i++) {
    while (nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
      final j = nums[i] - 1;
      final tmp = nums[j];
      nums[j] = nums[i];
      nums[i] = tmp;
    }
  }
  for (var i = 0; i < n; i++) {
    if (nums[i] != i + 1) return i + 1;
  }
  return n + 1;
}
```

### TypeScript

```typescript
function firstMissingPositive(nums: number[]): number {
  const n = nums.length;
  for (let i = 0; i < n; i++) {
    while (nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] !== nums[i]) {
      const j = nums[i] - 1;
      [nums[i], nums[j]] = [nums[j], nums[i]];
    }
  }
  for (let i = 0; i < n; i++) if (nums[i] !== i + 1) return i + 1;
  return n + 1;
}
```

---

## Drill checklist (say aloud)

1. Brute force in one sentence, then the better idea.  
2. Complexity **before** code.  
3. Name the trick: prefix/suffix, bitmask, length prefix, Kadane, markers in place, boundaries, index as hash.  
4. Edges: empty, single, zeros, negatives, duplicates, overflow.  
5. One mobile sentence only when it is real.

Previous: [Chapter 31 — Math & Number Drills](../part-ix/31-math-and-number-drills.md) · Next: [Chapter 33 — Two Pointers, Sliding Window & Intervals](33-two-pointers-windows-intervals.md)
