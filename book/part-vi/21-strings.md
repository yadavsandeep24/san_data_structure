# Chapter 21 — Strings — Patterns & Internals

## Mobile motivation

Almost every screen is text: search queries, usernames, chat bubbles, localized copy, deep-link paths. Interviews love **anagrams** and **palindromes**; production loves **not** accidentally copying megabyte strings on every keystroke, and **not** counting emoji as “one Character” incorrectly.

This chapter covers grouping anagrams, expand-around-center palindromes, concatenation cost, and the Swift / Dart / TypeScript pitfalls that bite real apps.

## Group anagrams

Two strings are **anagrams** if they contain the same characters with the same frequencies (`"eat"` / `"tea"` / `"ate"`).

**Approach:** map each word to a **canonical key**, then bucket words by key.

| Key choice | How | Notes |
|------------|-----|-------|
| Sorted characters | `eat` → `"aet"` | Simple; O(k log k) per word of length k |
| Frequency signature | 26-count tuple / string | O(k) for lowercase a–z |

```text
map: key → list of words
for w in words:
  key = sorted(w)   // or count signature
  map[key].append(w)
return map.values
```

Time O(n · k log k) with sort keys, or O(n · k) with counts; space O(n · k).

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
    if (!map.has(key)) map.set(key, []);
    map.get(key)!.push(s);
  }
  return [...map.values()];
}
```

**Valid anagram:** same idea with one pair — compare sorted forms or two frequency arrays.

**First unique character:** count frequencies, then scan left-to-right for the first char with count `1` (index or character).

## Longest palindromic substring — expand around center

A palindrome reads the same forward and backward. Every palindrome has a **center**: either a single character (`aba`) or a gap between two (`abba`).

```text
for each index i:
  expand odd:  center (i, i)
  expand even: center (i, i+1)
  track longest slice seen
```

Expand while `s[L] == s[R]` and bounds valid. Time O(n²), space O(1) aside from the answer string. Manacher’s algorithm is O(n) but rarely needed in mobile interviews.

### Expand helper (shared idea)

```kotlin
fun longestPalindrome(s: String): String {
    if (s.isEmpty()) return ""
    var start = 0
    var end = 0
    fun expand(l: Int, r: Int): Pair<Int, Int> {
        var left = l
        var right = r
        while (left >= 0 && right < s.length && s[left] == s[right]) {
            left--; right++
        }
        return (left + 1) to (right - 1)
    }
    for (i in s.indices) {
        val (a, b) = expand(i, i)
        val (c, d) = expand(i, i + 1)
        if (b - a > end - start) { start = a; end = b }
        if (d - c > end - start) { start = c; end = d }
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
            L -= 1; R += 1
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

Indexing by UTF-16 code unit (Kotlin `String` / JS / Dart) is fine for interview ASCII; real emoji needs grapheme-aware APIs (below).

## StringBuilder and concatenation cost

Strings are often **immutable**. Building a result with `s = s + chunk` in a loop copies the growing prefix repeatedly → **O(n²)** time and heavy allocations — death on a chat log or JSON serializer on the main thread.

| Language | Prefer | Avoid in hot loops |
|----------|--------|---------------------|
| **Kotlin** | `StringBuilder` / `buildString { }` | `s += piece` in large loops |
| **Swift** | `String` is copy-on-write; still prefer reserved capacity / single join when huge | Blind `+=` of millions of tiny pieces without measuring |
| **Dart** | `StringBuffer` | `s = s + x` in tight loops |
| **TypeScript** | Array of parts + `join("")` | Repeated `s +=` on huge outputs (engines optimize some cases; don’t rely on it for megabyte builders) |

```kotlin
fun joinCsv(parts: List<String>): String = buildString {
    parts.forEachIndexed { i, p ->
        if (i > 0) append(',')
        append(p)
    }
}
```

```dart
String joinCsv(List<String> parts) {
  final buf = StringBuffer();
  for (var i = 0; i < parts.length; i++) {
    if (i > 0) buf.write(',');
    buf.write(parts[i]);
  }
  return buf.toString();
}
```

```typescript
function joinCsv(parts: string[]): string {
  return parts.join(",");
}
```

## Swift: Character vs String, grapheme clusters

Swift’s `Character` is an **extended grapheme cluster** — what a user thinks of as “one character.” A single `Character` may be multiple Unicode scalars (e.g. flag emoji = two regional indicators; family emoji with ZWJ sequences).

```swift
let flag = "🇺🇸"
flag.count           // 1  (one Character / grapheme)
flag.unicodeScalars.count  // 2
Array(flag.utf16).count    // 4  (UTF-16 code units)
```

| API | Counts |
|-----|--------|
| `string.count` | Grapheme clusters (`Character`s) |
| `unicodeScalars` | Unicode scalar values |
| `utf16` / `utf8` | Encoding units |

**Indexing:** `String` is not randomly accessible by `Int` index in O(1). Prefer `String.Index` or convert to `[Character]` when you need repeated random access (palindrome expand on ASCII interview input).

## Dart and TypeScript string notes

### Dart

- `String` is UTF-16; `s.length` is **UTF-16 code units**, not graphemes.
- `s[i]` / `s.codeUnitAt(i)` are code units — can split a surrogate pair.
- For user-perceived characters use `characters` package (`Characters(s)`).

```dart
import 'package:characters/characters.dart';

final s = '🇺🇸';
print(s.length);            // 4 (UTF-16 units for many flags)
print(s.characters.length); // 1
```

### TypeScript / JavaScript

- Strings are UTF-16 code unit sequences.
- `s.length` and `s[i]` are code-unit based.
- `[...s]` or `for...of` iterates **Unicode code points** (surrogate pairs held together), but **not** full grapheme clusters (flags / ZWJ still multi-code-point).

```typescript
const flag = "🇺🇸";
flag.length;           // 4
[...flag].length;      // 2  (two code points)
// grapheme: Intl.Segmenter when available
const seg = new Intl.Segmenter("en", { granularity: "grapheme" });
[...seg.segment(flag)].length; // 1
```

## Emoji counting pitfall

Product copy: “username max 20 characters.” If you use `length` / UTF-16 counts:

| Input | User sees | Bad `length` |
|-------|-----------|--------------|
| `🇺🇸` | 1 emoji | 2–4 units |
| `👨‍👩‍👧‍👦` | 1 emoji | many units |
| `é` (e + combining accent) | 1 letter | 2 scalars |

**Rule:** define “character” for product (grapheme vs code point vs byte) and use the matching API. Never use raw UTF-16 length for emoji-aware limits without documenting it.

## Complexity cheat sheet

| Problem | Typical time | Space |
|---------|--------------|-------|
| Group anagrams (sort key) | O(n k log k) | O(n k) |
| Valid anagram | O(k) | O(1) alphabet |
| First unique char | O(n) | O(alphabet) |
| Longest palindromic substring (expand) | O(n²) | O(1) |
| Naïve concat loop | O(n²) | O(n) |

## Common mistakes

1. Quadratic string concatenation when building large payloads.
2. Using `String.count` (Swift) vs `length` (JS/Dart) interchangeably across platforms.
3. Palindrome expand indexing into multi-unit emoji without a Character array policy.
4. Sorting anagram keys with locale-sensitive sort unexpectedly.
5. Assuming `[...str]` in JS counts emoji graphemes.

## Self-Check

**21.1** Why is a frequency signature sometimes better than sorting for anagram keys?

**21.2** How many centers does expand-around-center consider for a string of length n?

**21.3** Why can `s += chunk` in a loop be O(n²)?

**21.4** In Swift, what does `Character` represent relative to UTF-8 bytes?

**21.5** Why might `"🇺🇸".length` in JavaScript not equal 1?

*(Answers: Appendix D.)*

## Practice

1. **Group anagrams** — [solutions/ch21](../../solutions/ch21/README.md#p1-group-anagrams)
2. **Longest palindromic substring** — [solutions/ch21](../../solutions/ch21/README.md#p2-longest-palindromic-substring)
3. **Valid anagram / first unique character** — [solutions/ch21](../../solutions/ch21/README.md#p3-valid-anagram--first-unique-character)

Next: [Chapter 22 — Bits & Matrix](22-bits-matrix.md) — flags, XOR tricks, and grid DFS patterns.
