# Chapter 4 — Model Solutions

## P1: Reverse linked list

### Approach

Iterative: walk the list once, reversing `next` pointers while holding `prev`, `curr`, and `next`. Recursive: reverse the suffix, then point `head.next.next = head` and clear `head.next`.

### Complexity

- Time: O(n)
- Space: O(1) iterative; O(n) recursive call stack

### Edge cases

- Empty list / single node → return as-is
- Very long lists → prefer iterative on mobile (avoid call-stack overflow)

### Mobile note

Reversing a huge in-memory list on the main thread can hitch; if this is part of offline sync, do it off-main and publish the new head atomically.

### Kotlin

```kotlin
class ListNode(var value: Int, var next: ListNode? = null)

fun reverseList(head: ListNode?): ListNode? {
    var prev: ListNode? = null
    var curr = head
    while (curr != null) {
        val nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    }
    return prev
}

fun reverseListRecursive(head: ListNode?): ListNode? {
    if (head?.next == null) return head
    val newHead = reverseListRecursive(head.next)
    head.next!!.next = head
    head.next = null
    return newHead
}
```

### Swift

```swift
final class ListNode {
    var value: Int
    var next: ListNode?
    init(_ value: Int, _ next: ListNode? = nil) {
        self.value = value
        self.next = next
    }
}

func reverseList(_ head: ListNode?) -> ListNode? {
    var prev: ListNode? = nil
    var curr = head
    while let node = curr {
        let nxt = node.next
        node.next = prev
        prev = node
        curr = nxt
    }
    return prev
}

func reverseListRecursive(_ head: ListNode?) -> ListNode? {
    guard let head = head, head.next != nil else { return head }
    let newHead = reverseListRecursive(head.next)
    head.next?.next = head
    head.next = nil
    return newHead
}
```

### Dart

```dart
class ListNode {
  int value;
  ListNode? next;
  ListNode(this.value, [this.next]);
}

ListNode? reverseList(ListNode? head) {
  ListNode? prev;
  var curr = head;
  while (curr != null) {
    final nxt = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nxt;
  }
  return prev;
}

ListNode? reverseListRecursive(ListNode? head) {
  if (head == null || head.next == null) return head;
  final newHead = reverseListRecursive(head.next);
  head.next!.next = head;
  head.next = null;
  return newHead;
}
```

### TypeScript

```typescript
class ListNode {
  constructor(public value: number, public next: ListNode | null = null) {}
}

function reverseList(head: ListNode | null): ListNode | null {
  let prev: ListNode | null = null;
  let curr = head;
  while (curr) {
    const nxt = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nxt;
  }
  return prev;
}

function reverseListRecursive(head: ListNode | null): ListNode | null {
  if (!head?.next) return head;
  const newHead = reverseListRecursive(head.next);
  head.next.next = head;
  head.next = null;
  return newHead;
}
```

---

## P2: Detect cycle

### Approach

Floyd’s tortoise and hare: `slow` moves one step, `fast` two. Meeting ⇒ cycle. Optional entrance: reset one pointer to head; advance both one step until they meet — that node is the cycle start.

### Complexity

- Time: O(n)
- Space: O(1) — better than a visited `Set` which is O(n)

### Edge cases

- Empty / single node without self-loop → false
- Self-loop (`head.next === head`) → true, entrance is head
- Tail enters cycle mid-list → entrance is the join node

### Mobile note

Prefer Floyd over hashing node identities when scanning large offline graphs; constant extra memory matters under image-cache pressure.

### Kotlin

```kotlin
fun hasCycle(head: ListNode?): Boolean {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow?.next
        fast = fast.next?.next
        if (slow === fast) return true
    }
    return false
}

fun detectCycle(head: ListNode?): ListNode? {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow?.next
        fast = fast.next?.next
        if (slow === fast) {
            var p = head
            while (p !== slow) {
                p = p?.next
                slow = slow?.next
            }
            return p
        }
    }
    return null
}
```

### Swift

```swift
func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head
    var fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}

func detectCycle(_ head: ListNode?) -> ListNode? {
    var slow = head
    var fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast {
            var p = head
            while p !== slow {
                p = p?.next
                slow = slow?.next
            }
            return p
        }
    }
    return nil
}
```

### Dart

```dart
bool hasCycle(ListNode? head) {
  var slow = head;
  var fast = head;
  while (fast?.next != null) {
    slow = slow?.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}

ListNode? detectCycle(ListNode? head) {
  var slow = head;
  var fast = head;
  while (fast?.next != null) {
    slow = slow?.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) {
      var p = head;
      while (!identical(p, slow)) {
        p = p?.next;
        slow = slow?.next;
      }
      return p;
    }
  }
  return null;
}
```

### TypeScript

```typescript
function hasCycle(head: ListNode | null): boolean {
  let slow = head;
  let fast = head;
  while (fast?.next) {
    slow = slow!.next;
    fast = fast.next.next;
    if (slow === fast) return true;
  }
  return false;
}

function detectCycle(head: ListNode | null): ListNode | null {
  let slow = head;
  let fast = head;
  while (fast?.next) {
    slow = slow!.next;
    fast = fast.next.next;
    if (slow === fast) {
      let p = head;
      while (p !== slow) {
        p = p!.next;
        slow = slow!.next;
      }
      return p;
    }
  }
  return null;
}
```

---

## P3: LRU cache get/put

### Approach

`HashMap`/`Dictionary`/`Map` from key → doubly linked node, plus sentinel head/tail. `get`/`put` move the node after head; eviction removes `tail.prev`. See Chapter 4 for the full reference implementations in all four languages.

### Complexity

- `get` / `put`: O(1) average
- Space: O(capacity)

### Edge cases

- Capacity 0 / 1
- Update existing key (must refresh recency, not grow size)
- Repeated `get` on same key
- Eviction must remove both list node and map entry

### Mobile note

Bound by memory, not only count. For bitmaps, store decoded size and evict until under budget. Prefer platform caches (`NSCache`, Coil memory cache) when OS-driven reclaim is desirable.

### Kotlin / Swift / Dart / TypeScript

Use the complete `LRUCache` classes in [Chapter 4](../../book/part-ii/04-linked-lists.md#lru-cache-hashmap--doubly-linked-list). Minimal test harness:

```kotlin
val cache = LRUCache(2)
cache.put(1, 1)
cache.put(2, 2)
check(cache.get(1) == 1)
cache.put(3, 3)          // evicts key 2
check(cache.get(2) == -1)
check(cache.get(3) == 3)
```

```typescript
const cache = new LRUCache(2);
cache.put(1, 1);
cache.put(2, 2);
console.assert(cache.get(1) === 1);
cache.put(3, 3); // evicts 2
console.assert(cache.get(2) === -1);
```

*(Swift/Dart mirrors the same sequence with `XCTAssert` / `expect`.)*
