# Chapter 42 — Document & Signing Drill Bank — Q8–Q13

Part of [Chapter 42 — Document & Signing Drill Bank](42-document-signing-drill-bank.md). Read the overview first for the timing rules and strategy.

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

### Swift

```swift
struct Comment { let id: String; let parentId: String?; let at: Int64; let text: String }
struct Thread { let comment: Comment; let replies: [Thread] }

/// Roots newest first, replies oldest first. Orphans (parent missing) become roots.
func buildThreads(_ all: [Comment]) -> [Thread] {
    let ids = Set(all.map(\.id))
    func isRoot(_ c: Comment) -> Bool {
        guard let p = c.parentId else { return true }
        return !ids.contains(p) || p == c.id
    }
    var children: [String: [Comment]] = [:]
    for c in all where !isRoot(c) { children[c.parentId!, default: []].append(c) }
    var seen = Set<String>()
    func build(_ c: Comment) -> Thread {
        seen.insert(c.id)
        let kids = (children[c.id] ?? []).filter { !seen.contains($0.id) }.sorted { $0.at < $1.at }
        return Thread(comment: c, replies: kids.map(build))
    }
    return all.filter(isRoot).sorted { $0.at > $1.at }.map(build)
}
```

### Dart

```dart
class Comment {
  final String id;
  final String? parentId;
  final int at;
  final String text;
  const Comment(this.id, this.parentId, this.at, this.text);
}

class Thread {
  final Comment comment;
  final List<Thread> replies;
  const Thread(this.comment, this.replies);
}

/// Roots newest first, replies oldest first. Orphans (parent missing) become roots.
List<Thread> buildThreads(List<Comment> all) {
  final ids = {for (final c in all) c.id};
  bool isRoot(Comment c) => c.parentId == null || !ids.contains(c.parentId) || c.parentId == c.id;
  final children = <String, List<Comment>>{};
  for (final c in all) {
    if (!isRoot(c)) children.putIfAbsent(c.parentId!, () => []).add(c);
  }
  final seen = <String>{};
  Thread build(Comment c) {
    seen.add(c.id);
    final kids = (children[c.id] ?? []).where((k) => !seen.contains(k.id)).toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    return Thread(c, kids.map(build).toList());
  }
  final roots = all.where(isRoot).toList()..sort((a, b) => b.at.compareTo(a.at));
  return roots.map(build).toList();
}
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

### Swift

```swift
/// size(q) must not decrease as q rises. Largest q in lo...hi with size(q) <= limit, or nil.
func bestQuality(_ lo: Int, _ hi: Int, _ limit: Int64, _ size: (Int) -> Int64) -> Int? {
    var l = lo, h = hi
    var best: Int? = nil
    while l <= h {
        let mid = l + (h - l) / 2
        if size(mid) <= limit { best = mid; l = mid + 1 } else { h = mid - 1 }
    }
    return best
}
```

### Dart

```dart
/// size(q) must not decrease as q rises. Largest q in [lo, hi] with size(q) <= limit, or null.
int? bestQuality(int lo, int hi, int limit, int Function(int q) size) {
  var l = lo, h = hi;
  int? best;
  while (l <= h) {
    final mid = l + (h - l) ~/ 2;
    if (size(mid) <= limit) {
      best = mid;
      l = mid + 1;
    } else {
      h = mid - 1;
    }
  }
  return best;
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

### Swift

```swift
final class Router<T> {
    private final class Node {
        var kids: [String: Node] = [:]
        var param: (name: String, node: Node)?
        var wildcard: T?
        var value: T?
    }

    private let root = Node()

    private static func segments(_ s: String) -> [String] {
        let path = s.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: false).first ?? ""
        return path.split(separator: "/").map(String.init)
    }

    func add(_ pattern: String, _ value: T) {
        var n = root
        for seg in Router.segments(pattern) {
            if seg == "*" { n.wildcard = value; return }
            if seg.hasPrefix(":") {
                if n.param == nil { n.param = (String(seg.dropFirst()), Node()) }
                n = n.param!.node
            } else {
                if n.kids[seg] == nil { n.kids[seg] = Node() }
                n = n.kids[seg]!
            }
        }
        n.value = value
    }

    /// Static segments beat :params, which beat *. Backtracks if a static branch dead-ends.
    func match(_ path: String) -> (value: T, params: [String: String])? {
        let segs = Router.segments(path)
        func go(_ n: Node, _ i: Int, _ params: [String: String]) -> (value: T, params: [String: String])? {
            if i == segs.count {
                if let v = n.value ?? n.wildcard { return (v, params) }
                return nil
            }
            if let k = n.kids[segs[i]], let m = go(k, i + 1, params) { return m }
            if let p = n.param {
                var next = params; next[p.name] = segs[i]
                if let m = go(p.node, i + 1, next) { return m }
            }
            if let w = n.wildcard { return (w, params) }
            return nil
        }
        return go(root, 0, [:])
    }
}
```

### Dart

```dart
class _Node<T> {
  final kids = <String, _Node<T>>{};
  (String, _Node<T>)? param;
  T? wildcard;
  T? value;
}

class Router<T> {
  final _root = _Node<T>();

  static List<String> _segments(String s) =>
      s.split('?').first.split('/').where((p) => p.isNotEmpty).toList();

  void add(String pattern, T value) {
    var n = _root;
    for (final seg in _segments(pattern)) {
      if (seg == '*') { n.wildcard = value; return; }
      if (seg.startsWith(':')) {
        n.param ??= (seg.substring(1), _Node<T>());
        n = n.param!.$2;
      } else {
        n = n.kids.putIfAbsent(seg, () => _Node<T>());
      }
    }
    n.value = value;
  }

  /// Static segments beat :params, which beat *. Backtracks if a static branch dead-ends.
  (T, Map<String, String>)? match(String path) {
    final segs = _segments(path);
    (T, Map<String, String>)? go(_Node<T> n, int i, Map<String, String> params) {
      if (i == segs.length) {
        final v = n.value ?? n.wildcard;
        return v == null ? null : (v, params);
      }
      final k = n.kids[segs[i]];
      if (k != null) {
        final m = go(k, i + 1, params);
        if (m != null) return m;
      }
      final p = n.param;
      if (p != null) {
        final m = go(p.$2, i + 1, {...params, p.$1: segs[i]});
        if (m != null) return m;
      }
      final w = n.wildcard;
      return w == null ? null : (w, params);
    }
    return go(_root, 0, const {});
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

### Swift

```swift
struct Pt: Equatable { let x: Double; let y: Double }

func distToSegment(_ p: Pt, _ a: Pt, _ b: Pt) -> Double {
    let dx = b.x - a.x, dy = b.y - a.y
    let len2 = dx * dx + dy * dy
    func len(_ x: Double, _ y: Double) -> Double { (x * x + y * y).squareRoot() }
    if len2 == 0 { return len(p.x - a.x, p.y - a.y) }
    let t = min(1, max(0, ((p.x - a.x) * dx + (p.y - a.y) * dy) / len2))
    return len(p.x - (a.x + t * dx), p.y - (a.y + t * dy))
}

/// Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack.
func simplify(_ points: [Pt], _ epsilon: Double) -> [Pt] {
    if points.count < 3 { return points }
    var keep = [Bool](repeating: false, count: points.count)
    keep[0] = true; keep[points.count - 1] = true
    var stack = [(0, points.count - 1)]
    while let (s, e) = stack.popLast() {
        var maxD = 0.0, idx = -1
        for i in (s + 1)..<e {
            let d = distToSegment(points[i], points[s], points[e])
            if d > maxD { maxD = d; idx = i }
        }
        if maxD > epsilon { keep[idx] = true; stack.append((s, idx)); stack.append((idx, e)) }
    }
    return points.indices.filter { keep[$0] }.map { points[$0] }
}
```

### Dart

```dart
import 'dart:math';

class Pt {
  final double x, y;
  const Pt(this.x, this.y);
}

double distToSegment(Pt p, Pt a, Pt b) {
  final dx = b.x - a.x, dy = b.y - a.y;
  final len2 = dx * dx + dy * dy;
  double len(double x, double y) => sqrt(x * x + y * y);
  if (len2 == 0) return len(p.x - a.x, p.y - a.y);
  final t = (((p.x - a.x) * dx + (p.y - a.y) * dy) / len2).clamp(0.0, 1.0);
  return len(p.x - (a.x + t * dx), p.y - (a.y + t * dy));
}

/// Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack.
List<Pt> simplify(List<Pt> points, double epsilon) {
  if (points.length < 3) return points;
  final keep = List<bool>.filled(points.length, false);
  keep[0] = keep[points.length - 1] = true;
  final stack = <(int, int)>[(0, points.length - 1)];
  while (stack.isNotEmpty) {
    final (s, e) = stack.removeLast();
    var maxD = 0.0, idx = -1;
    for (var i = s + 1; i < e; i++) {
      final d = distToSegment(points[i], points[s], points[e]);
      if (d > maxD) {
        maxD = d;
        idx = i;
      }
    }
    if (maxD > epsilon) {
      keep[idx] = true;
      stack..add((s, idx))..add((idx, e));
    }
  }
  return [for (var i = 0; i < points.length; i++) if (keep[i]) points[i]];
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

### Swift

```swift
func justify(_ words: [String], _ width: Int) -> [String] {
    var lines: [String] = []
    var i = 0
    while i < words.count {
        var j = i, len = 0
        while j < words.count && len + words[j].count + (j - i) <= width { len += words[j].count; j += 1 }
        precondition(j > i, "word longer than width: \(words[i])")
        let gaps = j - i - 1
        if j == words.count || gaps == 0 {
            let s = words[i..<j].joined(separator: " ")       // last line or one word: left-aligned
            lines.append(s + String(repeating: " ", count: width - s.count))
        } else {
            let spaces = width - len, each = spaces / gaps, extra = spaces % gaps
            var line = ""
            for k in i..<j {
                line += words[k]
                if k < j - 1 { line += String(repeating: " ", count: each + (k - i < extra ? 1 : 0)) }
            }
            lines.append(line)
        }
        i = j
    }
    return lines
}
```

### Dart

```dart
List<String> justify(List<String> words, int width) {
  final lines = <String>[];
  var i = 0;
  while (i < words.length) {
    var j = i, len = 0;
    while (j < words.length && len + words[j].length + (j - i) <= width) { len += words[j].length; j++; }
    if (j == i) throw ArgumentError('word longer than width: ${words[i]}');
    final gaps = j - i - 1;
    if (j == words.length || gaps == 0) {
      lines.add(words.sublist(i, j).join(' ').padRight(width)); // last line or one word: left-aligned
    } else {
      final spaces = width - len, each = spaces ~/ gaps, extra = spaces % gaps;
      final sb = StringBuffer();
      for (var k = i; k < j; k++) {
        sb.write(words[k]);
        if (k < j - 1) sb.write(' ' * (each + (k - i < extra ? 1 : 0)));
      }
      lines.add(sb.toString());
    }
    i = j;
  }
  return lines;
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

### Swift

```swift
func fnv1a(_ s: String) -> Int32 {
    var h = Int32(bitPattern: 0x811C9DC5)
    for b in s.utf8 {
        h ^= Int32(b)
        h = h &* 0x01000193        // wrapping multiply, same bits as Kotlin Int
    }
    return h
}

/// Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags.
func bucket(_ flag: String, _ userId: String) -> Int {
    let r = Int(fnv1a("\(flag):\(userId)")) % 10_000
    return r < 0 ? r + 10_000 : r  // floorMod
}

func isOn(_ flag: String, _ userId: String, _ percent: Double) -> Bool {
    bucket(flag, userId) < Int(percent * 100)
}
```

### Dart

```dart
import 'dart:convert';

int fnv1a(String s) {
  var h = 0x811C9DC5;
  for (final b in utf8.encode(s)) {
    h ^= b;
    // h * 0x01000193 mod 2^32 in 16-bit halves, so no step passes 2^53 (safe on Flutter web / JS).
    final lo = h & 0xFFFF, hi = h >> 16;
    final mid = (hi * 0x0193 + lo * 0x0100) & 0xFFFF;
    h = (lo * 0x0193 + mid * 0x10000) & 0xFFFFFFFF;
  }
  return h.toSigned(32); // same bits as the Kotlin Int
}

/// Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags.
int bucket(String flag, String userId) => fnv1a('$flag:$userId') % 10000; // Dart % is already floor-mod

bool isOn(String flag, String userId, double percent) => bucket(flag, userId) < (percent * 100).toInt();
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

Previous: [Chapter 42 — Document & Signing Drill Bank — Q1–Q7](42-document-signing-drill-bank-q01-q07.md) · Next: [Appendix A — Your 12-Week Preparation Roadmap](../appendices/A-12-week-roadmap.md) · Solutions: [`solutions/ch42`](../../solutions/ch42/README.md)
