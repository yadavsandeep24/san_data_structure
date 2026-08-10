# Chapter 7 — Model Solutions

## P1: Two Sum

### Approach

Scan once. Keep a map `value → index` of numbers already seen. For each `nums[i]`, look up `target - nums[i]`. If present, return those two indices; otherwise store `nums[i] → i`.

### Complexity

- Time: O(n)
- Space: O(n)

### Edge cases

- No solution — return empty / throw per API contract
- Duplicates (e.g. `2,7,2` target `4`) — map stores latest or earliest; ensure indices differ
- Negative numbers and zero — hash maps handle them fine
- Single element — no pair

### Mobile note

Same pattern as “find cart line for SKU” or “match transaction id in a local buffer” without nested loops on the main thread.

### Kotlin

```kotlin
fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for (i in nums.indices) {
        val need = target - nums[i]
        val j = seen[need]
        if (j != null) return intArrayOf(j, i)
        seen[nums[i]] = i
    }
    return intArrayOf()
}
```

### Swift

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (i, x) in nums.enumerated() {
        if let j = seen[target - x] { return [j, i] }
        seen[x] = i
    }
    return []
}
```

### Dart

```dart
List<int> twoSum(List<int> nums, int target) {
  final seen = <int, int>{};
  for (var i = 0; i < nums.length; i++) {
    final j = seen[target - nums[i]];
    if (j != null) return [j, i];
    seen[nums[i]] = i;
  }
  return [];
}
```

### TypeScript

```typescript
function twoSum(nums: number[], target: number): number[] {
  const seen = new Map<number, number>();
  for (let i = 0; i < nums.length; i++) {
    const j = seen.get(target - nums[i]);
    if (j !== undefined) return [j, i];
    seen.set(nums[i], i);
  }
  return [];
}
```

---

## P2: Group by key / frequency

### Approach (group anagrams)

For each string, build a frequency signature (sorted chars, or 26-count tuple) as the map key. Append the original string to `Map<signature, List>`. Emit the map values.

### Approach (frequency then group)

Count with `Map<T, Int>`, then invert or filter (e.g. all keys with count ≥ k).

### Complexity

- Group anagrams: O(n · L log L) with sorted keys, or O(n · L) with count signatures (L = max length)
- Space: O(n · L)

### Edge cases

- Empty strings — valid anagram group members
- Single group vs all unique
- Unicode — sorting code units may differ from user-perceived graphemes; for interviews stick to ASCII

### Mobile note

Grouping chat messages by `dayKey`, photos by `assetCollection`, or analytics events by `name` is the same `key → list` fold — do it once when the payload arrives, not inside `build()`.

### Kotlin — group anagrams

```kotlin
fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val key = s.toCharArray().sorted().joinToString("")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}

fun frequencyMap(items: List<String>): Map<String, Int> {
    val m = HashMap<String, Int>()
    for (x in items) m[x] = (m[x] ?: 0) + 1
    return m
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
    const key = [...s].sort().join('');
    const bucket = map.get(key);
    if (bucket) bucket.push(s);
    else map.set(key, [s]);
  }
  return [...map.values()];
}
```

---

## P3: First unique character

### Approach

Two passes: (1) build frequency map of characters; (2) scan the string in order and return the first index whose count is 1. One-pass variants store index + count, then scan the map for min index with count 1 — two-pass on the string is clearer.

### Complexity

- Time: O(n)
- Space: O(σ) alphabet size (O(1) if fixed ASCII/256)

### Edge cases

- All characters repeated → return -1
- Empty string → -1
- First char unique → index 0
- Case sensitivity — `'A'` ≠ `'a'` unless normalized

### Mobile note

Useful for “first undelivered unique notification type” style dedup keys; keep the frequency table tiny (enum / string codes), not full message bodies.

### Kotlin

```kotlin
fun firstUniqChar(s: String): Int {
    val freq = IntArray(26)
    for (c in s) freq[c - 'a']++
    for (i in s.indices) if (freq[s[i] - 'a'] == 1) return i
    return -1
}
```

### Swift

```swift
func firstUniqChar(_ s: String) -> Int {
    var freq = [Character: Int]()
    for c in s { freq[c, default: 0] += 1 }
    for (i, c) in s.enumerated() where freq[c] == 1 { return i }
    return -1
}
```

### Dart

```dart
int firstUniqChar(String s) {
  final runes = s.runes.toList();
  final freq = <int, int>{};
  for (final r in runes) {
    freq[r] = (freq[r] ?? 0) + 1;
  }
  for (var i = 0; i < runes.length; i++) {
    if (freq[runes[i]] == 1) return i;
  }
  return -1;
}
```

### TypeScript

```typescript
function firstUniqChar(s: string): number {
  const freq = new Map<string, number>();
  for (const c of s) freq.set(c, (freq.get(c) ?? 0) + 1);
  for (let i = 0; i < s.length; i++) {
    if (freq.get(s[i]) === 1) return i;
  }
  return -1;
}
```
