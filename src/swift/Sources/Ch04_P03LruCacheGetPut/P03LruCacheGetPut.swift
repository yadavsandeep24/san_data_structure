// P3: LRU cache get/put
// Source: solutions/ch04/README.md

let cache = LRUCache(2)
func example() {
    cache.put(1, 1)
    cache.put(2, 2)
    precondition(cache.get(1) == 1)
    cache.put(3, 3)          // evicts key 2
    precondition(cache.get(2) == -1)
    precondition(cache.get(3) == 3)
}
