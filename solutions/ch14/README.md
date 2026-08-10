# Chapter 14 — Model Solutions

## P1: Five scenario prompts

For each scenario: pick a structure (or hybrid) and justify. Expected answers below — your wording may differ if the reasoning is sound.

---

### S1 — Chat: older pages upward, new messages downward, no duplicates

**Pick:** Dynamic array (or deque) of messages **plus** `HashSet`/`Set` of message IDs **plus** cursor tokens for upward/downward pagination.

**Why:** Order matters for rendering; membership of IDs must be O(1) when merging pages or accepting realtime events; cursors avoid offset shift bugs when new messages arrive. Diff the array into the UI with stable keys = message IDs.

---

### S2 — Settings: undo last five toggles

**Pick:** Stack (bounded to 5) of inverse commands or prior values. Optional second stack if redo is required.

**Why:** Undo is LIFO — the last change is the first reversed. Bounding capacity keeps memory trivial. Do not scan a history array for “last change” on each undo; pop O(1).

---

### S3 — Barcode scan vs 40k on-device SKUs under 16ms

**Pick:** `HashSet` or `HashMap` of SKUs (possibly built once from a sorted file at startup). Not a linear list scan.

**Why:** Average O(1) membership fits a frame budget; O(n) scan of 40k strings on the UI thread is a jank lottery. If you need prefix search for human typing, add a trie or sorted array + binary search — still not nested loops.

---

### S4 — Profile: Follow vs Following for large following set

**Pick:** `HashSet` of following IDs (or a map if you also store metadata). The followers **list** UI remains an array for order.

**Why:** The button state is a membership query — must not scan the following list each bind. Load the set once (or page it into a set); array alone is the wrong structure for `contains`.

---

### S5 — Gallery thumbnails: fast revisit, bound RAM, 24h expiry

**Pick:** Two-level cache — L1 LRU memory of decoded thumbnails, L2 disk of encoded bytes, **TTL = 24h**, size/transform in the key. Or configure Glide/Coil/SDWebImage/`cached_network_image` equivalently.

**Why:** Recency matches LRU; TTL enforces freshness; disk survives process death; memory stays bounded and trims under pressure. An unbounded `Map<url, bitmap>` fails the RAM requirement.

---

## P2: Fix this code — membership in list

### Why it hurts

`cartSkus.contains(sku)` on a `List` is O(m). `bindRow` runs per visible row (and again on rebind). With n visible rows you pay O(n·m) during scroll — classic jank as the cart grows. Build a `Set` once per frame / per cart revision; then each row is O(1).

### Complexity

- Before: O(n·m) per bind pass
- After: O(m) to build set once + O(1) per row

### Edge cases

- Empty cart — empty set; all unchecked
- Duplicate SKUs in list — set collapses; fine for membership
- Rebuild set when cart mutates, not inside each row

### Mobile note

Android `RecyclerView`, iOS cell config, Flutter `itemBuilder`, RN `renderItem` — all share this trap. Pass `Set`/`Set<String>` into bind, or hold it on the view model.

### Kotlin — fixed

```kotlin
// BAD
fun bindRow(sku: String, cartSkus: List<String>, check: CheckBox) {
    check.isChecked = cartSkus.contains(sku) // O(m) per row
}

// GOOD — build once when cart changes
fun buildCartSet(cartSkus: List<String>): Set<String> = cartSkus.toHashSet()

fun bindRow(sku: String, cartSet: Set<String>, check: CheckBox) {
    check.isChecked = cartSet.contains(sku) // O(1) average
}
```

### Swift — fixed

```swift
// BAD
func bindRow(sku: String, cartSkus: [String], check: UISwitch) {
    check.isOn = cartSkus.contains(sku) // O(m)
}

// GOOD
func buildCartSet(_ cartSkus: [String]) -> Set<String> { Set(cartSkus) }

func bindRow(sku: String, cartSet: Set<String>, check: UISwitch) {
    check.isOn = cartSet.contains(sku) // O(1)
}
```

### Dart — fixed

```dart
// BAD
void bindRow(String sku, List<String> cartSkus, bool Function(bool) setChecked) {
  setChecked(cartSkus.contains(sku)); // O(m)
}

// GOOD
Set<String> buildCartSet(List<String> cartSkus) => cartSkus.toSet();

void bindRow(String sku, Set<String> cartSet, void Function(bool) setChecked) {
  setChecked(cartSet.contains(sku)); // O(1)
}
```

### TypeScript — fixed

```typescript
// BAD — inside renderItem
function isInCart(sku: string, cartSkus: string[]): boolean {
  return cartSkus.includes(sku); // O(m)
}

// GOOD — memoize / rebuild when cart changes
function buildCartSet(cartSkus: string[]): Set<string> {
  return new Set(cartSkus);
}

function isInCart(sku: string, cartSet: Set<string>): boolean {
  return cartSet.has(sku); // O(1)
}
```

---

## Quick reference — scenario → structure

| # | Structure |
|---|-----------|
| S1 | Array + Set + cursor |
| S2 | Bounded stack |
| S3 | HashSet / HashMap |
| S4 | HashSet (+ array for lists) |
| S5 | LRU + TTL (+ disk) |

| Bug | Fix |
|-----|-----|
| `list.contains` in bind | `Set.contains` with set built once |
