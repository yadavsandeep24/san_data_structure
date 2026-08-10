# Chapter 8 — Sets

## Mobile motivation

The user selects photos in a gallery multi-select. You need: “is this asset ID selected?”, “toggle selection”, and “emit the final set of IDs to the upload API”. A list of selected IDs makes membership O(n). A **set** makes membership **average O(1)** — the same hash machinery as Chapter 7, but you only store keys, not values.

Sets show up everywhere in mobile clients: selected chip IDs, denied permission names, “posts already rendered in this session”, feature flags that are on, and the classic interview problems *contains duplicate* and *intersection of two arrays*.

## Membership in O(1)

A set answers three questions cheaply (average case):

| Operation | Meaning |
|-----------|---------|
| `add(x)` | Insert `x` if absent |
| `remove(x)` | Delete `x` if present |
| `contains(x)` | True iff `x` is a member |

Internally this is a hash table of keys (or a tree for sorted sets). Values are either omitted or a fixed sentinel.

```text
selected = { "asset_1", "asset_9", "asset_42" }
contains("asset_9") → true     // hash → bucket → equals
contains("asset_7") → false
```

## HashSet vs LinkedHashSet vs TreeSet (and friends)

| Flavor | Order | Membership | Iterate | Typical use |
|--------|-------|------------|---------|-------------|
| **Hash set** | None | O(1) avg | Arbitrary | Fast membership, dedup |
| **Linked hash set** | Insertion order | O(1) avg | Stable | Selection order, “recent IDs” |
| **Tree / sorted set** | Sorted by comparator | O(log n) | Sorted | Ranked IDs, range queries |

### Cross-language equivalents

| Idea | Kotlin | Swift | Dart | TypeScript |
|------|--------|-------|------|------------|
| Hash set | `HashSet` / `mutableSetOf` | `Set` | `HashSet` / `Set` | `Set` |
| Insertion-ordered | `LinkedHashSet` | (track array + set) | `LinkedHashSet` via `<T>{}` / `Set<T>()` | `Set` (insertion order) |
| Sorted | `sortedSetOf` / `TreeSet` | sort or `NSOrderedSet` patterns | `SplayTreeSet` | sort array; no std tree set |

**Swift:** `Set` is unordered. If the UI must show selection order, keep `Array` for order and `Set` for O(1) membership — a very common mobile pair.

**Dart:** Prefer `<T>{}` or `Set<T>()` for sets — a bare `{}` is a **`Map`**, not a `Set`. `Set()` / typed `{}` defaults to `LinkedHashSet` — iteration follows insertion.

**TypeScript:** ES `Set` preserves insertion order; membership is O(1) average for primitives and object identity for objects (reference equality unless you key by id string).

## Complexity at a glance

| Operation | Hash set | Linked hash set | Tree set |
|-----------|----------|-----------------|----------|
| add / remove / contains | O(1) avg | O(1) avg | O(log n) |
| iterate | O(n) | O(n) in insert order | O(n) sorted |
| space | O(n) | O(n) | O(n) |

## Set algebra: union, intersection, difference

Think Venn diagrams. These show up when merging permission lists, tag filters, and “users in both cohorts”.

| Op | Meaning | Example |
|----|---------|---------|
| **Union** `A ∪ B` | In A or B (or both) | All feature flags from remote ∪ local overrides |
| **Intersection** `A ∩ B` | In both | Selected IDs that still exist in the album |
| **Difference** `A − B` | In A but not B | Stale cache IDs to evict |

```kotlin
val a = setOf(1, 2, 3)
val b = setOf(2, 3, 4)
val union = a union b              // 1,2,3,4
val inter = a intersect b          // 2,3
val diff = a subtract b            // 1
```

Same ideas:

- Swift: `a.union(b)`, `a.intersection(b)`, `a.subtracting(b)`
- Dart: `a.union(b)`, `a.intersection(b)`, `a.difference(b)`
- TS: build via loops or helpers — no built-in operators

```typescript
function intersection<T>(a: Set<T>, b: Set<T>): Set<T> {
  const out = new Set<T>();
  for (const x of a) if (b.has(x)) out.add(x);
  return out;
}
```

Iterate the **smaller** set when intersecting for fewer lookups.

## Platform bridges

| Platform | Set-shaped APIs |
|----------|-----------------|
| **Android** | `HashSet` for selected positions; `ArraySet` (memory-efficient small sets); notification channel IDs; package name allowlists. |
| **iOS** | `Set` for selected `IndexPath` model IDs; Photos picker local identifiers; `OptionSet` for bit-like flags (different beast — fixed bits). |
| **Flutter** | `Set` for multi-select keys in `GridView`; form field names that failed validation; route names already pushed (careful with stacks — Chapter 5). |
| **React Native** | `Set` for selected row keys in `FlatList` `extraData`; deduping websocket event IDs; feature-flag name sets. |

### Selected IDs pattern

```kotlin
class SelectionTracker {
    private val selected = LinkedHashSet<String>() // order = tap order

    fun toggle(id: String) {
        if (!selected.add(id)) selected.remove(id)
    }

    fun isSelected(id: String) = id in selected
    fun snapshot(): List<String> = selected.toList()
}
```

Bind checkboxes with `isSelected`; submit with `snapshot()`. Do **not** scan an array of thousands of media models to count checkmarks.

## Worked code: sets in four languages

### Kotlin

```kotlin
val seen = HashSet<String>()
seen.add("p1")
seen.add("p1")                 // no-op; size stays 1
println("p1" in seen)          // true

val ordered = LinkedHashSet<String>()
ordered.add("first")
ordered.add("second")
println(ordered.toList())      // [first, second]
```

### Swift

```swift
var seen: Set<String> = []
seen.insert("p1")
seen.insert("p1")
print(seen.contains("p1"))     // true

// Order + membership
var order: [String] = []
var member: Set<String> = []
func select(_ id: String) {
    if member.insert(id).inserted { order.append(id) }
}
```

### Dart

```dart
final seen = <String>{};
seen.add('p1');
seen.add('p1');
print(seen.contains('p1'));    // true

final ordered = LinkedHashSet<String>();
ordered.add('first');
ordered.add('second');
print(ordered.toList());       // [first, second]
```

### TypeScript

```typescript
const seen = new Set<string>();
seen.add('p1');
seen.add('p1');
console.log(seen.has('p1'));   // true

// Insertion order preserved
const ordered = new Set<string>(['first', 'second']);
console.log([...ordered]);     // ['first', 'second']
```

## Pattern: contains duplicate

If you ever see the same element twice while scanning, return true. A set of seen values is the textbook approach.

```dart
bool containsDuplicate(List<int> nums) {
  final seen = <int>{};
  for (final x in nums) {
    if (!seen.add(x)) return true; // add returns false if already present
  }
  return false;
}
```

## Pattern: longest consecutive sequence

Given unsorted ints, find the length of the longest run of consecutive numbers (`1,2,3,4` length 4). Put all values in a set. Only start counting from numbers where `x-1` is **absent** — that means `x` is the start of a run. Average O(n).

```swift
func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)
    var best = 0
    for x in set where !set.contains(x - 1) {
        var y = x
        var len = 1
        while set.contains(y + 1) {
            y += 1
            len += 1
        }
        best = max(best, len)
    }
    return best
}
```

## Common mistakes

1. **Using a list for membership** — `selectedIds.contains` on `ArrayList` is O(n) per tap.
2. **Object identity in JS Set** — `set.add({id:1}); set.has({id:1})` is false; store string IDs.
3. **Mutating while iterating** a set without clear rules — collect to-delete first.
4. **Expecting sorted order** from a hash set when building alphabetical chips.
5. **Huge sets of full models** — store IDs; keep models in a map (Chapter 7).
6. **Tree set for hot UI toggles** — O(log n) is fine for thousands, but hash sets are simpler and faster for pure membership.

## Self-Check

**8.1** Why is set membership usually O(1) average?

**8.2** When do you use a LinkedHashSet (or Set + Array) instead of a plain HashSet?

**8.3** How do you compute intersection efficiently if one set is much smaller?

**8.4** Why does longest consecutive sequence only start counting when `x-1` is missing?

**8.5** Name one mobile UI feature that is naturally modeled as a set of IDs.

*(Answers: Appendix D.)*

## Practice

1. **Contains duplicate** — [solutions/ch08](../../solutions/ch08/README.md#p1-contains-duplicate)
2. **Intersection of two arrays** — [solutions/ch08](../../solutions/ch08/README.md#p2-intersection-of-two-arrays)
3. **Longest consecutive sequence** — [solutions/ch08](../../solutions/ch08/README.md#p3-longest-consecutive-sequence)

Back: [Chapter 7 — Hash Tables](07-hash-tables.md) · Next: [Chapter 9 — Trees Basics](09-trees-basics.md)
