# Chapter 16 — Model Solutions

Model solutions for Chapter 16 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-v/16-recursion-backtracking.md`](../../book/part-v/16-recursion-backtracking.md).

---

## P1: Subsets

### Approach

Backtracking over indices: at position `i`, either skip `nums[i]` or include it. Record a **copy** of the current path at every call (including the start) so the power set is complete. Undo the include branch with `removeLast` / `pop`.

### Complexity

- Time: O(n · 2ⁿ) — 2ⁿ subsets, each copied in O(n)
- Space: O(n) recursion depth + O(n · 2ⁿ) for output

### Edge cases

- Empty input → `[[]]`
- Duplicates in input — this solution assumes distinct elements; sort + skip-equal siblings if duplicates appear
- Large n (>20) — output size explodes; not for production feeds

### Mobile note

Interview staple. In apps, “all subsets of user-selected filters” is only sane for tiny n (e.g. ≤ 12 toggles). Prefer explicit product rules over generating 2ⁿ UI states.

### Kotlin

```kotlin
fun subsets(nums: IntArray): List<List<Int>> {
    val out = mutableListOf<List<Int>>()
    val path = mutableListOf<Int>()
    fun dfs(i: Int) {
        if (i == nums.size) {
            out += path.toList()
            return
        }
        dfs(i + 1)                 // skip
        path += nums[i]            // take
        dfs(i + 1)
        path.removeAt(path.lastIndex)
    }
    dfs(0)
    return out
}
```

### Swift

```swift
func subsets(_ nums: [Int]) -> [[Int]] {
    var out: [[Int]] = []
    var path: [Int] = []
    func dfs(_ i: Int) {
        if i == nums.count {
            out.append(path)
            return
        }
        dfs(i + 1)
        path.append(nums[i])
        dfs(i + 1)
        path.removeLast()
    }
    dfs(0)
    return out
}
```

### Dart

```dart
List<List<int>> subsets(List<int> nums) {
  final out = <List<int>>[];
  final path = <int>[];
  void dfs(int i) {
    if (i == nums.length) {
      out.add(List<int>.from(path));
      return;
    }
    dfs(i + 1);
    path.add(nums[i]);
    dfs(i + 1);
    path.removeLast();
  }
  dfs(0);
  return out;
}
```

### TypeScript

```typescript
function subsets(nums: number[]): number[][] {
  const out: number[][] = [];
  const path: number[] = [];
  const dfs = (i: number) => {
    if (i === nums.length) {
      out.push([...path]);
      return;
    }
    dfs(i + 1);
    path.push(nums[i]);
    dfs(i + 1);
    path.pop();
  };
  dfs(0);
  return out;
}
```

---

## P2: Combination sum

### Approach

Candidates may be reused. DFS with remaining `target` and start index `start` to avoid permuting the same multiset. Try each `candidates[j]` for `j >= start` if `candidates[j] <= remain`; push, recurse with same `j` (reuse allowed), pop.

Sorting first enables early break when `candidates[j] > remain`.

### Complexity

- Time: exponential in solution count / depth; roughly O(n^{T/min}) worst case
- Space: O(T/min) depth + output size

### Edge cases

- No combination → empty list
- `target` equals one candidate
- Candidate `1` with large target — deep recursion; iterative DP may be safer for huge targets
- Zeros / negatives — problem assumes positive candidates

### Mobile note

Maps to “ways to spend store credit with reusable SKUs” only at tiny catalogs. Prefer DP coin-change counting or server-side rules for real commerce.

### Kotlin

```kotlin
fun combinationSum(candidates: IntArray, target: Int): List<List<Int>> {
    candidates.sort()
    val out = mutableListOf<List<Int>>()
    val path = mutableListOf<Int>()
    fun dfs(start: Int, remain: Int) {
        if (remain == 0) {
            out += path.toList()
            return
        }
        for (j in start until candidates.size) {
            val c = candidates[j]
            if (c > remain) break
            path += c
            dfs(j, remain - c)
            path.removeAt(path.lastIndex)
        }
    }
    dfs(0, target)
    return out
}
```

### Swift

```swift
func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
    let nums = candidates.sorted()
    var out: [[Int]] = []
    var path: [Int] = []
    func dfs(_ start: Int, _ remain: Int) {
        if remain == 0 {
            out.append(path)
            return
        }
        for j in start..<nums.count {
            let c = nums[j]
            if c > remain { break }
            path.append(c)
            dfs(j, remain - c)
            path.removeLast()
        }
    }
    dfs(0, target)
    return out
}
```

### Dart

```dart
List<List<int>> combinationSum(List<int> candidates, int target) {
  final nums = [...candidates]..sort();
  final out = <List<int>>[];
  final path = <int>[];
  void dfs(int start, int remain) {
    if (remain == 0) {
      out.add(List<int>.from(path));
      return;
    }
    for (var j = start; j < nums.length; j++) {
      final c = nums[j];
      if (c > remain) break;
      path.add(c);
      dfs(j, remain - c);
      path.removeLast();
    }
  }
  dfs(0, target);
  return out;
}
```

### TypeScript

```typescript
function combinationSum(candidates: number[], target: number): number[][] {
  const nums = [...candidates].sort((a, b) => a - b);
  const out: number[][] = [];
  const path: number[] = [];
  const dfs = (start: number, remain: number) => {
    if (remain === 0) {
      out.push([...path]);
      return;
    }
    for (let j = start; j < nums.length; j++) {
      const c = nums[j];
      if (c > remain) break;
      path.push(c);
      dfs(j, remain - c);
      path.pop();
    }
  };
  dfs(0, target);
  return out;
}
```

---

## P3: Phone letter combinations

### Approach

Classic backtracking on digit positions. Map `'2'..'9'` to letter groups. At index `i`, append each letter for `digits[i]`, recurse to `i+1`, pop. Base: `i == digits.length` → record string. Empty input → empty list (not `[""]`).

### Complexity

- Time: O(4ⁿ · n) worst case (digits like 7/9 have 4 letters); n = length
- Space: O(n) depth + output size

### Edge cases

- `""` → `[]`
- Single digit
- Digits including 7 or 9 (four letters)
- Very long digit strings — output explodes; cap in product code

### Mobile note

Same shape as building autocomplete paths from a small key graph. Fine for SMS T9-style demos; production keyboards use tries and language models, not raw 4ⁿ enumeration on the UI thread.

### Kotlin

```kotlin
fun letterCombinations(digits: String): List<String> {
    if (digits.isEmpty()) return emptyList()
    val map = arrayOf("", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz")
    val out = mutableListOf<String>()
    val path = StringBuilder()
    fun dfs(i: Int) {
        if (i == digits.length) {
            out += path.toString()
            return
        }
        for (c in map[digits[i] - '0']) {
            path.append(c)
            dfs(i + 1)
            path.deleteCharAt(path.lastIndex)
        }
    }
    dfs(0)
    return out
}
```

### Swift

```swift
func letterCombinations(_ digits: String) -> [String] {
    if digits.isEmpty { return [] }
    let map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
    let chars = Array(digits)
    var out: [String] = []
    var path: [Character] = []
    func dfs(_ i: Int) {
        if i == chars.count {
            out.append(String(path))
            return
        }
        let idx = Int(chars[i].asciiValue! - Character("0").asciiValue!)
        for c in map[idx] {
            path.append(c)
            dfs(i + 1)
            path.removeLast()
        }
    }
    dfs(0)
    return out
}
```

### Dart

```dart
List<String> letterCombinations(String digits) {
  if (digits.isEmpty) return [];
  const map = ['', '', 'abc', 'def', 'ghi', 'jkl', 'mno', 'pqrs', 'tuv', 'wxyz'];
  final out = <String>[];
  final path = <String>[];
  void dfs(int i) {
    if (i == digits.length) {
      out.add(path.join());
      return;
    }
    final letters = map[digits.codeUnitAt(i) - 48];
    for (var k = 0; k < letters.length; k++) {
      path.add(letters[k]);
      dfs(i + 1);
      path.removeLast();
    }
  }
  dfs(0);
  return out;
}
```

### TypeScript

```typescript
function letterCombinations(digits: string): string[] {
  if (!digits) return [];
  const map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"];
  const out: string[] = [];
  const path: string[] = [];
  const dfs = (i: number) => {
    if (i === digits.length) {
      out.push(path.join(""));
      return;
    }
    for (const c of map[digits.charCodeAt(i) - 48]) {
      path.push(c);
      dfs(i + 1);
      path.pop();
    }
  };
  dfs(0);
  return out;
}
```
