# Chapter 33 — Two Pointers, Sliding Window & Intervals (12-Day Plan Gap-Closer)

Part X fills the gaps between this book and a widely shared **12-day DSA plan** (120 standard problems). The plan's Day 3–4 problems that the book already covers stay where they are: Longest Substring Without Repeating Characters in the [Chapter 24 question bank](../part-vii/24-interview-questions.md), Sliding Window Maximum in [Chapter 6](../part-ii/06-queues-deques.md), Non-overlapping Intervals and Meeting Rooms in [Chapter 17](../part-v/17-greedy-thinking.md), and Trapping Rain Water and Merge / Insert Interval in the [Chapter 27 hard bank](../part-viii/27-hard-drill-bank.md). This chapter adds the **twelve two-pointer, sliding-window and interval problems** the book was missing.

Companion index: [`solutions/ch33/README.md`](../../solutions/ch33/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Plan days** | Day 3 (two pointers, sliding window): Q1–Q8 · Day 4 (windows, intervals): Q9–Q12 |
| **Time** | 20–30 minutes per problem; Q8 is a hard, allow 40 |
| **Speak first** | Brute force in one line, then the optimal idea and its **time/space** before code |
| **Languages** | Every problem shows **Kotlin, Swift, Dart, TypeScript** (Android, iOS, Flutter, React Native), same algorithm and names |
| **Window rule** | Say what the window keeps true, when it grows, and when it shrinks |
| **Mobile tell** | One sentence on where the pattern shows up in an app, only when it is real |

Q7 and Q10 are the same fixed-size window; do them back to back. Q6, Q8 and Q9 are the variable-size window; compare their shrink conditions.

---

## Q1. Valid Palindrome (Coupon Code Check)

**Topic:** Two pointers

**Plan day:** Day 3

**Statement**

Return whether a string reads the same forwards and backwards after lowercasing it and ignoring everything except ASCII letters and digits. An empty or all-punctuation string counts as a palindrome. Framing: a promo-code screen accepts codes typed with spaces and dashes.

**Approach**

Brute force: build the filtered lowercase string and compare it with its reverse, O(n) extra space. Optimal: pointers at both ends skip characters that do not count and compare the rest, O(1) space. Check the ASCII range on the **raw** character and lowercase `A`–`Z` by hand: a library lowercase first would turn the Kelvin sign (U+212A) into `k` or `İ` (U+0130) into `i` and let non-ASCII characters count.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun isPalindrome(s: String): Boolean {
    fun norm(c: Char): Char? = when (c) {
        in 'a'..'z', in '0'..'9' -> c
        in 'A'..'Z' -> c + ('a' - 'A')
        else -> null
    }
    var i = 0
    var j = s.length - 1
    while (i < j) {
        val a = norm(s[i])
        val b = norm(s[j])
        when {
            a == null -> i++
            b == null -> j--
            a != b -> return false
            else -> { i++; j-- }
        }
    }
    return true
}
```

### Swift

```swift
func isPalindrome(_ s: String) -> Bool {
    let b = Array(s.utf8)
    func norm(_ c: UInt8) -> UInt8? {
        switch c {
        case UInt8(ascii: "a")...UInt8(ascii: "z"), UInt8(ascii: "0")...UInt8(ascii: "9"): return c
        case UInt8(ascii: "A")...UInt8(ascii: "Z"): return c + 32
        default: return nil
        }
    }
    var i = 0
    var j = b.count - 1
    while i < j {
        guard let x = norm(b[i]) else { i += 1; continue }
        guard let y = norm(b[j]) else { j -= 1; continue }
        if x != y { return false }
        i += 1
        j -= 1
    }
    return true
}
```

### Dart

```dart
bool isPalindrome(String s) {
  int? norm(int c) {
    if ((c >= 0x61 && c <= 0x7a) || (c >= 0x30 && c <= 0x39)) return c;
    if (c >= 0x41 && c <= 0x5a) return c + 0x20;
    return null;
  }

  var i = 0;
  var j = s.length - 1;
  while (i < j) {
    final a = norm(s.codeUnitAt(i));
    final b = norm(s.codeUnitAt(j));
    if (a == null) {
      i++;
    } else if (b == null) {
      j--;
    } else if (a != b) {
      return false;
    } else {
      i++;
      j--;
    }
  }
  return true;
}
```

### TypeScript

```typescript
function isPalindrome(s: string): boolean {
  const norm = (c: string): string | null => {
    if ((c >= "a" && c <= "z") || (c >= "0" && c <= "9")) return c;
    if (c >= "A" && c <= "Z") return String.fromCharCode(c.charCodeAt(0) + 32);
    return null;
  };
  let i = 0;
  let j = s.length - 1;
  while (i < j) {
    const a = norm(s[i]);
    const b = norm(s[j]);
    if (a === null) i++;
    else if (b === null) j--;
    else if (a !== b) return false;
    else {
      i++;
      j--;
    }
  }
  return true;
}
```

---

## Q2. Two Sum II — Input Array Is Sorted (Sorted Price Pair)

**Topic:** Two pointers

**Plan day:** Day 3

**Statement**

Given an array sorted in non-decreasing order and a target, return the **1-based** indices `[i, j]` with `i < j` of two elements that sum to the target, using O(1) extra space. Return an empty array if there is none. Framing: from a sorted price list, find two items that exactly use up a gift card.

**Approach**

Brute force: all pairs, O(n²); or binary search for the complement, O(n log n). Optimal: start at both ends. If the sum is too small, move the left pointer right; if too large, move the right pointer left. Each move rules out one element for good. Add as `Long` so two large values cannot overflow.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun twoSumSorted(numbers: IntArray, target: Int): IntArray {
    var i = 0
    var j = numbers.size - 1
    while (i < j) {
        val sum = numbers[i].toLong() + numbers[j]
        when {
            sum == target.toLong() -> return intArrayOf(i + 1, j + 1)
            sum < target -> i++
            else -> j--
        }
    }
    return intArrayOf()
}
```

### Swift

```swift
func twoSumSorted(_ numbers: [Int], _ target: Int) -> [Int] {
    var i = 0
    var j = numbers.count - 1
    while i < j {
        let sum = numbers[i] + numbers[j]
        if sum == target { return [i + 1, j + 1] }
        if sum < target { i += 1 } else { j -= 1 }
    }
    return []
}
```

### Dart

```dart
List<int> twoSumSorted(List<int> numbers, int target) {
  var i = 0;
  var j = numbers.length - 1;
  while (i < j) {
    final sum = numbers[i] + numbers[j];
    if (sum == target) return [i + 1, j + 1];
    if (sum < target) {
      i++;
    } else {
      j--;
    }
  }
  return [];
}
```

### TypeScript

```typescript
function twoSumSorted(numbers: number[], target: number): number[] {
  let i = 0;
  let j = numbers.length - 1;
  while (i < j) {
    const sum = numbers[i] + numbers[j];
    if (sum === target) return [i + 1, j + 1];
    if (sum < target) i++;
    else j--;
  }
  return [];
}
```

---

## Q3. 3Sum (Zero-Net Settlement Triples)

**Topic:** Sort + two pointers

**Plan day:** Day 3

**Statement**

Return every **distinct** triple of values `[a, b, c]` from the array (different positions) with `a + b + c = 0`. No triple may appear twice. Framing: among ledger adjustments, find groups of three that cancel out exactly.

**Approach**

Brute force: three nested loops plus a set of sorted triples, O(n³). Optimal: sort, fix the first value `a[i]` (skip it if equal to the previous one), then run Two Sum II on the rest. After a hit, move both pointers and skip repeated left values. Stop once `a[i] > 0`.

**Complexity:** Time O(n²), Space O(1) extra besides the sorted copy and output

### Kotlin

```kotlin
fun threeSum(nums: IntArray): List<List<Int>> {
    val a = nums.sorted()
    val out = mutableListOf<List<Int>>()
    for (i in a.indices) {
        if (a[i] > 0) break
        if (i > 0 && a[i] == a[i - 1]) continue
        var lo = i + 1
        var hi = a.size - 1
        while (lo < hi) {
            val sum = a[i].toLong() + a[lo] + a[hi]
            when {
                sum < 0 -> lo++
                sum > 0 -> hi--
                else -> {
                    out.add(listOf(a[i], a[lo], a[hi]))
                    lo++
                    hi--
                    while (lo < hi && a[lo] == a[lo - 1]) lo++
                }
            }
        }
    }
    return out
}
```

### Swift

```swift
func threeSum(_ nums: [Int]) -> [[Int]] {
    let a = nums.sorted()
    var out: [[Int]] = []
    for i in 0..<a.count {
        if a[i] > 0 { break }
        if i > 0 && a[i] == a[i - 1] { continue }
        var lo = i + 1, hi = a.count - 1
        while lo < hi {
            let sum = a[i] + a[lo] + a[hi]
            if sum < 0 { lo += 1 }
            else if sum > 0 { hi -= 1 }
            else {
                out.append([a[i], a[lo], a[hi]])
                lo += 1
                hi -= 1
                while lo < hi && a[lo] == a[lo - 1] { lo += 1 }
            }
        }
    }
    return out
}
```

### Dart

```dart
List<List<int>> threeSum(List<int> nums) {
  final a = List<int>.of(nums)..sort();
  final out = <List<int>>[];
  for (var i = 0; i < a.length; i++) {
    if (a[i] > 0) break;
    if (i > 0 && a[i] == a[i - 1]) continue;
    var lo = i + 1, hi = a.length - 1;
    while (lo < hi) {
      final sum = a[i] + a[lo] + a[hi];
      if (sum < 0) {
        lo++;
      } else if (sum > 0) {
        hi--;
      } else {
        out.add([a[i], a[lo], a[hi]]);
        lo++;
        hi--;
        while (lo < hi && a[lo] == a[lo - 1]) lo++;
      }
    }
  }
  return out;
}
```

### TypeScript

```typescript
function threeSum(nums: number[]): number[][] {
  const a = [...nums].sort((x, y) => x - y);
  const out: number[][] = [];
  for (let i = 0; i < a.length; i++) {
    if (a[i] > 0) break;
    if (i > 0 && a[i] === a[i - 1]) continue;
    let lo = i + 1;
    let hi = a.length - 1;
    while (lo < hi) {
      const sum = a[i] + a[lo] + a[hi];
      if (sum < 0) lo++;
      else if (sum > 0) hi--;
      else {
        out.push([a[i], a[lo], a[hi]]);
        lo++;
        hi--;
        while (lo < hi && a[lo] === a[lo - 1]) lo++;
      }
    }
  }
  return out;
}
```

---

## Q4. Container With Most Water (Widest Chart Band)

**Topic:** Two pointers (greedy)

**Plan day:** Day 3

**Statement**

`height[i]` is a vertical line at `x = i`. Pick two lines that, with the x-axis, hold the most water; return that area, `(j − i) × min(height[i], height[j])`. Framing: pick two bars of a bar chart that frame the largest rectangle behind them.

**Approach**

Brute force: all pairs, O(n²). Optimal: start with the widest pair. The shorter line limits the area, and moving the taller one inward can only shrink the width without raising that limit, so always move the **shorter** side.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun maxArea(height: IntArray): Int {
    var i = 0
    var j = height.size - 1
    var best = 0
    while (i < j) {
        best = maxOf(best, (j - i) * minOf(height[i], height[j]))
        if (height[i] < height[j]) i++ else j--
    }
    return best
}
```

### Swift

```swift
func maxArea(_ height: [Int]) -> Int {
    var i = 0
    var j = height.count - 1
    var best = 0
    while i < j {
        best = max(best, (j - i) * min(height[i], height[j]))
        if height[i] < height[j] { i += 1 } else { j -= 1 }
    }
    return best
}
```

### Dart

```dart
import 'dart:math';

int maxArea(List<int> height) {
  var i = 0;
  var j = height.length - 1;
  var best = 0;
  while (i < j) {
    best = max(best, (j - i) * min(height[i], height[j]));
    if (height[i] < height[j]) {
      i++;
    } else {
      j--;
    }
  }
  return best;
}
```

### TypeScript

```typescript
function maxArea(height: number[]): number {
  let i = 0;
  let j = height.length - 1;
  let best = 0;
  while (i < j) {
    best = Math.max(best, (j - i) * Math.min(height[i], height[j]));
    if (height[i] < height[j]) i++;
    else j--;
  }
  return best;
}
```

---

## Q5. Best Time to Buy and Sell Stock (One-Trade Profit)

**Topic:** Running minimum

**Plan day:** Day 3

**Statement**

`prices[i]` is the price on day `i`. Buy once and sell once on a later day; return the maximum profit, or 0 if no trade makes money. Framing: a portfolio screen's "best possible single trade" badge.

**Approach**

Brute force: every buy/sell pair, O(n²). Optimal: walk once, tracking the lowest price so far; each day's best sale is `price − minSoFar`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun maxProfit(prices: IntArray): Int {
    var minSoFar = Int.MAX_VALUE
    var best = 0
    for (p in prices) {
        if (p < minSoFar) minSoFar = p
        else best = maxOf(best, p - minSoFar)
    }
    return best
}
```

### Swift

```swift
func maxProfit(_ prices: [Int]) -> Int {
    var minSoFar = Int.max
    var best = 0
    for p in prices {
        if p < minSoFar { minSoFar = p } else { best = max(best, p - minSoFar) }
    }
    return best
}
```

### Dart

```dart
import 'dart:math';

int maxProfit(List<int> prices) {
  int? minSoFar;
  var best = 0;
  for (final p in prices) {
    if (minSoFar == null || p < minSoFar) {
      minSoFar = p;
    } else {
      best = max(best, p - minSoFar);
    }
  }
  return best;
}
```

### TypeScript

```typescript
function maxProfit(prices: number[]): number {
  let minSoFar = Infinity;
  let best = 0;
  for (const p of prices) {
    if (p < minSoFar) minSoFar = p;
    else best = Math.max(best, p - minSoFar);
  }
  return best;
}
```

**Mobile note:** For a live price stream, keep `minSoFar` and `best` as state and update them per tick in O(1); never rescan the history.

---

## Q6. Longest Repeating Character Replacement (Fix k Typos in a Streak)

**Topic:** Sliding window (variable)

**Plan day:** Day 3

**Statement**

Given an uppercase string `s` and an integer `k`, you may change at most `k` characters. Return the length of the longest substring that can be made of a single repeated letter. Framing: the longest stretch of a status trace that is "all OK" if you allow `k` glitches.

**Approach**

Brute force: every substring, check `length − mostFrequent ≤ k`, O(n²·26). Optimal: grow the window to the right, counting letters and keeping `maxFreq`. While `windowLength − maxFreq > k`, shrink from the left. `maxFreq` is never lowered on a shrink; that is safe because only a larger `maxFreq` can produce a longer answer.

**Complexity:** Time O(n), Space O(26)

### Kotlin

```kotlin
fun characterReplacement(s: String, k: Int): Int {
    val count = IntArray(26)
    var left = 0
    var maxFreq = 0
    var best = 0
    for (right in s.indices) {
        maxFreq = maxOf(maxFreq, ++count[s[right] - 'A'])
        while (right - left + 1 - maxFreq > k) {
            count[s[left] - 'A']--
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
```

### Swift

```swift
func characterReplacement(_ s: String, _ k: Int) -> Int {
    let b = Array(s.utf8)
    var count = [Int](repeating: 0, count: 26)
    var left = 0
    var maxFreq = 0
    var best = 0
    for right in 0..<b.count {
        let c = Int(b[right] - UInt8(ascii: "A"))
        count[c] += 1
        maxFreq = max(maxFreq, count[c])
        while right - left + 1 - maxFreq > k {
            count[Int(b[left] - UInt8(ascii: "A"))] -= 1
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
```

### Dart

```dart
import 'dart:math';

int characterReplacement(String s, int k) {
  final count = List<int>.filled(26, 0);
  var left = 0;
  var maxFreq = 0;
  var best = 0;
  for (var right = 0; right < s.length; right++) {
    maxFreq = max(maxFreq, ++count[s.codeUnitAt(right) - 65]);
    while (right - left + 1 - maxFreq > k) {
      count[s.codeUnitAt(left) - 65]--;
      left++;
    }
    best = max(best, right - left + 1);
  }
  return best;
}
```

### TypeScript

```typescript
function characterReplacement(s: string, k: number): number {
  const count = new Array<number>(26).fill(0);
  let left = 0;
  let maxFreq = 0;
  let best = 0;
  for (let right = 0; right < s.length; right++) {
    maxFreq = Math.max(maxFreq, ++count[s.charCodeAt(right) - 65]);
    while (right - left + 1 - maxFreq > k) {
      count[s.charCodeAt(left) - 65]--;
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}
```

---

## Q7. Permutation in String (Scrambled Code Search)

**Topic:** Sliding window (fixed size)

**Plan day:** Day 3

**Statement**

Given lowercase strings `s1` and `s2`, return whether some substring of `s2` is a permutation of `s1`. Framing: check whether a pasted SMS contains the OTP's characters in any order.

**Approach**

Brute force: sort every window of length `|s1|` and compare, O(n·m log m). Optimal: a window of fixed length `|s1|` slides over `s2` with a `need` count and a `missing` counter. Adding a character that was still needed lowers `missing`; removing one that becomes needed again raises it. `missing == 0` means a match.

**Complexity:** Time O(|s2|), Space O(26)

### Kotlin

```kotlin
fun checkInclusion(s1: String, s2: String): Boolean {
    if (s1.length > s2.length) return false
    val need = IntArray(26)
    for (c in s1) need[c - 'a']++
    var missing = s1.length
    for (i in s2.indices) {
        if (need[s2[i] - 'a']-- > 0) missing--
        if (i >= s1.length && ++need[s2[i - s1.length] - 'a'] > 0) missing++
        if (missing == 0) return true
    }
    return false
}
```

### Swift

```swift
func checkInclusion(_ s1: String, _ s2: String) -> Bool {
    let p = Array(s1.utf8), s = Array(s2.utf8)
    if p.count > s.count { return false }
    let a = UInt8(ascii: "a")
    var need = [Int](repeating: 0, count: 26)
    for c in p { need[Int(c - a)] += 1 }
    var missing = p.count
    for i in 0..<s.count {
        if need[Int(s[i] - a)] > 0 { missing -= 1 }
        need[Int(s[i] - a)] -= 1
        if i >= p.count {
            need[Int(s[i - p.count] - a)] += 1
            if need[Int(s[i - p.count] - a)] > 0 { missing += 1 }
        }
        if missing == 0 { return true }
    }
    return false
}
```

### Dart

```dart
bool checkInclusion(String s1, String s2) {
  if (s1.length > s2.length) return false;
  final need = List<int>.filled(26, 0);
  for (final c in s1.codeUnits) {
    need[c - 97]++;
  }
  var missing = s1.length;
  for (var i = 0; i < s2.length; i++) {
    if (need[s2.codeUnitAt(i) - 97]-- > 0) missing--;
    if (i >= s1.length && ++need[s2.codeUnitAt(i - s1.length) - 97] > 0) missing++;
    if (missing == 0) return true;
  }
  return false;
}
```

### TypeScript

```typescript
function checkInclusion(s1: string, s2: string): boolean {
  if (s1.length > s2.length) return false;
  const need = new Array<number>(26).fill(0);
  for (const c of s1) need[c.charCodeAt(0) - 97]++;
  let missing = s1.length;
  for (let i = 0; i < s2.length; i++) {
    if (need[s2.charCodeAt(i) - 97]-- > 0) missing--;
    if (i >= s1.length && ++need[s2.charCodeAt(i - s1.length) - 97] > 0) missing++;
    if (missing === 0) return true;
  }
  return false;
}
```

---

## Q8. Minimum Window Substring (Shortest Log Span Covering All Events)

**Topic:** Sliding window (variable, hard)

**Plan day:** Day 3

**Statement**

Given strings `s` and `t` (ASCII), return the shortest substring of `s` that contains every character of `t`, counting duplicates. Return `""` if there is none. Framing: each character is an event code in a session log; find the shortest span in which all the required events of a checkout funnel occurred.

**Approach**

Brute force: check every substring against `t`'s counts, O(n²) windows. Optimal: grow the window to the right, lowering `missing` when a needed character arrives. Once `missing == 0`, record the window and shrink from the left until a needed character leaves. Each pointer moves at most `n` times.

**Complexity:** Time O(|s| + |t|), Space O(128)

### Kotlin

```kotlin
fun minWindow(s: String, t: String): String {
    if (t.isEmpty() || t.length > s.length) return ""
    val need = IntArray(128)
    for (c in t) need[c.code]++
    var missing = t.length
    var left = 0
    var bestStart = 0
    var bestLen = Int.MAX_VALUE
    for (right in s.indices) {
        if (need[s[right].code]-- > 0) missing--
        while (missing == 0) {
            if (right - left + 1 < bestLen) {
                bestLen = right - left + 1
                bestStart = left
            }
            if (++need[s[left].code] > 0) missing++
            left++
        }
    }
    return if (bestLen == Int.MAX_VALUE) "" else s.substring(bestStart, bestStart + bestLen)
}
```

### Swift

```swift
func minWindow(_ s: String, _ t: String) -> String {
    let sa = Array(s.utf8), ta = Array(t.utf8)
    if ta.isEmpty || ta.count > sa.count { return "" }
    var need = [Int](repeating: 0, count: 256)
    for c in ta { need[Int(c)] += 1 }
    var missing = ta.count
    var left = 0, bestStart = 0, bestLen = Int.max
    for right in 0..<sa.count {
        if need[Int(sa[right])] > 0 { missing -= 1 }
        need[Int(sa[right])] -= 1
        while missing == 0 {
            if right - left + 1 < bestLen {
                bestLen = right - left + 1
                bestStart = left
            }
            need[Int(sa[left])] += 1
            if need[Int(sa[left])] > 0 { missing += 1 }
            left += 1
        }
    }
    if bestLen == Int.max { return "" }
    return String(decoding: sa[bestStart..<bestStart + bestLen], as: UTF8.self)
}
```

### Dart

```dart
String minWindow(String s, String t) {
  if (t.isEmpty || t.length > s.length) return '';
  final need = List<int>.filled(65536, 0);
  for (final c in t.codeUnits) need[c]++;
  var missing = t.length;
  var left = 0, bestStart = 0, bestLen = -1;
  for (var right = 0; right < s.length; right++) {
    if (need[s.codeUnitAt(right)]-- > 0) missing--;
    while (missing == 0) {
      if (bestLen == -1 || right - left + 1 < bestLen) {
        bestLen = right - left + 1;
        bestStart = left;
      }
      if (++need[s.codeUnitAt(left)] > 0) missing++;
      left++;
    }
  }
  return bestLen == -1 ? '' : s.substring(bestStart, bestStart + bestLen);
}
```

### TypeScript

```typescript
function minWindow(s: string, t: string): string {
  if (t.length === 0 || t.length > s.length) return "";
  const need = new Array<number>(128).fill(0);
  for (const c of t) need[c.charCodeAt(0)]++;
  let missing = t.length;
  let left = 0;
  let bestStart = 0;
  let bestLen = Infinity;
  for (let right = 0; right < s.length; right++) {
    if (need[s.charCodeAt(right)]-- > 0) missing--;
    while (missing === 0) {
      if (right - left + 1 < bestLen) {
        bestLen = right - left + 1;
        bestStart = left;
      }
      if (++need[s.charCodeAt(left)] > 0) missing++;
      left++;
    }
  }
  return bestLen === Infinity ? "" : s.slice(bestStart, bestStart + bestLen);
}
```

---

## Q9. Minimum Size Subarray Sum (Shortest Run to Reach a Spend Goal)

**Topic:** Sliding window (variable)

**Plan day:** Day 4

**Statement**

Given **positive** integers `nums` and a positive `target`, return the length of the shortest contiguous subarray whose sum is at least `target`, or 0 if none. Framing: the fewest consecutive days of spending that reach a rewards threshold.

**Approach**

Brute force: every subarray with a running sum, O(n²). Optimal: grow right, adding to `sum`; while `sum ≥ target`, record the length and shrink from the left. This works only because all values are positive: shrinking always lowers the sum. With negatives you need prefix sums and a monotonic deque. Keep `sum` as `Long`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun minSubArrayLen(target: Int, nums: IntArray): Int {
    var left = 0
    var sum = 0L
    var best = Int.MAX_VALUE
    for (right in nums.indices) {
        sum += nums[right]
        while (sum >= target) {
            best = minOf(best, right - left + 1)
            sum -= nums[left++]
        }
    }
    return if (best == Int.MAX_VALUE) 0 else best
}
```

### Swift

```swift
func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
    var left = 0
    var sum = 0
    var best = Int.max
    for right in 0..<nums.count {
        sum += nums[right]
        while sum >= target {
            best = min(best, right - left + 1)
            sum -= nums[left]
            left += 1
        }
    }
    return best == Int.max ? 0 : best
}
```

### Dart

```dart
import 'dart:math';

int minSubArrayLen(int target, List<int> nums) {
  var left = 0;
  var sum = 0;
  int? best;
  for (var right = 0; right < nums.length; right++) {
    sum += nums[right];
    while (sum >= target) {
      best = min(best ?? right - left + 1, right - left + 1);
      sum -= nums[left++];
    }
  }
  return best ?? 0;
}
```

### TypeScript

```typescript
function minSubArrayLen(target: number, nums: number[]): number {
  let left = 0;
  let sum = 0;
  let best = Infinity;
  for (let right = 0; right < nums.length; right++) {
    sum += nums[right];
    while (sum >= target) {
      best = Math.min(best, right - left + 1);
      sum -= nums[left++];
    }
  }
  return best === Infinity ? 0 : best;
}
```

---

## Q10. Find All Anagrams in a String (Every Scrambled Match)

**Topic:** Sliding window (fixed size)

**Plan day:** Day 4

**Statement**

Given lowercase strings `s` and `p`, return the start indices of every substring of `s` that is an anagram of `p`, in increasing order. Framing: highlight every place in a message where a scrambled keyword appears.

**Approach**

Brute force: sort each window and compare, O(n·m log m). Optimal: the Q7 window, but record `i − |p| + 1` every time `missing == 0` instead of returning.

**Complexity:** Time O(|s|), Space O(26) besides the output

### Kotlin

```kotlin
fun findAnagrams(s: String, p: String): List<Int> {
    val out = mutableListOf<Int>()
    if (p.length > s.length) return out
    val need = IntArray(26)
    for (c in p) need[c - 'a']++
    var missing = p.length
    for (i in s.indices) {
        if (need[s[i] - 'a']-- > 0) missing--
        if (i >= p.length && ++need[s[i - p.length] - 'a'] > 0) missing++
        if (missing == 0) out.add(i - p.length + 1)
    }
    return out
}
```

### Swift

```swift
func findAnagrams(_ s: String, _ p: String) -> [Int] {
    let sb = Array(s.utf8), pb = Array(p.utf8)
    var out: [Int] = []
    if pb.count > sb.count { return out }
    let a = UInt8(ascii: "a")
    var need = [Int](repeating: 0, count: 26)
    for c in pb { need[Int(c - a)] += 1 }
    var missing = pb.count
    for i in 0..<sb.count {
        if need[Int(sb[i] - a)] > 0 { missing -= 1 }
        need[Int(sb[i] - a)] -= 1
        if i >= pb.count {
            need[Int(sb[i - pb.count] - a)] += 1
            if need[Int(sb[i - pb.count] - a)] > 0 { missing += 1 }
        }
        if missing == 0 { out.append(i - pb.count + 1) }
    }
    return out
}
```

### Dart

```dart
List<int> findAnagrams(String s, String p) {
  final out = <int>[];
  if (p.length > s.length) return out;
  final need = List<int>.filled(26, 0);
  for (final c in p.codeUnits) {
    need[c - 97]++;
  }
  var missing = p.length;
  for (var i = 0; i < s.length; i++) {
    if (need[s.codeUnitAt(i) - 97]-- > 0) missing--;
    if (i >= p.length && ++need[s.codeUnitAt(i - p.length) - 97] > 0) missing++;
    if (missing == 0) out.add(i - p.length + 1);
  }
  return out;
}
```

### TypeScript

```typescript
function findAnagrams(s: string, p: string): number[] {
  const out: number[] = [];
  if (p.length > s.length) return out;
  const need = new Array<number>(26).fill(0);
  for (const c of p) need[c.charCodeAt(0) - 97]++;
  let missing = p.length;
  for (let i = 0; i < s.length; i++) {
    if (need[s.charCodeAt(i) - 97]-- > 0) missing--;
    if (i >= p.length && ++need[s.charCodeAt(i - p.length) - 97] > 0) missing++;
    if (missing === 0) out.push(i - p.length + 1);
  }
  return out;
}
```

**Mobile note:** To highlight matches, turn the indices into spans: `SpannableString` with Views, `AnnotatedString` with Compose.

---

## Q11. Minimum Number of Arrows to Burst Balloons (Fewest Sync Ticks)

**Topic:** Intervals / greedy

**Plan day:** Day 4

**Statement**

Each balloon is a closed interval `[start, end]` on the x-axis. One arrow at `x` bursts every balloon with `start ≤ x ≤ end`. Return the minimum number of arrows that burst all balloons. Framing: each background job has a window in which it may run; find the fewest wake-ups that serve every job.

**Approach**

Brute force: try sets of positions, exponential. Optimal: sort by **end**. Shoot at the first end; every balloon starting at or before that point is burst. The first balloon that starts after it needs a new arrow at its own end. Compare values instead of subtracting them in the sort, so extreme `Int` values cannot overflow.

**Complexity:** Time O(n log n), Space O(n) for the sorted copy

### Kotlin

```kotlin
fun findMinArrowShots(points: Array<IntArray>): Int {
    if (points.isEmpty()) return 0
    val sorted = points.sortedBy { it[1] }
    var arrows = 1
    var arrowX = sorted[0][1]
    for (p in sorted) {
        if (p[0] > arrowX) {
            arrows++
            arrowX = p[1]
        }
    }
    return arrows
}
```

### Swift

```swift
func findMinArrowShots(_ points: [[Int]]) -> Int {
    let sorted = points.sorted { $0[1] < $1[1] }
    guard let first = sorted.first else { return 0 }
    var arrows = 1
    var arrowX = first[1]
    for p in sorted where p[0] > arrowX {
        arrows += 1
        arrowX = p[1]
    }
    return arrows
}
```

### Dart

```dart
int findMinArrowShots(List<List<int>> points) {
  if (points.isEmpty) return 0;
  final sorted = List<List<int>>.of(points)..sort((a, b) => a[1].compareTo(b[1]));
  var arrows = 1;
  var arrowX = sorted[0][1];
  for (final p in sorted) {
    if (p[0] > arrowX) {
      arrows++;
      arrowX = p[1];
    }
  }
  return arrows;
}
```

### TypeScript

```typescript
function findMinArrowShots(points: number[][]): number {
  if (points.length === 0) return 0;
  const sorted = [...points].sort((a, b) => (a[1] < b[1] ? -1 : a[1] > b[1] ? 1 : 0));
  let arrows = 1;
  let arrowX = sorted[0][1];
  for (const p of sorted) {
    if (p[0] > arrowX) {
      arrows++;
      arrowX = p[1];
    }
  }
  return arrows;
}
```

**Mobile note:** This is the reasoning behind batching work into shared windows (WorkManager on Android, `BGTaskScheduler` on iOS): fewer wake-ups save battery.

---

## Q12. Interval List Intersections (Shared Free Slots)

**Topic:** Intervals / two pointers

**Plan day:** Day 4

**Statement**

Two lists of closed intervals are each sorted and non-overlapping within themselves. Return their intersection as a sorted list of intervals. Framing: two people's free slots; show the times both are free when booking a call.

**Approach**

Brute force: compare every pair, O(m·n). Optimal: one pointer per list. The overlap of the current pair is `[max(starts), min(ends)]` if non-empty. Then advance the interval that **ends first**, because it cannot overlap anything later in the other list.

**Complexity:** Time O(m + n), Space O(1) besides the output

### Kotlin

```kotlin
fun intervalIntersection(a: Array<IntArray>, b: Array<IntArray>): List<IntArray> {
    val out = mutableListOf<IntArray>()
    var i = 0
    var j = 0
    while (i < a.size && j < b.size) {
        val lo = maxOf(a[i][0], b[j][0])
        val hi = minOf(a[i][1], b[j][1])
        if (lo <= hi) out.add(intArrayOf(lo, hi))
        if (a[i][1] < b[j][1]) i++ else j++
    }
    return out
}
```

### Swift

```swift
func intervalIntersection(_ a: [[Int]], _ b: [[Int]]) -> [[Int]] {
    var out: [[Int]] = []
    var i = 0, j = 0
    while i < a.count && j < b.count {
        let lo = max(a[i][0], b[j][0])
        let hi = min(a[i][1], b[j][1])
        if lo <= hi { out.append([lo, hi]) }
        if a[i][1] < b[j][1] { i += 1 } else { j += 1 }
    }
    return out
}
```

### Dart

```dart
import 'dart:math';

List<List<int>> intervalIntersection(List<List<int>> a, List<List<int>> b) {
  final out = <List<int>>[];
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    final lo = max(a[i][0], b[j][0]);
    final hi = min(a[i][1], b[j][1]);
    if (lo <= hi) out.add([lo, hi]);
    if (a[i][1] < b[j][1]) {
      i++;
    } else {
      j++;
    }
  }
  return out;
}
```

### TypeScript

```typescript
function intervalIntersection(a: number[][], b: number[][]): number[][] {
  const out: number[][] = [];
  let i = 0;
  let j = 0;
  while (i < a.length && j < b.length) {
    const lo = Math.max(a[i][0], b[j][0]);
    const hi = Math.min(a[i][1], b[j][1]);
    if (lo <= hi) out.push([lo, hi]);
    if (a[i][1] < b[j][1]) i++;
    else j++;
  }
  return out;
}
```

---

## Drill checklist (say aloud)

1. Brute force in one sentence, then the better idea.  
2. Complexity **before** code.  
3. Two pointers: what does each move rule out? Window: what stays true, when do you grow, when do you shrink?  
4. Intervals: sort by start or by end, and say why.  
5. Edges: empty, single, all equal, no answer, overflow in sums.

Previous: [Chapter 32 — Arrays, Hashing & Matrix](32-arrays-hashing-matrix.md) · Next: [Chapter 34 — Stacks & Binary Search](34-stacks-binary-search.md)
