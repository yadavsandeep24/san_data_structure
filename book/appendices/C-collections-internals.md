# Appendix C — Collections Internals (Kotlin, Swift, Dart, TypeScript)

How the four stacks actually grow, hash, and copy. Useful for interviews (“what happens on resize?”) and for avoiding accidental O(n) copies on the UI thread.

---

## Dynamic arrays

| | Kotlin | Swift | Dart | TypeScript |
|--|--------|-------|------|------------|
| Type | `ArrayList` / `MutableList` | `Array` (`ContiguousArray`) | `List` (growable) | `Array` |
| Storage | Contiguous JVM/Native buffer | Contiguous elements | Contiguous in VM | Contiguous (engine-dependent) |
| Growth | ~1.5× capacity | Geometric growth | Geometric growth | Engine geometric growth |
| Index | O(1) | O(1) | O(1) | O(1) |
| Append | Amortized O(1) | Amortized O(1) | Amortized O(1) | Amortized O(1) |
| Insert/remove front | O(n) shift | O(n) | O(n) | O(n) (`shift`/`unshift`) |
| Pre-size | `ArrayList(capacity)` | `reserveCapacity` | Rarely exposed; grow naturally | Rarely exposed |

**Mobile tip:** Prefer append + reverse over repeated prepend. Pre-size when you know `n` after a network parse.

---

## Hash maps

| | Kotlin | Swift | Dart | TypeScript |
|--|--------|-------|------|------------|
| Type | `HashMap` | `Dictionary` | `Map` | `Map` / object |
| Hash | `hashCode` / Murmur-ish | `_HashTable` | identity/value hash | SameValueZero for `Map` |
| Collision | Treeify long chains (JVM) | Open addressing style internals | Hash table | Engine hash table |
| Order | Unspecified (`HashMap`); insertion with `LinkedHashMap` | Unspecified | Insertion order (Dart `Map`) | `Map`: insertion order; object: string-key quirks |
| Avg get/put | O(1) | O(1) | O(1) | O(1) |
| Keys | Must implement equals/hash consistently | `Hashable` | `==` / hashCode | Object identity vs value |

**Android note:** `LinkedHashMap(accessOrder=true)` underpins classic LRU sketches; `androidx.collection.LruCache` is production-ready.

**JS note:** Prefer `Map` for non-string keys and predictable iteration; plain objects coerce keys to strings.

---

## Sets

| | Kotlin | Swift | Dart | TypeScript |
|--|--------|-------|------|------------|
| Type | `HashSet` | `Set` | `Set` | `Set` |
| Backing | Hash table | Hash table | Hash table | Hash table |
| Membership | O(1) avg | O(1) avg | O(1) avg | O(1) avg |
| Order | Unspecified; `LinkedHashSet` keeps insertion | Unspecified | Insertion order | Insertion order |
| Hybrid | Set + `ArrayList` for ordered unique | `OrderedSet` (Foundation) / Array+Set | List + Set | Array + Set |

---

## Strings & mutability / COW

| | Kotlin | Swift | Dart | TypeScript |
|--|--------|-------|------|------------|
| Default `String` | Immutable (JVM) | **Value type** with **Copy-on-Write** | Immutable | Immutable primitive |
| Mutation builder | `StringBuilder` | `String` mutates uniquely; shared storage COW | `StringBuffer` | Build via array join |
| Indexing | O(1) char/code unit* | `Index` opaque; UTF-8 view | Code units; grapheme care | UTF-16 code units |
| Concat in loop | Avoid; use builder | Prefer map/join patterns | Prefer buffer / join | Prefer `parts.join('')` |
| COW | N/A (immutable share) | Multiple vars share buffer until write | Immutable share | Immutable share |

\*Kotlin/Java indexing is by UTF-16 code unit; emoji/grapheme clusters need care on all platforms.

**Swift COW detail:** Assigning `var b = a` for `Array`/`String`/`Dictionary` is O(1) until one side mutates, then a copy occurs. Passing `inout` or uniquely referenced mutation avoids copies — great for performance, easy to misunderstand in interviews.

**Dart:** `List` is growable by default (`[]`); `const []` / fixed-length lists differ. Strings are immutable; `StringBuffer` for assembly.

---

## Queues & deques (practical)

| Need | Prefer |
|------|--------|
| Kotlin | `ArrayDeque` (not `java.util.Stack`, not `LinkedList` as default queue) |
| Swift | Array as stack; for queue use head index or custom ring to avoid `removeFirst` in hot loops |
| Dart | `Queue` from `dart:collection`; `ListQueue` |
| TypeScript | Head-index array or deque library; avoid `shift` in hot paths |

---

## Concurrency & sharing (preview of Ch 23)

| Language | Collection thread-safety |
|----------|--------------------------|
| Kotlin/JVM | Most collections **not** thread-safe; use concurrent maps / mutex / single-thread confine |
| Swift | Value types help; classes need locks/actors |
| Dart | Isolate-bound heaps; message passing for share |
| TypeScript RN | JS single-threaded; native modules / workers need care |

---

## Interview one-liners

- “Dynamic arrays amortize growth; front insert is still O(n).”
- “HashMap average O(1); I still bound memory for caches.”
- “Swift Array/Dictionary/String use COW — copies are lazy until mutation.”
- “JS `Map` preserves insertion order; objects are not general-purpose maps.”
- “Never `shift` 100k times — use a deque or head index.”

Next: [Appendix D — Self-Check Answer Key](D-self-check-answer-key.md).
