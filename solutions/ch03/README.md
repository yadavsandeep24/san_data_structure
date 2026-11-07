# Chapter 3 — Practice Solutions

Model solutions for Chapter 3 practice problems. Each solution names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-ii/03-arrays-dynamic-arrays.md`](../../book/part-ii/03-arrays-dynamic-arrays.md).

---

## Problem 1 — Remove duplicates, preserve order

**Statement.** Given an array of IDs (strings or ints), return a new sequence containing each value once, in the order of first appearance.

**Pattern.** Single pass + hash set of already-seen values. Append to the result only when the value is new.

| | |
|--|--|
| **Time** | Θ(n) |
| **Extra space** | O(u) for the set (u = unique count), plus O(u) for the result |
| **Stable order?** | Yes — first occurrence wins |

**Edge cases.** Empty input → empty output. All unique → copy. All identical → single element. Already-deduped input → same length.

**Mobile note.** Fine on a background thread for large feeds before publishing an immutable list to the UI. For n in the low thousands, a one-shot dedupe on UI can be acceptable; prefer off-main if this runs on every network page merge. Do not nest `result.contains` (that would be O(n²)).

### Kotlin

```kotlin
fun removeDuplicatesPreserveOrder(ids: List<String>): List<String> {
    val seen = HashSet<String>()                 // O(u) space
    val out = ArrayList<String>()
    for (id in ids) {                            // Θ(n)
        if (seen.add(id)) {                      // O(1) average; true if new
            out.add(id)                          // O(1) amortized
        }
    }
    return out
}

// Example
// removeDuplicatesPreserveOrder(listOf("a", "b", "a", "c", "b")) == ["a", "b", "c"]
```

### Swift

```swift
func removeDuplicatesPreserveOrder(_ ids: [String]) -> [String] {
    var seen = Set<String>()                     // O(u) space
    var out: [String] = []
    out.reserveCapacity(ids.count)
    for id in ids {                              // Θ(n)
        if seen.insert(id).inserted {            // O(1) average
            out.append(id)                       // O(1) amortized
        }
    }
    return out
}

// removeDuplicatesPreserveOrder(["a", "b", "a", "c", "b"]) == ["a", "b", "c"]
```

### Dart

```dart
List<String> removeDuplicatesPreserveOrder(List<String> ids) {
  final seen = <String>{};                       // O(u) space
  final out = <String>[];
  for (final id in ids) {                        // Θ(n)
    if (seen.add(id)) {                          // O(1) average; true if new
      out.add(id);                               // O(1) amortized
    }
  }
  return out;
}

// removeDuplicatesPreserveOrder(['a', 'b', 'a', 'c', 'b']) == ['a', 'b', 'c']
```

### TypeScript

```typescript
function removeDuplicatesPreserveOrder(ids: string[]): string[] {
  const seen = new Set<string>();                // O(u) space
  const out: string[] = [];
  for (const id of ids) {                        // Θ(n)
    if (!seen.has(id)) {                         // O(1) average
      seen.add(id);
      out.push(id);                              // O(1) amortized
    }
  }
  return out;
}

// removeDuplicatesPreserveOrder(["a", "b", "a", "c", "b"]) === ["a", "b", "c"]
```

**Incorrect approach to avoid**

```text
for each id:
  if result does not contain id:   ← O(n) scan each time → O(n²) overall
    append id
```

---

## Problem 2 — Rotate array right by k

**Statement.** Rotate the array to the right by `k` positions. Example: `[1,2,3,4,5]`, `k = 2` → `[4,5,1,2,3]`.

**Pattern (preferred).** Reverse-based in-place rotation:

1. Normalize `k = k % n` (no-op if n = 0 or k = 0).
2. Reverse the whole array.
3. Reverse the first `k` elements.
4. Reverse the remaining `n - k` elements.

| | |
|--|--|
| **Time** | Θ(n) |
| **Extra space** | O(1) besides input (in-place) |
| **Alternative** | Copy into a new array at index `(i + k) % n` — Θ(n) time, O(n) space; clearer, heavier on mobile |

**Edge cases.** `n = 0`. `k = 0`. `k` multiple of `n` (no visible change). `k > n` (must modulo). Single-element array.

**Mobile note.** In-place mutation is allocation-friendly but dangerous if the same array instance is bound to a scrolling list mid-frame — rotate on a background copy, then swap the immutable snapshot into the adapter (`ListAdapter.submitList`), Compose state (`StateFlow` collected by a `LazyColumn`), or `FlatList` data prop. For UI-facing code, the O(n) extra-space copy is often the safer hand-off.

### Kotlin (in-place reverse method)

```kotlin
fun rotateRightInPlace(a: IntArray, kRaw: Int) {
    val n = a.size
    if (n == 0) return
    val k = ((kRaw % n) + n) % n                 // handle negative k safely
    if (k == 0) return

    fun reverse(from: Int, to: Int) {            // inclusive from, exclusive to
        var i = from
        var j = to - 1
        while (i < j) {
            val tmp = a[i]
            a[i] = a[j]
            a[j] = tmp
            i++
            j--
        }
    }

    reverse(0, n)                                // Θ(n)
    reverse(0, k)                                // Θ(k)
    reverse(k, n)                                // Θ(n - k)
}

// Example: a = [1,2,3,4,5], k = 2 → [4,5,1,2,3]
```

### Swift

```swift
func rotateRightInPlace(_ a: inout [Int], kRaw: Int) {
    let n = a.count
    guard n > 0 else { return }
    var k = kRaw % n
    if k < 0 { k += n }
    guard k != 0 else { return }

    a.reverse()                                  // Θ(n)
    a[..<k].reverse()                            // Θ(k)
    a[k...].reverse()                            // Θ(n - k)
}

// var a = [1, 2, 3, 4, 5]; rotateRightInPlace(&a, kRaw: 2) // [4, 5, 1, 2, 3]
```

### Dart

```dart
void rotateRightInPlace(List<int> a, int kRaw) {
  final n = a.length;
  if (n == 0) return;
  var k = kRaw % n;
  if (k < 0) k += n;
  if (k == 0) return;

  void reverse(int from, int to) {
    // [from, to)
    var i = from;
    var j = to - 1;
    while (i < j) {
      final tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
      i++;
      j--;
    }
  }

  reverse(0, n);
  reverse(0, k);
  reverse(k, n);
}

// final a = [1, 2, 3, 4, 5]; rotateRightInPlace(a, 2); // [4, 5, 1, 2, 3]
```

### TypeScript

```typescript
function rotateRightInPlace(a: number[], kRaw: number): void {
  const n = a.length;
  if (n === 0) return;
  let k = kRaw % n;
  if (k < 0) k += n;
  if (k === 0) return;

  const reverse = (from: number, to: number) => {
    let i = from;
    let j = to - 1;
    while (i < j) {
      const tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
      i++;
      j--;
    }
  };

  reverse(0, n);                                 // Θ(n)
  reverse(0, k);                                 // Θ(k)
  reverse(k, n);                                 // Θ(n - k)
}

// const a = [1, 2, 3, 4, 5]; rotateRightInPlace(a, 2); // [4, 5, 1, 2, 3]
```

### Alternative — O(n) extra space (clearer hand-off to UI)

```typescript
function rotateRightCopy(a: readonly number[], kRaw: number): number[] {
  const n = a.length;
  if (n === 0) return [];
  let k = kRaw % n;
  if (k < 0) k += n;
  const out = new Array<number>(n);
  for (let i = 0; i < n; i++) {
    out[(i + k) % n] = a[i];                     // Θ(n)
  }
  return out;
}
```

Same idea ports one-for-one to Kotlin (`IntArray(n)`), Swift (`Array(repeating: 0, count: n)`), and Dart (`List<int>.filled(n, 0)`).

---

## Quick self-test

After reading the solutions, verify without looking:

1. Why is `seen.add` / `Set.insert` essential to keeping Problem 1 at Θ(n)?
2. Why must Problem 2 compute `k % n` before reversing?
3. Would you mutate the `FlatList`/`RecyclerView` data array in place on the UI thread after a rotate? Why or why not?

Return to Chapter 3 when you can explain append vs front-insert costs without checking the table.
