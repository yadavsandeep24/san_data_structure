// P3: LRU cache get/put
// Source: solutions/ch04/README.md
package ch04.p03_lru_cache_get_put

import ch04.lru_cache_hashmap_and_doubly_linked_list.LRUCache

val cache = LRUCache(2)
fun example() {
    cache.put(1, 1)
    cache.put(2, 2)
    check(cache.get(1) == 1)
    cache.put(3, 3)          // evicts key 2
    check(cache.get(2) == -1)
    check(cache.get(3) == 3)
}
