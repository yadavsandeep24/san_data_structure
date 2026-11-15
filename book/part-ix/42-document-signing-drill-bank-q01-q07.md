# Chapter 42 — Document & Signing Drill Bank — Q1–Q7

Part of [Chapter 42 — Document & Signing Drill Bank](42-document-signing-drill-bank.md). Read the overview first for the timing rules and strategy.

---

## Q1. Template Merge Fields (Envelope Email Body)

**Topic:** Strings / single-pass parsing

**Statement**

Envelope emails and documents hold placeholders like `Dear {{signer.firstName}}, sign by {{envelope.dueDate}}`. Write `render(template, values)`. Clarify first: a missing key keeps the placeholder by default (make it a parameter); `\{{` is a literal `{{`; an unclosed `{{` fails with its index; values are **not** rendered again.

**Approach**

Walk the string once with an index. On `\{{` emit `{{`. On `{{` find the next `}}`, trim the key, append the value (or `onMissing(key)`), jump past `}}`. Single pass means a signer named `{{envelope.secret}}` cannot inject another field. No regex, so no backtracking.

**Complexity:** Time O(n), Space O(n) for the output

### Kotlin

```kotlin
fun render(
    t: String,
    values: Map<String, String>,
    onMissing: (String) -> String = { "{{$it}}" },
): String {
    val sb = StringBuilder(t.length)
    var i = 0
    while (i < t.length) {
        when {
            t.startsWith("\\{{", i) -> { sb.append("{{"); i += 3 }
            t.startsWith("{{", i) -> {
                val end = t.indexOf("}}", i + 2)
                require(end != -1) { "Unclosed field at index $i" }
                val key = t.substring(i + 2, end).trim()
                sb.append(values[key] ?: onMissing(key))
                i = end + 2
            }
            else -> { sb.append(t[i]); i++ }
        }
    }
    return sb.toString()
}
```

### Swift

```swift
struct TemplateError: Error { let message: String }

func render(
    _ t: String,
    _ values: [String: String],
    onMissing: (String) -> String = { "{{\($0)}}" }
) throws -> String {
    let c = Array(t)
    func startsWith(_ p: String, at i: Int) -> Bool {
        let p = Array(p)
        return i + p.count <= c.count && Array(c[i..<i + p.count]) == p
    }
    var out = ""
    var i = 0
    while i < c.count {
        if startsWith("\\{{", at: i) {
            out += "{{"; i += 3
        } else if startsWith("{{", at: i) {
            var end = i + 2
            while end < c.count && !startsWith("}}", at: end) { end += 1 }
            guard end < c.count else { throw TemplateError(message: "Unclosed field at index \(i)") }
            let key = String(c[(i + 2)..<end].drop(while: \.isWhitespace).reversed().drop(while: \.isWhitespace).reversed())
            out += values[key] ?? onMissing(key)
            i = end + 2
        } else {
            out.append(c[i]); i += 1
        }
    }
    return out
}
```

### Dart

```dart
String render(
  String t,
  Map<String, String> values, {
  String Function(String key)? onMissing,
}) {
  final missing = onMissing ?? (k) => '{{$k}}';
  final sb = StringBuffer();
  var i = 0;
  while (i < t.length) {
    if (t.startsWith(r'\{{', i)) {
      sb.write('{{');
      i += 3;
    } else if (t.startsWith('{{', i)) {
      final end = t.indexOf('}}', i + 2);
      if (end == -1) throw FormatException('Unclosed field at index $i');
      final key = t.substring(i + 2, end).trim();
      sb.write(values[key] ?? missing(key));
      i = end + 2;
    } else {
      sb.write(t[i]);
      i++;
    }
  }
  return sb.toString();
}
```

### TypeScript

```typescript
function render(
  t: string,
  values: Record<string, string>,
  onMissing: (key: string) => string = (k) => `{{${k}}}`,
): string {
  let out = "";
  let i = 0;
  while (i < t.length) {
    if (t.startsWith("\\{{", i)) {
      out += "{{";
      i += 3;
    } else if (t.startsWith("{{", i)) {
      const end = t.indexOf("}}", i + 2);
      if (end === -1) throw new Error(`Unclosed field at index ${i}`);
      const key = t.substring(i + 2, end).trim();
      out += Object.hasOwn(values, key) ? values[key] : onMissing(key);
      i = end + 2;
    } else {
      out += t[i];
      i++;
    }
  }
  return out;
}
```

**Think bigger:** the same engine fills email, SMS, push and PDF fields, so pass an escaper (HTML-escape for email, none for a PDF field). Render on the server to keep PII off the device; render on the client only for offline previews.

---

## Q2. Normalize Signer Names (Duplicate Recipients)

**Topic:** Strings / hashing (canonical key)

**Statement**

Two signer entries are the same person if they match ignoring case, extra spaces, accents and "Last, First" order. Group a list of names into duplicate sets so the sender sees "Jane Doe is added twice".

**Approach**

Build a canonical key: Unicode NFD, drop combining marks (`José` → `Jose`), lowercase, split on spaces and commas, sort tokens, join. Group by key; keep groups of size > 1.

**Complexity:** Time O(n · k log k) for k tokens per name, Space O(n)

### Kotlin

```kotlin
import java.text.Normalizer

private val marks = Regex("\\p{Mn}+")
private val separators = Regex("[\\s,]+")

fun canonical(name: String): String =
    Normalizer.normalize(name, Normalizer.Form.NFD)
        .replace(marks, "")            // José -> Jose
        .lowercase()
        .split(separators)
        .filter { it.isNotEmpty() }
        .sorted()                       // "Doe, Jane" == "Jane Doe"
        .joinToString(" ")

fun duplicateGroups(names: List<String>): List<List<String>> =
    names.groupBy(::canonical).values.filter { it.size > 1 }
```

### Swift

```swift
import Foundation

func canonical(_ name: String) -> String {
    let stripped = String(String.UnicodeScalarView(
        name.decomposedStringWithCanonicalMapping.unicodeScalars
            .filter { $0.properties.generalCategory != .nonspacingMark }   // José -> Jose
    ))
    return stripped.lowercased()
        .split(whereSeparator: { $0.isWhitespace || $0 == "," })
        .map(String.init)
        .sorted()                                                          // "Doe, Jane" == "Jane Doe"
        .joined(separator: " ")
}

func duplicateGroups(_ names: [String]) -> [[String]] {
    var order: [String] = []
    var groups: [String: [String]] = [:]
    for n in names {
        let key = canonical(n)
        if groups[key] == nil { order.append(key) }
        groups[key, default: []].append(n)
    }
    return order.compactMap { groups[$0] }.filter { $0.count > 1 }
}
```

### Dart

```dart
// Dart core has no Unicode normalization; fold common Latin accents by table.
// For full NFD use package:unorm_dart.
const _accents = 'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖòóôõöÙÚÛÜùúûüÑñÇçÝýÿ';
const _plain = 'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuNnCcYyy';

String _fold(String s) {
  final sb = StringBuffer();
  for (final ch in s.split('')) {
    final i = _accents.indexOf(ch);
    sb.write(i == -1 ? ch : _plain[i]); // José -> Jose
  }
  return sb.toString();
}

final _separators = RegExp(r'[\s,]+');

String canonical(String name) {
  final tokens = _fold(name).toLowerCase().split(_separators).where((t) => t.isNotEmpty).toList()
    ..sort(); // "Doe, Jane" == "Jane Doe"
  return tokens.join(' ');
}

List<List<String>> duplicateGroups(List<String> names) {
  final groups = <String, List<String>>{}; // insertion-ordered
  for (final n in names) {
    groups.putIfAbsent(canonical(n), () => []).add(n);
  }
  return groups.values.where((g) => g.length > 1).toList();
}
```

### TypeScript

```typescript
function canonical(name: string): string {
  return name
    .normalize("NFD")
    .replace(/\p{Mn}+/gu, "") // José -> Jose
    .toLowerCase()
    .split(/[\s,]+/)
    .filter((s) => s.length > 0)
    .sort() // "Doe, Jane" == "Jane Doe"
    .join(" ");
}

function duplicateGroups(names: string[]): string[][] {
  const groups = new Map<string, string[]>();
  for (const n of names) {
    const key = canonical(n);
    const g = groups.get(key);
    if (g) g.push(n);
    else groups.set(key, [n]);
  }
  return [...groups.values()].filter((g) => g.length > 1);
}
```

**Say the trade-offs:** sorting tokens also merges "John Paul" with "Paul John". Kotlin's `lowercase()` is locale-invariant (the Turkish dotless-ı bug comes from Java's `toLowerCase()` with the default locale). Names are weak identity — match on verified email or phone and use the name only to suggest a merge.

---

## Q3. Redact PII Before Logging (Crash Reports)

**Topic:** Strings / regex

**Statement**

Before a crash report or log line leaves the device, mask emails (`jane.doe@acme.com` → `j***@acme.com`) and phone numbers (keep the last 4 digits). Write `redact(text)`.

**Approach**

Two regex passes. Emails run **first**, so the digits inside an address are not treated as a phone number. A phone match keeps only its digits: bullets for all but the last 4. Short numbers (PINs, amounts under 10 characters) are left alone.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
private val email = Regex("""[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}""")
private val phone = Regex("""\+?\d[\d\s-]{8,}\d""")

fun redact(text: String): String =
    text.replace(email) { m ->
        val v = m.value
        v.first() + "***" + v.substring(v.indexOf('@'))
    }.replace(phone) { m ->
        val digits = m.value.filter(Char::isDigit)
        "•".repeat((digits.length - 4).coerceAtLeast(0)) + digits.takeLast(4)
    }
```

### Swift

```swift
let email = #/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/#
let phone = #/\+?[0-9][0-9\s-]{8,}[0-9]/#

func redact(_ text: String) -> String {
    text.replacing(email) { m in
        let v = m.output
        guard let first = v.first, let at = v.firstIndex(of: "@") else { return String(v) }
        return "\(first)***" + v[at...]
    }.replacing(phone) { m in
        let digits = m.output.filter { $0.isASCII && $0.isNumber }
        return String(repeating: "•", count: max(0, digits.count - 4)) + digits.suffix(4)
    }
}
```

### Dart

```dart
final _email = RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}');
final _phone = RegExp(r'\+?\d[\d\s-]{8,}\d');

String redact(String text) => text
    .replaceAllMapped(_email, (m) {
      final v = m[0]!;
      return '${v[0]}***${v.substring(v.indexOf('@'))}';
    })
    .replaceAllMapped(_phone, (m) {
      final digits = m[0]!.replaceAll(RegExp(r'\D'), '');
      final n = digits.length;
      return '•' * (n - 4 < 0 ? 0 : n - 4) + digits.substring(n < 4 ? 0 : n - 4);
    });
```

### TypeScript

```typescript
const EMAIL = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g;
const PHONE = /\+?\d[\d\s-]{8,}\d/g;

function redact(text: string): string {
  return text
    .replace(EMAIL, (v) => v[0] + "***" + v.substring(v.indexOf("@")))
    .replace(PHONE, (m) => {
      const digits = m.replace(/\D/g, "");
      return "•".repeat(Math.max(0, digits.length - 4)) + digits.slice(-4);
    });
}
```

**Think bigger:** pattern-based redaction always misses something (names, addresses, document text). Prevent the leak at the source: wrap sensitive values in types like `@JvmInline value class Email(val raw: String)` whose `toString()` returns `Email(***)`, add a lint rule against logging raw values, and strip verbose logs in release builds with R8.

---

## Q4. Find the Bugs in This Function (Recent Completed Envelopes)

**Topic:** Debugging / code reading

**Statement**

This function should return the `n` most recently completed envelopes for the inbox, newest first. QA says it shows old envelopes, misses some, and sometimes crashes. Find every bug.

```kotlin
data class Envelope(val id: String, val status: String, val completedAt: Long?)

fun recentCompleted(all: List<Envelope>, n: Int): List<Envelope> {
    val done = all.filter { it.status == "Completed" }
    val sorted = done.sortedBy { it.completedAt }
    return sorted.subList(0, n)
}
```

**Approach**

Read line by line and ask "what input breaks this line?"

1. **Old envelopes:** `sortedBy` is oldest first → `sortedByDescending`.
2. **Misses some:** the status check is case-sensitive and the API sends `"completed"` too → `equals(..., ignoreCase = true)`, or better, parse to an enum at the API boundary.
3. **Crashes:** `subList(0, n)` throws when there are fewer than `n` items, and for negative `n` → `take(n)` plus an explicit `require(n >= 0)`.
4. **Quiet bug:** a completed envelope with a null `completedAt` is bad data; drop it on purpose (or log it). Also, `subList` returns a view of the original list.

Method out loud: reproduce with a failing test, form a hypothesis, make the smallest fix, keep the test.

**Complexity:** Time O(n log n), Space O(n)

### Kotlin

```kotlin
data class Envelope(val id: String, val status: String, val completedAt: Long?)

fun recentCompleted(all: List<Envelope>, n: Int): List<Envelope> {
    require(n >= 0) { "n must be non-negative, was $n" }
    return all.asSequence()
        .filter { it.status.equals("completed", ignoreCase = true) && it.completedAt != null }
        .sortedByDescending { it.completedAt }
        .take(n)
        .toList()
}
```

### Swift

```swift
struct Envelope { let id: String; let status: String; let completedAt: Int64? }

func recentCompleted(_ all: [Envelope], _ n: Int) -> [Envelope] {
    precondition(n >= 0, "n must be non-negative, was \(n)")
    return all.enumerated()
        .compactMap { (i, e) -> (Int, Int64, Envelope)? in
            guard e.status.lowercased() == "completed", let t = e.completedAt else { return nil }
            return (i, t, e)
        }
        .sorted { $0.1 != $1.1 ? $0.1 > $1.1 : $0.0 < $1.0 }   // newest first; ties keep input order
        .prefix(n)
        .map { $0.2 }
}
```

### Dart

```dart
class Envelope {
  final String id;
  final String status;
  final int? completedAt;
  const Envelope(this.id, this.status, this.completedAt);
}

List<Envelope> recentCompleted(List<Envelope> all, int n) {
  if (n < 0) throw ArgumentError.value(n, 'n', 'must be non-negative');
  final done = [
    for (var i = 0; i < all.length; i++)
      if (all[i].status.toLowerCase() == 'completed' && all[i].completedAt != null) (i, all[i]),
  ];
  // Dart's sort is not stable: break ties by input position.
  done.sort((a, b) {
    final c = b.$2.completedAt!.compareTo(a.$2.completedAt!);
    return c != 0 ? c : a.$1.compareTo(b.$1);
  });
  return done.take(n).map((p) => p.$2).toList();
}
```

### TypeScript

```typescript
type Envelope = { id: string; status: string; completedAt: number | null };

function recentCompleted(all: Envelope[], n: number): Envelope[] {
  if (!Number.isInteger(n) || n < 0) throw new RangeError(`n must be a non-negative integer, was ${n}`);
  return all
    .filter((e) => e.status.toLowerCase() === "completed" && e.completedAt !== null)
    .sort((a, b) => b.completedAt! - a.completedAt!) // newest first; sort is stable
    .slice(0, n);
}
```

**Lead-level follow-up:** "Where should the case bug really be fixed?" At the boundary: map the API string to a `Status` enum (with an `Unknown` value) in the data layer, so screens never compare raw strings. Fix the class of bug, not the one line.

---

## Q5. Text Editor with a Cursor (Note Field on a Form)

**Topic:** Two stacks / design

**Statement**

Design the editor behind a long text field on a document: `insert(text)`, `left(x)`, `right(x)`, `backspace(x)`, `delete(x)`, `print(x)`. Moving or editing must not cost O(document length). `print(x)` returns up to `x` characters left of the cursor; a too-large `x` is clamped, not an error.

Example: insert `"docusign"`, left(4) → `docu|sign`; insert `"-"` → `docu-|sign`; backspace(2) → `doc|sign`; delete(2) → `doc|gn`.

**Approach**

Simple version: one buffer plus a cursor index — every mid-text edit shifts the tail, O(n). Better: split the text at the cursor into two stacks. `left` ends at the cursor; `right` is stored **backwards**, so it also ends at the cursor. Every operation touches only stack ends. Clamp `x` every time.

**Complexity:** Insert O(length added); move / delete / print x chars O(x); nothing is O(document length)

### Kotlin

```kotlin
class TextEditor {
    private val left = StringBuilder()
    private val right = StringBuilder()   // stored backwards: its end is the cursor

    fun insert(text: String) {
        left.append(text)
    }

    fun left(x: Int) {
        repeat(minOf(x, left.length)) {
            right.append(left[left.length - 1]); left.setLength(left.length - 1)
        }
    }

    fun right(x: Int) {
        repeat(minOf(x, right.length)) {
            left.append(right[right.length - 1]); right.setLength(right.length - 1)
        }
    }

    fun backspace(x: Int): Int {
        val n = minOf(x, left.length)
        left.setLength(left.length - n)
        return n
    }

    fun delete(x: Int): Int {
        val n = minOf(x, right.length)
        right.setLength(right.length - n)
        return n
    }

    // Up to x characters immediately left of the cursor.
    fun print(x: Int): String = left.substring(maxOf(0, left.length - x))

    fun text(): String = left.toString() + right.reversed().toString()
}
```

### Swift

```swift
final class TextEditor {
    private var left: [Character] = []
    private var right: [Character] = []   // stored backwards: its end is the cursor

    func insert(_ text: String) { left.append(contentsOf: text) }

    func moveLeft(_ x: Int) {
        for _ in 0..<min(x, left.count) { right.append(left.removeLast()) }
    }

    func moveRight(_ x: Int) {
        for _ in 0..<min(x, right.count) { left.append(right.removeLast()) }
    }

    @discardableResult func backspace(_ x: Int) -> Int {
        let n = min(x, left.count)
        left.removeLast(n)
        return n
    }

    @discardableResult func delete(_ x: Int) -> Int {
        let n = min(x, right.count)
        right.removeLast(n)
        return n
    }

    // Up to x characters immediately left of the cursor.
    func print(_ x: Int) -> String { String(left.suffix(max(0, x))) }

    func text() -> String { String(left) + String(right.reversed()) }
}
```

### Dart

```dart
import 'dart:math';

class TextEditor {
  final List<String> _left = [];
  final List<String> _right = []; // stored backwards: its end is the cursor

  void insert(String text) => _left.addAll(text.split(''));

  void moveLeft(int x) {
    for (var k = min(x, _left.length); k > 0; k--) _right.add(_left.removeLast());
  }

  void moveRight(int x) {
    for (var k = min(x, _right.length); k > 0; k--) _left.add(_right.removeLast());
  }

  int backspace(int x) {
    final n = min(x, _left.length);
    _left.length -= n;
    return n;
  }

  int delete(int x) {
    final n = min(x, _right.length);
    _right.length -= n;
    return n;
  }

  // Up to x characters immediately left of the cursor.
  String print(int x) => _left.sublist(max(0, _left.length - x)).join();

  String text() => _left.join() + _right.reversed.join();
}
```

### TypeScript

```typescript
class TextEditor {
  private left: string[] = [];
  private right: string[] = []; // stored backwards: its end is the cursor

  insert(text: string): void {
    for (const ch of text) this.left.push(ch);
  }

  moveLeft(x: number): void {
    for (let k = Math.min(x, this.left.length); k > 0; k--) this.right.push(this.left.pop()!);
  }

  moveRight(x: number): void {
    for (let k = Math.min(x, this.right.length); k > 0; k--) this.left.push(this.right.pop()!);
  }

  backspace(x: number): number {
    const n = Math.min(x, this.left.length);
    this.left.length -= n;
    return n;
  }

  delete(x: number): number {
    const n = Math.min(x, this.right.length);
    this.right.length -= n;
    return n;
  }

  // Up to x characters immediately left of the cursor.
  print(x: number): string {
    return this.left.slice(Math.max(0, this.left.length - x)).join("");
  }

  text(): string {
    return this.left.join("") + [...this.right].reverse().join("");
  }
}
```

*(Swift, Dart and TS name the moves `moveLeft` / `moveRight` because `left` / `right` are the fields. Real editors use a rope or piece table for huge documents.)*

---

## Q6. Halve the Largest k Times (Compress the Biggest Attachments)

**Topic:** Heap / greedy

**Statement**

An envelope has attachments with sizes `nums`. You may run exactly `k` compress steps; each takes one attachment and halves its size, rounding up. Return the smallest possible total size.

Example: `[5, 4, 9]`, k = 2 → halve 9 → `[5, 4, 5]` = 14 → halve 5 → `[3, 4, 5]` = 12.

**Approach**

Halving a big number removes more than halving a small one, so always halve the current largest. Brute force rescans the array each round: O(k · n). A max-heap gives the largest in O(log n). Greedy is safe because the amount removed, `x − ceil(x/2)`, never shrinks as `x` grows.

**Complexity:** Time O(n + k log n), Space O(n)

### Kotlin

```kotlin
import java.util.PriorityQueue

fun minSumAfterHalving(nums: IntArray, k: Int): Long {
    val heap = PriorityQueue<Int>(compareByDescending { it })
    nums.forEach { heap.add(it) }
    var sum = nums.sumOf { it.toLong() }
    repeat(k) {
        val top = heap.poll() ?: return sum
        val half = top - top / 2          // ceil(top / 2) without overflowing at Int.MAX_VALUE
        sum -= top - half
        heap.add(half)
    }
    return sum
}
```

### Swift

```swift
/// Array-backed max-heap of Ints.
struct MaxHeap {
    private var a: [Int] = []
    var isEmpty: Bool { a.isEmpty }

    mutating func push(_ x: Int) {
        a.append(x)
        var i = a.count - 1
        while i > 0 {
            let p = (i - 1) / 2
            if a[p] >= a[i] { break }
            a.swapAt(p, i); i = p
        }
    }

    mutating func pop() -> Int? {
        guard let top = a.first else { return nil }
        let last = a.removeLast()
        if !a.isEmpty {
            a[0] = last
            var i = 0
            while true {
                let l = 2 * i + 1, r = l + 1
                var m = i
                if l < a.count && a[l] > a[m] { m = l }
                if r < a.count && a[r] > a[m] { m = r }
                if m == i { break }
                a.swapAt(m, i); i = m
            }
        }
        return top
    }
}

func minSumAfterHalving(_ nums: [Int], _ k: Int) -> Int {
    var heap = MaxHeap()
    nums.forEach { heap.push($0) }
    var sum = nums.reduce(0, +)
    for _ in 0..<max(0, k) {
        guard let top = heap.pop() else { break }
        let half = top - top / 2          // ceil(top / 2)
        sum -= top - half
        heap.push(half)
    }
    return sum
}
```

### Dart

```dart
/// Array-backed max-heap of ints.
class MaxHeap {
  final _a = <int>[];
  bool get isEmpty => _a.isEmpty;

  void push(int x) {
    _a.add(x);
    var i = _a.length - 1;
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (_a[p] >= _a[i]) break;
      _swap(p, i);
      i = p;
    }
  }

  int pop() {
    final top = _a.first;
    final last = _a.removeLast();
    if (_a.isNotEmpty) {
      _a[0] = last;
      var i = 0;
      while (true) {
        final l = 2 * i + 1, r = l + 1;
        var m = i;
        if (l < _a.length && _a[l] > _a[m]) m = l;
        if (r < _a.length && _a[r] > _a[m]) m = r;
        if (m == i) break;
        _swap(m, i);
        i = m;
      }
    }
    return top;
  }

  void _swap(int i, int j) {
    final t = _a[i];
    _a[i] = _a[j];
    _a[j] = t;
  }
}

int minSumAfterHalving(List<int> nums, int k) {
  final heap = MaxHeap();
  var sum = 0;
  for (final x in nums) {
    heap.push(x);
    sum += x;
  }
  for (var r = 0; r < k && !heap.isEmpty; r++) {
    final top = heap.pop();
    final half = top - top ~/ 2; // ceil(top / 2)
    sum -= top - half;
    heap.push(half);
  }
  return sum;
}
```

### TypeScript

```typescript
/** Array-backed max-heap of numbers. */
class MaxHeap {
  private a: number[] = [];
  get size(): number { return this.a.length; }
  push(x: number): void {
    const a = this.a;
    a.push(x);
    let i = a.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (a[p] >= a[i]) break;
      [a[p], a[i]] = [a[i], a[p]];
      i = p;
    }
  }
  pop(): number {
    const a = this.a;
    const top = a[0];
    const last = a.pop()!;
    if (a.length > 0) {
      a[0] = last;
      let i = 0;
      for (;;) {
        const l = 2 * i + 1, r = l + 1;
        let m = i;
        if (l < a.length && a[l] > a[m]) m = l;
        if (r < a.length && a[r] > a[m]) m = r;
        if (m === i) break;
        [a[m], a[i]] = [a[i], a[m]];
        i = m;
      }
    }
    return top;
  }
}

function minSumAfterHalving(nums: number[], k: number): number {
  const heap = new MaxHeap();
  let sum = 0;
  for (const x of nums) { heap.push(x); sum += x; }
  for (let r = 0; r < k && heap.size > 0; r++) {
    const top = heap.pop();
    const half = Math.ceil(top / 2);
    sum -= top - half;
    heap.push(half);
  }
  return sum;
}
```

**Watch out:** `(x + 1) / 2` overflows at `Int.MAX_VALUE`; `x − x / 2` rounds up safely. Keep the sum in a `Long`. Swift, Dart and TS have no built-in heap, so write a small one (say so before you start).

---

## Q7. Count Balanced Binary Substrings (Pen-Down Runs)

**Topic:** Run-length counting

**Statement**

A stylus reports pen state as a binary string (`0` = up, `1` = down). Count substrings where all 0s are together, all 1s are together, and there are as many 0s as 1s. `"0011"` and `"10"` count; `"0101"` does not. Repeats at different positions count separately.

Example: `"00110011"` → 6; `"10101"` → 4.

**Approach**

Brute force checks all O(n²) substrings, O(n³) total. Better: split into runs of the same character. Every valid substring sits across one boundary between two neighbouring runs, and runs of sizes a and b give `min(a, b)` substrings. Track only the previous and current run lengths.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun countBinarySubstrings(s: String): Int {
    var previous = 0
    var current = 1
    var count = 0
    for (i in 1 until s.length) {
        if (s[i] == s[i - 1]) {
            current++
        } else {
            count += minOf(previous, current)
            previous = current
            current = 1
        }
    }
    return count + minOf(previous, current)
}
```

### Swift

```swift
func countBinarySubstrings(_ s: String) -> Int {
    let c = Array(s)
    var previous = 0, current = 1, count = 0
    for i in c.indices.dropFirst() {
        if c[i] == c[i - 1] {
            current += 1
        } else {
            count += min(previous, current)
            previous = current
            current = 1
        }
    }
    return count + min(previous, current)
}
```

### Dart

```dart
int countBinarySubstrings(String s) {
  var previous = 0, current = 1, count = 0;
  for (var i = 1; i < s.length; i++) {
    if (s[i] == s[i - 1]) {
      current++;
    } else {
      count += current < previous ? current : previous;
      previous = current;
      current = 1;
    }
  }
  return count + (current < previous ? current : previous);
}
```

### TypeScript

```typescript
function countBinarySubstrings(s: string): number {
  let previous = 0, current = 1, count = 0;
  for (let i = 1; i < s.length; i++) {
    if (s[i] === s[i - 1]) {
      current++;
    } else {
      count += Math.min(previous, current);
      previous = current;
      current = 1;
    }
  }
  return count + Math.min(previous, current);
}
```

**Watch out:** add the last boundary after the loop; length 0 or 1 gives 0.

---

Previous: [Chapter 42 — Document & Signing Drill Bank](42-document-signing-drill-bank.md) · Next: [Chapter 42 — Document & Signing Drill Bank — Q8–Q13](42-document-signing-drill-bank-q08-q13.md) · Solutions: [`solutions/ch42`](../../solutions/ch42/README.md)
