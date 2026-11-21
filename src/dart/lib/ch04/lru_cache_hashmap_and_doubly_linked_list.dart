// LRU cache: HashMap and doubly linked list
// Source: book/part-ii/04-linked-lists.md

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
