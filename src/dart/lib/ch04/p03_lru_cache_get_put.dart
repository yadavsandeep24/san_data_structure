// P3: LRU cache get/put
// Source: solutions/ch04/README.md
import 'lru_cache_hashmap_and_doubly_linked_list.dart' show LRUCache;

void main() {
  final cache = LRUCache(2);
  cache.put(1, 1);
  cache.put(2, 2);
  assert(cache.get(1) == 1);
  cache.put(3, 3); // evicts key 2
  assert(cache.get(2) == -1);
  assert(cache.get(3) == 3);
}
