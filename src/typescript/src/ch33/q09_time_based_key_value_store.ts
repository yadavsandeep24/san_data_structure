// Q9. Time Based Key-Value Store (Versioned Config Cache)
// Source: book/part-viii/33-stacks-binary-search.md

class TimeMap {
  private store = new Map<string, [number, string][]>();

  // Timestamps for a key arrive in increasing order, so each list stays sorted.
  set(key: string, value: string, timestamp: number): void {
    let list = this.store.get(key);
    if (!list) { list = []; this.store.set(key, list); }
    list.push([timestamp, value]);
  }

  get(key: string, timestamp: number): string {
    const list = this.store.get(key);
    if (!list) return "";
    let lo = 0, hi = list.length - 1, ans = "";
    while (lo <= hi) { // last entry with time <= timestamp
      const mid = (lo + hi) >> 1;
      if (list[mid][0] <= timestamp) { ans = list[mid][1]; lo = mid + 1; }
      else hi = mid - 1;
    }
    return ans;
  }
}

export {};
