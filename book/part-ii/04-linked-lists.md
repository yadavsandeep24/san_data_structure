# Chapter 4 — Linked Lists

## Mobile motivation

You ship an image thumbnail cache. Under scroll, every new URL inserts at the “most recent” end and every eviction deletes the “least recent” end. If that ordered set is an array, each eviction can shift hundreds of entries. If it is a doubly linked list plus a hash map, both insert and delete by key stay **O(1)**. That is why LRU shows up in Coil, Glide, SDWebImage, and every home-grown memory cache — and why linked lists still matter on mobile even when you rarely hand-roll a `Node` in production UI code.

Linked lists also appear in less glamorous places: undo histories that splice mid-stream, playlist seek without copying, and interview drills that ask you to reverse, cycle-detect, or merge without allocating a second array.

## What a linked list is

A **linked list** stores elements in nodes. Each node holds a value and one or more pointers (references) to neighbors. There is no contiguous block, so random index access is gone — you walk from a head (and sometimes a tail).

### Singly linked list

Each node points only **forward**.

```
[A] → [B] → [C] → null
 ↑
head
```

- Insert at head (push front): **O(1)** if you keep `head`.
- Append at tail: **O(1)** if you keep `tail`, else **O(n)**.
- Delete an arbitrary known node: **O(n)** to find the predecessor (singly).
- Index access: **O(n)**.

### Doubly linked list

Each node points **forward and backward**.

```
null ← [A] ⇄ [B] ⇄ [C] → null
        ↑head            ↑tail
```

- Delete a node when you already hold its reference: **O(1)** (rewire `prev`/`next`).
- Move a node to the front (LRU “touch”): **O(1)**.
- Extra memory: one more pointer per node; worse cache locality than arrays.

### When to use / when to avoid

| Prefer linked list when… | Prefer array / dynamic array when… |
|--------------------------|-------------------------------------|
| Frequent insert/delete in the middle **and** you already hold the node | You need index access or binary search |
| LRU / MRU ordering with a map of keys → nodes | Dense sequential scans (list rendering buffers) |
| Splicing without shifting neighbors | Memory locality and GC pressure matter |
| You need stable node identity across mutations | Size is small and simplicity wins |

**Avoid** linked lists as your default “list of rows” for RecyclerView / UITableView / ListView. Contiguous arrays win on prefetch and iteration. Use lists as the *ordering spine* under a cache or as an algorithm building block — not as a substitute for `ArrayList` / `Array`.

## Complexity at a glance

| Operation | Singly (head only) | Singly (head+tail) | Doubly (head+tail) | Dynamic array |
|-----------|--------------------|--------------------|--------------------|---------------|
| Access by index | O(n) | O(n) | O(n) | O(1) |
| Search by value | O(n) | O(n) | O(n) | O(n) |
| Insert at head | O(1) | O(1) | O(1) | O(n) shift / O(1) amortized at end |
| Insert at tail | O(n) | O(1) | O(1) | O(1) amortized |
| Delete known node | O(n) pred | O(n) pred | O(1) | O(n) |
| Memory overhead | 1 ptr/node | 1 ptr/node | 2 ptrs/node | contiguous |

## Platform bridges

| Platform | What you actually use |
|----------|------------------------|
| **Android** | Rarely `LinkedList` for UI data. Prefer `ArrayDeque` for queues, `LinkedHashMap` (access-order) or a custom map+DLL for LRU. Coil/Glide caches are map + eviction policy. |
| **iOS** | `LinkedList` is not a standard Foundation type. You build nodes for interviews; production caches use `NSCache` or custom dictionaries. Doubly linked patterns appear inside custom LRU. |
| **Flutter** | `LinkedList` / `LinkedListEntry` exist in `dart:collection` for intrusive lists. Most app lists stay as `List`. Image caches (e.g. custom `ImageCache`) follow LRU semantics. |
| **React Native** | JS arrays are the default. An LRU is typically `Map` + doubly linked nodes, or a library. Hermes GC still pays for many small node objects — keep capacity bounded. |

## Worked building blocks (four languages)

### Singly node + reverse (iterative)

**Kotlin**

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
```

**Swift**

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
```

**Dart**

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
```

**TypeScript**

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
```

### Cycle detection (Floyd)

Two pointers, `slow` and `fast`. If they meet, a cycle exists. If `fast` hits null, no cycle. O(n) time, O(1) space — ideal for memory-tight devices.

**Kotlin**

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
```

**Swift**

```swift
func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}
```

**Dart**

```dart
bool hasCycle(ListNode? head) {
  var slow = head, fast = head;
  while (fast?.next != null) {
    slow = slow?.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}
```

**TypeScript**

```typescript
function hasCycle(head: ListNode | null): boolean {
  let slow = head, fast = head;
  while (fast?.next) {
    slow = slow!.next;
    fast = fast.next.next;
    if (slow === fast) return true;
  }
  return false;
}
```

## LRU cache: HashMap + doubly linked list

**Idea:** Map `key → node` for O(1) lookup. Doubly linked list orders by recency: head = most recent, tail = least recent. On `get`/`put` hit, splice the node to head. On capacity overflow, drop the tail and remove it from the map.

Dummy head/tail sentinels keep edge cases (empty list, single node) uniform.

### Kotlin

```kotlin
class LRUCache(private val capacity: Int) {
    private class Node(val key: Int, var value: Int) {
        var prev: Node? = null
        var next: Node? = null
    }

    private val map = HashMap<Int, Node>()
    private val head = Node(-1, -1)
    private val tail = Node(-1, -1)

    init {
        head.next = tail
        tail.prev = head
    }

    fun get(key: Int): Int {
        val node = map[key] ?: return -1
        moveToHead(node)
        return node.value
    }

    fun put(key: Int, value: Int) {
        val existing = map[key]
        if (existing != null) {
            existing.value = value
            moveToHead(existing)
            return
        }
        val node = Node(key, value)
        map[key] = node
        addAfterHead(node)
        if (map.size > capacity) {
            val lru = popTail()
            map.remove(lru.key)
        }
    }

    private fun addAfterHead(node: Node) {
        node.prev = head
        node.next = head.next
        head.next!!.prev = node
        head.next = node
    }

    private fun remove(node: Node) {
        node.prev!!.next = node.next
        node.next!!.prev = node.prev
    }

    private fun moveToHead(node: Node) {
        remove(node)
        addAfterHead(node)
    }

    private fun popTail(): Node {
        val node = tail.prev!!
        remove(node)
        return node
    }
}
```

### Swift

```swift
final class LRUCache {
    private final class Node {
        let key: Int
        var value: Int
        var prev: Node?
        var next: Node?
        init(_ key: Int, _ value: Int) {
            self.key = key
            self.value = value
        }
    }

    private let capacity: Int
    private var map: [Int: Node] = [:]
    private let head = Node(-1, -1)
    private let tail = Node(-1, -1)

    init(_ capacity: Int) {
        self.capacity = capacity
        head.next = tail
        tail.prev = head
    }

    func get(_ key: Int) -> Int {
        guard let node = map[key] else { return -1 }
        moveToHead(node)
        return node.value
    }

    func put(_ key: Int, _ value: Int) {
        if let node = map[key] {
            node.value = value
            moveToHead(node)
            return
        }
        let node = Node(key, value)
        map[key] = node
        addAfterHead(node)
        if map.count > capacity {
            let lru = popTail()
            map[lru.key] = nil
        }
    }

    private func addAfterHead(_ node: Node) {
        node.prev = head
        node.next = head.next
        head.next?.prev = node
        head.next = node
    }

    private func remove(_ node: Node) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
    }

    private func moveToHead(_ node: Node) {
        remove(node)
        addAfterHead(node)
    }

    private func popTail() -> Node {
        let node = tail.prev!
        remove(node)
        return node
    }
}
```

### Dart

```dart
class LRUCache {
  LRUCache(this.capacity) {
    head.next = tail;
    tail.prev = head;
  }

  final int capacity;
  final _map = <int, _Node>{};
  final head = _Node(-1, -1);
  final tail = _Node(-1, -1);

  int get(int key) {
    final node = _map[key];
    if (node == null) return -1;
    _moveToHead(node);
    return node.value;
  }

  void put(int key, int value) {
    final existing = _map[key];
    if (existing != null) {
      existing.value = value;
      _moveToHead(existing);
      return;
    }
    final node = _Node(key, value);
    _map[key] = node;
    _addAfterHead(node);
    if (_map.length > capacity) {
      final lru = _popTail();
      _map.remove(lru.key);
    }
  }

  void _addAfterHead(_Node node) {
    node.prev = head;
    node.next = head.next;
    head.next!.prev = node;
    head.next = node;
  }

  void _remove(_Node node) {
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
  }

  void _moveToHead(_Node node) {
    _remove(node);
    _addAfterHead(node);
  }

  _Node _popTail() {
    final node = tail.prev!;
    _remove(node);
    return node;
  }
}

class _Node {
  _Node(this.key, this.value);
  final int key;
  int value;
  _Node? prev;
  _Node? next;
}
```

### TypeScript

```typescript
class LRUCache {
  private capacity: number;
  private map = new Map<number, Node>();
  private head = new Node(-1, -1);
  private tail = new Node(-1, -1);

  constructor(capacity: number) {
    this.capacity = capacity;
    this.head.next = this.tail;
    this.tail.prev = this.head;
  }

  get(key: number): number {
    const node = this.map.get(key);
    if (!node) return -1;
    this.moveToHead(node);
    return node.value;
  }

  put(key: number, value: number): void {
    const existing = this.map.get(key);
    if (existing) {
      existing.value = value;
      this.moveToHead(existing);
      return;
    }
    const node = new Node(key, value);
    this.map.set(key, node);
    this.addAfterHead(node);
    if (this.map.size > this.capacity) {
      const lru = this.popTail();
      this.map.delete(lru.key);
    }
  }

  private addAfterHead(node: Node): void {
    node.prev = this.head;
    node.next = this.head.next;
    this.head.next!.prev = node;
    this.head.next = node;
  }

  private remove(node: Node): void {
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
  }

  private moveToHead(node: Node): void {
    this.remove(node);
    this.addAfterHead(node);
  }

  private popTail(): Node {
    const node = this.tail.prev!;
    this.remove(node);
    return node;
  }
}

class Node {
  prev: Node | null = null;
  next: Node | null = null;
  constructor(public key: number, public value: number) {}
}
```

**Complexity:** `get` and `put` are **O(1)** average (hash) + O(1) list rewiring. Space **O(capacity)**.

**Mobile note:** Cap capacity by *memory budget*, not only entry count (bitmaps vary wildly). Prefer weak/soft references or platform `NSCache` when the OS should reclaim under pressure. Never grow an unbounded node graph on the main thread.

## Common mistakes

1. **Using `LinkedList` as a queue on Android** — `ArrayDeque` is almost always faster.
2. **Forgetting sentinels** — empty/single-node edge cases explode without dummy head/tail.
3. **Losing the previous pointer** while reversing — always stash `next` before rewiring.
4. **Cycle + mutation** — mutating a cyclic list without Floyd first can hang forever.
5. **Assuming O(1) delete on singly lists** — you need the predecessor or a doubly linked design.

## Self-Check

**4.1** Why is random access O(n) on a linked list but O(1) on an array?

**4.2** When does a doubly linked list beat a singly linked list for delete?

**4.3** In an LRU of capacity 2, after `put(1,a)`, `put(2,b)`, `get(1)`, `put(3,c)`, which key is evicted and why?

**4.4** Name one mobile API that behaves like an LRU without you writing nodes.

**4.5** Why is Floyd’s cycle detection preferable to a `HashSet` of visited nodes on a low-RAM device?

*(Answers: Appendix D.)*

## Practice

1. **Reverse a singly linked list** (iterative and recursive) — [solutions/ch04](../../solutions/ch04/README.md#p1-reverse-linked-list)
2. **Detect cycle** (and optionally return the cycle entrance) — [solutions/ch04](../../solutions/ch04/README.md#p2-detect-cycle)
3. **LRU get/put** (implement from scratch; compare to the chapter reference) — [solutions/ch04](../../solutions/ch04/README.md#p3-lru-cache-getput)

Next: [Chapter 5 — Stacks](05-stacks.md) — LIFO, navigation back-stacks, and undo.
