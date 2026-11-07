# Chapter 30 — Document & Signing Drill Bank

These 13 problems come from **document / e-signature app loops** (Docusign-style): templates, signer lists, envelopes, comments, scanned pages, signature strokes, deep links and feature flags. Most are easy–medium. The hard part is the talk around the code: clarify the spec, name the edge cases, and say what you would do in the real product.

They complement [Chapter 24](../part-vii/24-interview-questions.md) (medium bank) and [Chapter 27](../part-viii/27-hard-drill-bank.md) (hard bank). Same habit: a standard pattern inside a product story.

Companion index: [`solutions/ch30/README.md`](../../solutions/ch30/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Time** | 25–35 minutes per problem; 45 for Q10 and Q12 |
| **Open** | Restate, ask the spec questions (missing key? bad data? too-large x?), list edges (3–5 min) |
| **Speak first** | Simple version + its cost, then the better idea, **time/space before code** |
| **Code** | Happy path first; clamp / validate in the last 5–8 min |
| **Languages** | Chapter shows **Kotlin + TypeScript** fully; Swift/Dart ports for Q5, Q8, Q10, Q12 in `solutions/ch30` |
| **Product tell** | One sentence: where this runs (client or server), what leaks if it is wrong, or how it scales to a 500-page document |

Do 2 a day. Pair one "string / hashing" problem (Q1–Q3, Q13) with one "structure" problem (Q5, Q8, Q10, Q11).

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

*(TS names the moves `moveLeft` / `moveRight` because `left` / `right` are the fields. Real editors use a rope or piece table for huge documents.)*

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

**Watch out:** `(x + 1) / 2` overflows at `Int.MAX_VALUE`; `x − x / 2` rounds up safely. Keep the sum in a `Long`. TS has no built-in heap, so write a small one (say so before you start).

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

## Q8. Build Comment Threads from a Flat List (Document Comments)

**Topic:** Trees / hashing

**Statement**

The API returns document comments as a flat list with `parentId`. Build threads: roots newest first, replies oldest first. A reply whose parent was deleted becomes a root. A comment that is its own parent is a root. Comments stuck in a loop (`a → b → a`) are left out.

Example: `a` root (t=1), `b` and `c` reply to `a` (t=3, t=2), `d` root (t=5), `e` replies to a deleted comment (t=4), `f` is its own parent (t=6) → roots `[f, d, e, a]`, `a`'s replies `[c, b]`.

**Approach**

Brute force rescans the whole list for each comment's replies: O(n²). Better: one pass to build `id → comment`, one pass to group valid replies by parent. Roots = no parent, missing parent, or self-parent; sort newest first. Build each tree from the map, replies oldest first; a `seen` set stops bad data from looping.

**Complexity:** Time O(n log n) (the sorts), Space O(n)

### Kotlin

```kotlin
data class Comment(val id: String, val parentId: String?, val at: Long, val text: String)
data class Thread(val comment: Comment, val replies: List<Thread>)

/** Roots newest first, replies oldest first. Orphans (parent missing) become roots. */
fun buildThreads(all: List<Comment>): List<Thread> {
    val byId = all.associateBy { it.id }
    val children = all
        .filter { it.parentId != null && it.parentId in byId && it.parentId != it.id }
        .groupBy { it.parentId!! }
    fun build(c: Comment, seen: MutableSet<String>): Thread {
        seen += c.id
        val kids = children[c.id].orEmpty().filter { it.id !in seen }.sortedBy { it.at }
        return Thread(c, kids.map { build(it, seen) })
    }
    val roots = all
        .filter { it.parentId == null || it.parentId !in byId || it.parentId == it.id }
        .sortedByDescending { it.at }
    val seen = mutableSetOf<String>()
    return roots.map { build(it, seen) }
}

fun Thread.count(): Int = 1 + replies.sumOf { it.count() }
```

### TypeScript

```typescript
type Comment = { id: string; parentId: string | null; at: number; text: string };
type Thread = { comment: Comment; replies: Thread[] };

/** Roots newest first, replies oldest first. Orphans (parent missing) become roots. */
function buildThreads(all: Comment[]): Thread[] {
  const byId = new Map(all.map((c) => [c.id, c]));
  const children = new Map<string, Comment[]>();
  for (const c of all) {
    if (c.parentId === null || !byId.has(c.parentId) || c.parentId === c.id) continue;
    const list = children.get(c.parentId);
    if (list) list.push(c);
    else children.set(c.parentId, [c]);
  }
  const seen = new Set<string>();
  const build = (c: Comment): Thread => {
    seen.add(c.id);
    const kids = (children.get(c.id) ?? []).filter((k) => !seen.has(k.id)).sort((a, b) => a.at - b.at);
    return { comment: c, replies: kids.map(build) };
  };
  return all
    .filter((c) => c.parentId === null || !byId.has(c.parentId) || c.parentId === c.id)
    .sort((a, b) => b.at - a.at)
    .map(build);
}

const countThread = (t: Thread): number => 1 + t.replies.reduce((s, r) => s + countThread(r), 0);
```

**Watch out:** show "reply to a deleted comment" on promoted orphans; log comments dropped by a cycle. For very deep threads build with an explicit stack instead of recursion.

---

## Q9. Highest JPEG Quality That Fits the Upload Limit (Binary Search on the Answer)

**Topic:** Binary search on the answer

**Statement**

Each scanned page must be under a size limit. Encoding is slow, so find the highest JPEG quality (1–100) whose output fits, with as few encodes as possible. Higher quality never makes the file smaller.

Example: limit 1,000,000 bytes, `size(q) = 40,000 + 120·q²` → quality 89 (990,520 bytes; 90 gives 1,012,000).

**Approach**

Brute force tries 100, 99, … — up to 100 encodes. Since size only grows with quality, one encode at the middle tells you which half holds the answer. If it fits, save it and search higher; else search lower. Return `null` if even the lowest quality is too big.

**Complexity:** O(log range) encodes (7 for 1..100), Space O(1)

### Kotlin

```kotlin
/** size(q) must not decrease as q rises. Largest q in [lo, hi] with size(q) <= limit, or null. */
fun bestQuality(lo: Int, hi: Int, limit: Long, size: (Int) -> Long): Int? {
    var l = lo
    var h = hi
    var best: Int? = null
    while (l <= h) {
        val mid = l + (h - l) / 2
        if (size(mid) <= limit) { best = mid; l = mid + 1 } else h = mid - 1
    }
    return best
}
```

### TypeScript

```typescript
/** size(q) must not decrease as q rises. Largest q in [lo, hi] with size(q) <= limit, or null. */
function bestQuality(lo: number, hi: number, limit: number, size: (q: number) => number): number | null {
  let l = lo, h = hi;
  let best: number | null = null;
  while (l <= h) {
    const mid = l + ((h - l) >> 1);
    if (size(mid) <= limit) { best = mid; l = mid + 1; } else h = mid - 1;
  }
  return best;
}
```

**Dry run:** 50 fits → 75 fits → 88 fits → 94 too big → 91 too big → 89 fits → 90 too big → 89 after 7 encodes. **Mobile tell:** encode off the main thread; real JPEG sizes are not perfectly monotonic, so try one or two neighbours of the answer. If nothing fits, shrink the image instead.

---

## Q10. Deep-Link Router (Open the Right Envelope Screen)

**Topic:** Trie / backtracking

**Statement**

Route links like `/envelopes/abc-123/sign?utm=email` to screens using patterns such as `/envelopes/:id/sign`, `/envelopes/drafts` and `/help/*`. A static segment beats a `:param`, which beats `*`. Return the screen and the captured params, or null.

**Approach**

Simple version: test every pattern and score each segment (static 0, param 1, wildcard 2) — O(patterns × segments) per link. Better: a trie with one level per path segment. Each node has static children, one param child and an optional wildcard. To match: drop the query, split, and at each node try static, then param (record it), then wildcard. If a branch dead-ends, back up and try the next option.

Example: `/envelopes/drafts/sign` — the static `drafts` node has no `sign` child → back up → `:id = drafts` → `sign` → Sign screen.

**Complexity:** O(segments) per link in the usual case (backtracking only when a static branch dead-ends); O(total pattern segments) space

### Kotlin

```kotlin
class Router<T> {
    private class Node<T> {
        val kids = HashMap<String, Node<T>>()
        var param: Pair<String, Node<T>>? = null
        var wildcard: T? = null
        var value: T? = null
    }

    private val root = Node<T>()

    fun add(pattern: String, value: T) {
        var n = root
        for (seg in pattern.trim('/').split('/').filter { it.isNotEmpty() }) {
            when {
                seg == "*" -> { n.wildcard = value; return }
                seg.startsWith(":") -> {
                    val p = n.param ?: (seg.drop(1) to Node<T>()).also { n.param = it }
                    n = p.second
                }
                else -> n = n.kids.getOrPut(seg) { Node() }
            }
        }
        n.value = value
    }

    /** Static segments beat :params, which beat *. Backtracks if a static branch dead-ends. */
    fun match(path: String): Pair<T, Map<String, String>>? {
        val segs = path.substringBefore('?').trim('/').split('/').filter { it.isNotEmpty() }
        fun go(n: Node<T>, i: Int, params: Map<String, String>): Pair<T, Map<String, String>>? {
            if (i == segs.size) return n.value?.let { it to params } ?: n.wildcard?.let { it to params }
            n.kids[segs[i]]?.let { k -> go(k, i + 1, params)?.let { return it } }
            n.param?.let { (name, k) -> go(k, i + 1, params + (name to segs[i]))?.let { return it } }
            return n.wildcard?.let { it to params }
        }
        return go(root, 0, emptyMap())
    }
}
```

### TypeScript

```typescript
type Match<T> = { value: T; params: Record<string, string> };
type RouteNode<T> = {
  kids: Map<string, RouteNode<T>>;
  param: { name: string; node: RouteNode<T> } | null;
  wildcard: T | null;
  value: T | null;
};

const newNode = <T>(): RouteNode<T> => ({ kids: new Map(), param: null, wildcard: null, value: null });
const segments = (s: string) => s.split("?")[0].split("/").filter((p) => p.length > 0);

class Router<T> {
  private root: RouteNode<T> = newNode<T>();

  add(pattern: string, value: T): void {
    let n = this.root;
    for (const seg of segments(pattern)) {
      if (seg === "*") { n.wildcard = value; return; }
      if (seg.startsWith(":")) {
        n.param ??= { name: seg.slice(1), node: newNode<T>() };
        n = n.param.node;
      } else {
        let k = n.kids.get(seg);
        if (!k) { k = newNode<T>(); n.kids.set(seg, k); }
        n = k;
      }
    }
    n.value = value;
  }

  /** Static segments beat :params, which beat *. Backtracks if a static branch dead-ends. */
  match(path: string): Match<T> | null {
    const segs = segments(path);
    const go = (n: RouteNode<T>, i: number, params: Record<string, string>): Match<T> | null => {
      if (i === segs.length) {
        const v = n.value ?? n.wildcard;
        return v === null ? null : { value: v, params };
      }
      const k = n.kids.get(segs[i]);
      const viaStatic = k ? go(k, i + 1, params) : null;
      if (viaStatic) return viaStatic;
      const viaParam = n.param ? go(n.param.node, i + 1, { ...params, [n.param.name]: segs[i] }) : null;
      if (viaParam) return viaParam;
      return n.wildcard === null ? null : { value: n.wildcard, params };
    };
    return go(this.root, 0, {});
  }
}
```

**Watch out:** one param name per node — `/envelopes/:id` and `/envelopes/:envId/sign` would both report `id`, so use the same name at the same level. Parse the query string separately, and validate the id before you open a signing screen from an untrusted link.

---

## Q11. Simplify a Signature Stroke (Ramer-Douglas-Peucker)

**Topic:** Divide and conquer / geometry

**Statement**

A drawn signature has thousands of points. Keep as few as possible while every original point stays within ε pixels of the simpler line, so the stroke is cheap to store and send.

Example: a straight line of 101 points → 2 points.

**Approach**

Brute force (try every shortcut i → j, then fewest hops) finds the true minimum but is O(n³). Ramer-Douglas-Peucker: draw a line from the first to the last point. If no point is farther than ε, drop everything between. Otherwise keep the farthest point and repeat on both halves. Use an explicit stack so a long stroke cannot overflow the call stack.

**Complexity:** Time O(n log n) on typical strokes, O(n²) worst case; Space O(n)

### Kotlin

```kotlin
import kotlin.math.hypot

data class Pt(val x: Double, val y: Double)

fun distToSegment(p: Pt, a: Pt, b: Pt): Double {
    val dx = b.x - a.x
    val dy = b.y - a.y
    val len2 = dx * dx + dy * dy
    if (len2 == 0.0) return hypot(p.x - a.x, p.y - a.y)
    val t = (((p.x - a.x) * dx + (p.y - a.y) * dy) / len2).coerceIn(0.0, 1.0)
    return hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy))
}

/** Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack. */
fun simplify(points: List<Pt>, epsilon: Double): List<Pt> {
    if (points.size < 3) return points
    val keep = BooleanArray(points.size).also { it[0] = true; it[points.lastIndex] = true }
    val stack = ArrayDeque(listOf(0 to points.lastIndex))
    while (stack.isNotEmpty()) {
        val (s, e) = stack.removeLast()
        var maxD = 0.0
        var idx = -1
        for (i in s + 1 until e) {
            val d = distToSegment(points[i], points[s], points[e])
            if (d > maxD) { maxD = d; idx = i }
        }
        if (maxD > epsilon) { keep[idx] = true; stack += s to idx; stack += idx to e }
    }
    return points.filterIndexed { i, _ -> keep[i] }
}
```

### TypeScript

```typescript
type Pt = { x: number; y: number };

function distToSegment(p: Pt, a: Pt, b: Pt): number {
  const dx = b.x - a.x, dy = b.y - a.y;
  const len2 = dx * dx + dy * dy;
  if (len2 === 0) return Math.hypot(p.x - a.x, p.y - a.y);
  const t = Math.min(1, Math.max(0, ((p.x - a.x) * dx + (p.y - a.y) * dy) / len2));
  return Math.hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy));
}

/** Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack. */
function simplify(points: Pt[], epsilon: number): Pt[] {
  if (points.length < 3) return points;
  const keep = new Array<boolean>(points.length).fill(false);
  keep[0] = keep[points.length - 1] = true;
  const stack: [number, number][] = [[0, points.length - 1]];
  while (stack.length > 0) {
    const [s, e] = stack.pop()!;
    let maxD = 0, idx = -1;
    for (let i = s + 1; i < e; i++) {
      const d = distToSegment(points[i], points[s], points[e]);
      if (d > maxD) { maxD = d; idx = i; }
    }
    if (maxD > epsilon) { keep[idx] = true; stack.push([s, idx], [idx, e]); }
  }
  return points.filter((_, i) => keep[i]);
}
```

**Watch out:** RDP is not always the absolute minimum, but it is close and much faster. Distance must be to the **segment**, not the infinite line, or a stroke that doubles back loses points. A zig-zag stroke is the O(n²) worst case.

---

## Q12. Justify Text for a Narrow Screen (Agreement Preview)

**Topic:** Greedy / strings (LeetCode 68)

**Statement**

Lay out agreement words into lines of exactly `width` characters: as many words per line as fit, extra spaces spread as evenly as possible with the left gaps getting more, and the last line left-aligned.

Example: `"This is an example of text justification."`, width 16 → `"This    is    an"`, `"example  of text"`, `"justification.  "`.

**Approach**

Greedy. Keep a running letter count so each word is checked in O(1): take words while `letters + (words − 1) ≤ width`. Last line or a single word: join with one space, pad right. Otherwise `spaces = width − letters`, `each = spaces / gaps`, `extra = spaces % gaps`; the first `extra` gaps get one more.

**Complexity:** Time O(total characters), Space O(width) per line

### Kotlin

```kotlin
fun justify(words: List<String>, width: Int): List<String> {
    val lines = mutableListOf<String>()
    var i = 0
    while (i < words.size) {
        var j = i
        var len = 0
        while (j < words.size && len + words[j].length + (j - i) <= width) { len += words[j].length; j++ }
        require(j > i) { "word longer than width: ${words[i]}" }
        val gaps = j - i - 1
        val line = if (j == words.size || gaps == 0) {
            words.subList(i, j).joinToString(" ").padEnd(width)   // last line or one word: left-aligned
        } else {
            val spaces = width - len
            val each = spaces / gaps
            val extra = spaces % gaps
            buildString {
                for (k in i until j) {
                    append(words[k])
                    if (k < j - 1) append(" ".repeat(each + if (k - i < extra) 1 else 0))
                }
            }
        }
        lines += line
        i = j
    }
    return lines
}
```

### TypeScript

```typescript
function justify(words: string[], width: number): string[] {
  const lines: string[] = [];
  let i = 0;
  while (i < words.length) {
    let j = i, len = 0;
    while (j < words.length && len + words[j].length + (j - i) <= width) { len += words[j].length; j++; }
    if (j === i) throw new Error(`word longer than width: ${words[i]}`);
    const gaps = j - i - 1;
    if (j === words.length || gaps === 0) {
      lines.push(words.slice(i, j).join(" ").padEnd(width)); // last line or one word: left-aligned
    } else {
      const spaces = width - len;
      const each = Math.floor(spaces / gaps), extra = spaces % gaps;
      let line = "";
      for (let k = i; k < j; k++) {
        line += words[k];
        if (k < j - 1) line += " ".repeat(each + (k - i < extra ? 1 : 0));
      }
      lines.push(line);
    }
    i = j;
  }
  return lines;
}
```

**Watch out:** agree what to do with a word longer than the width (this code throws). On a real phone you measure in pixels and let the platform line breaker do it; this is the algorithm underneath.

---

## Q13. Stable Percentage Rollout (New Signing Flow Flag)

**Topic:** Hashing / probability

**Statement**

Turn on a new signing flow for p% of users so that each user's answer never changes between sessions or devices, raising p only adds users, and two flags do not pick the same users.

**Approach**

Simple version: roll a random number per user and store it on the device — a second device gives a different answer, it is lost on reinstall, and storage grows per user. Better: compute the "roll" from the user id with a **fixed** hash (FNV-1a, not a seeded hash). `bucket = hash(flag + ":" + userId) mod 10,000`; on if `bucket < p × 100`. Raising p moves the cut-off up, so everyone already on stays on. Putting the flag name in the hash makes flags independent.

**Complexity:** O(length of id) per check, O(1) space

### Kotlin

```kotlin
fun fnv1a(s: String): Int {
    var h = 0x811C9DC5.toInt()
    for (c in s.toByteArray()) {
        h = h xor (c.toInt() and 0xff)
        h *= 0x01000193
    }
    return h
}

/** Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags. */
fun bucket(flag: String, userId: String) = Math.floorMod(fnv1a("$flag:$userId"), 10_000)

fun isOn(flag: String, userId: String, percent: Double) = bucket(flag, userId) < (percent * 100).toInt()
```

### TypeScript

```typescript
const utf8 = new TextEncoder();

function fnv1a(s: string): number {
  let h = 0x811c9dc5 | 0;
  for (const b of utf8.encode(s)) {
    h ^= b;
    h = Math.imul(h, 0x01000193);
  }
  return h; // signed 32-bit, same bits as the Kotlin Int
}

/** Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags. */
function bucket(flag: string, userId: string): number {
  const h = fnv1a(`${flag}:${userId}`);
  return ((h % 10_000) + 10_000) % 10_000; // floorMod
}

function isOn(flag: string, userId: string, percent: number): boolean {
  return bucket(flag, userId) < Math.trunc(percent * 100);
}
```

**Checked:** over 100,000 test users, a 10% flag turned on 10,093; two different 10% flags overlapped on 1,090 (about the 1,000 you expect by chance). Kotlin and TS give the same bucket for the same id. **Watch out:** floor-mod, not `%`, on a signed hash. To roll out per company, hash the account id instead.

---

## Drill checklist (say aloud)

1. Clarify the spec first (missing key, bad data, too-large x, case).  
2. Simple version and its cost, then the better idea.  
3. Complexity **before** code.  
4. Edges: empty input, n = 0, negative n, cycles, self-parent, nothing fits.  
5. One product sentence: client or server, what leaks, how it scales.

Previous: [Chapter 29 — Behavioral & Product Sense](../part-viii/29-behavioral-product-fintech.md) · See also: [Chapter 27 — Hard Drill Bank](../part-viii/27-hard-drill-bank.md)
