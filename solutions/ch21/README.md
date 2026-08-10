# Chapter 21 — Model Solutions

Model solutions for Chapter 21 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-vi/21-strings.md`](../../book/part-vi/21-strings.md).

---

## P1: Group anagrams

### Approach

Hash each string by a **canonical key** (sorted characters, or a 26-letter frequency signature for lowercase a–z). Append the original word to the bucket for that key. Return all buckets.

### Complexity

- Time: O(n · k log k) with sort keys; O(n · k) with count signatures (k = max length)
- Space: O(n · k)

### Edge cases

- Empty input → empty list
- Single words / all unique keys
- Empty string `""` as a word
- Duplicates already anagrams of each other

### Mobile note

Contact dedupe / “similar search queries” clustering on-device. Cap `n` and `k`; huge dictionaries belong on the server. Prefer count keys if alphabet is small and k is large.

### Kotlin

```kotlin
fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val key = s.toCharArray().sorted().joinToString("")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}

// Alternative frequency key for a–z:
fun groupAnagramsCounts(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val cnt = IntArray(26)
        for (c in s) cnt[c - 'a']++
        val key = cnt.joinToString("#")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}
```

### Swift

```swift
func groupAnagrams(_ strs: [String]) -> [[String]] {
    var map: [String: [String]] = [:]
    for s in strs {
        let key = String(s.sorted())
        map[key, default: []].append(s)
    }
    return Array(map.values)
}
```

### Dart

```dart
List<List<String>> groupAnagrams(List<String> strs) {
  final map = <String, List<String>>{};
  for (final s in strs) {
    final key = String.fromCharCodes(s.runes.toList()..sort());
    map.putIfAbsent(key, () => []).add(s);
  }
  return map.values.toList();
}
```

### TypeScript

```typescript
function groupAnagrams(strs: string[]): string[][] {
  const map = new Map<string, string[]>();
  for (const s of strs) {
    const key = [...s].sort().join("");
    const bucket = map.get(key);
    if (bucket) bucket.push(s);
    else map.set(key, [s]);
  }
  return [...map.values()];
}
```

---

## P2: Longest palindromic substring

### Approach

**Expand around center.** For each index `i`, expand an odd-length palindrome centered at `(i, i)` and an even-length one at `(i, i+1)`. Track the longest `[start, end]` window. Return `s.substring(start, end+1)`.

### Complexity

- Time: O(n²)
- Space: O(1) extra (plus output string); O(n) if you materialize a char array in Swift

### Edge cases

- Empty string
- Length 1
- All identical characters → whole string
- No even palindrome longer than odds
- Two equal-length maxima — either is acceptable unless the problem specifies

### Mobile note

Interview staple. In product UI (highlight matching spans), prefer constrained n or a library. Expanding on UTF-16 indices can split emoji — use ASCII assumptions for this solution or operate on grapheme arrays when product requires it.

### Kotlin

```kotlin
fun longestPalindrome(s: String): String {
    if (s.isEmpty()) return ""
    var start = 0
    var end = 0
    fun expand(l: Int, r: Int): Pair<Int, Int> {
        var left = l
        var right = r
        while (left >= 0 && right < s.length && s[left] == s[right]) {
            left--
            right++
        }
        return (left + 1) to (right - 1)
    }
    for (i in s.indices) {
        val (a, b) = expand(i, i)
        val (c, d) = expand(i, i + 1)
        if (b - a > end - start) {
            start = a
            end = b
        }
        if (d - c > end - start) {
            start = c
            end = d
        }
    }
    return s.substring(start, end + 1)
}
```

### Swift

```swift
func longestPalindrome(_ s: String) -> String {
    let chars = Array(s)
    guard !chars.isEmpty else { return "" }
    var start = 0, end = 0
    func expand(_ l: Int, _ r: Int) -> (Int, Int) {
        var L = l, R = r
        while L >= 0 && R < chars.count && chars[L] == chars[R] {
            L -= 1
            R += 1
        }
        return (L + 1, R - 1)
    }
    for i in chars.indices {
        let (a, b) = expand(i, i)
        let (c, d) = expand(i, i + 1)
        if b - a > end - start { start = a; end = b }
        if d - c > end - start { start = c; end = d }
    }
    return String(chars[start...end])
}
```

### Dart

```dart
String longestPalindrome(String s) {
  if (s.isEmpty) return '';
  var start = 0, end = 0;
  (int, int) expand(int l, int r) {
    var L = l, R = r;
    while (L >= 0 && R < s.length && s[L] == s[R]) {
      L--;
      R++;
    }
    return (L + 1, R - 1);
  }

  for (var i = 0; i < s.length; i++) {
    final (a, b) = expand(i, i);
    final (c, d) = expand(i, i + 1);
    if (b - a > end - start) {
      start = a;
      end = b;
    }
    if (d - c > end - start) {
      start = c;
      end = d;
    }
  }
  return s.substring(start, end + 1);
}
```

### TypeScript

```typescript
function longestPalindrome(s: string): string {
  if (!s) return "";
  let start = 0, end = 0;
  const expand = (l: number, r: number): [number, number] => {
    while (l >= 0 && r < s.length && s[l] === s[r]) {
      l--;
      r++;
    }
    return [l + 1, r - 1];
  };
  for (let i = 0; i < s.length; i++) {
    const [a, b] = expand(i, i);
    const [c, d] = expand(i, i + 1);
    if (b - a > end - start) {
      start = a;
      end = b;
    }
    if (d - c > end - start) {
      start = c;
      end = d;
    }
  }
  return s.slice(start, end + 1);
}
```

---

## P3: Valid anagram / first unique character

### Approach

**Valid anagram:** if lengths differ → false. Count frequencies of `s` (+1) and `t` (−1) in one array (or two maps); all counts must end at 0. Sorting both and comparing also works (slower).

**First unique character:** count frequencies in a first pass; second pass returns the first index (or character) whose count is 1; if none, return `-1` / null per problem statement.

### Complexity

- Valid anagram: O(n) time, O(1) for fixed alphabet (or O(k) map)
- First unique: O(n) time, O(alphabet) space

### Edge cases

- Empty strings (anagram of each other)
- Unicode / emoji — decide code unit vs grapheme policy
- All characters duplicated → no unique
- Case sensitivity — usually exact match unless specified

### Mobile note

Anagram checks appear in puzzle games; first-unique in “first unread marker” style scans. For user-facing uniqueness of emoji names, use grapheme-aware iteration (Chapter 21), not raw UTF-16 length.

### Kotlin

```kotlin
fun isAnagram(s: String, t: String): Boolean {
    if (s.length != t.length) return false
    val cnt = IntArray(26)
    for (i in s.indices) {
        cnt[s[i] - 'a']++
        cnt[t[i] - 'a']--
    }
    return cnt.all { it == 0 }
}

fun firstUniqChar(s: String): Int {
    val cnt = IntArray(26)
    for (c in s) cnt[c - 'a']++
    for (i in s.indices) if (cnt[s[i] - 'a'] == 1) return i
    return -1
}
```

### Swift

```swift
func isAnagram(_ s: String, _ t: String) -> Bool {
    guard s.count == t.count else { return false }
    var cnt = [Character: Int]()
    for c in s { cnt[c, default: 0] += 1 }
    for c in t {
        guard let v = cnt[c] else { return false }
        if v == 1 { cnt[c] = nil } else { cnt[c] = v - 1 }
    }
    return cnt.isEmpty
}

func firstUniqChar(_ s: String) -> Int {
    var cnt: [Character: Int] = [:]
    for c in s { cnt[c, default: 0] += 1 }
    for (i, c) in s.enumerated() where cnt[c] == 1 {
        return i
    }
    return -1
}
```

### Dart

```dart
bool isAnagram(String s, String t) {
  if (s.length != t.length) return false;
  final cnt = List.filled(26, 0);
  for (var i = 0; i < s.length; i++) {
    cnt[s.codeUnitAt(i) - 97]++;
    cnt[t.codeUnitAt(i) - 97]--;
  }
  return cnt.every((x) => x == 0);
}

int firstUniqChar(String s) {
  final cnt = List.filled(26, 0);
  for (var i = 0; i < s.length; i++) {
    cnt[s.codeUnitAt(i) - 97]++;
  }
  for (var i = 0; i < s.length; i++) {
    if (cnt[s.codeUnitAt(i) - 97] == 1) return i;
  }
  return -1;
}
```

### TypeScript

```typescript
function isAnagram(s: string, t: string): boolean {
  if (s.length !== t.length) return false;
  const cnt = new Array(26).fill(0);
  for (let i = 0; i < s.length; i++) {
    cnt[s.charCodeAt(i) - 97]++;
    cnt[t.charCodeAt(i) - 97]--;
  }
  return cnt.every((x) => x === 0);
}

function firstUniqChar(s: string): number {
  const cnt = new Array(26).fill(0);
  for (let i = 0; i < s.length; i++) cnt[s.charCodeAt(i) - 97]++;
  for (let i = 0; i < s.length; i++) {
    if (cnt[s.charCodeAt(i) - 97] === 1) return i;
  }
  return -1;
}
```
