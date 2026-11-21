// P3: LRU cache get/put
// Source: solutions/ch04/README.md
import { LRUCache } from './lru_cache_hashmap_and_doubly_linked_list';

const cache = new LRUCache(2);
cache.put(1, 1);
cache.put(2, 2);
console.assert(cache.get(1) === 1);
cache.put(3, 3); // evicts 2
console.assert(cache.get(2) === -1);

export {};
