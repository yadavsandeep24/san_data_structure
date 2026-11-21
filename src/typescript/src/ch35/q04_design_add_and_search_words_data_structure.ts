// Q4. Design Add and Search Words Data Structure (Wildcard Contact Search)
// Source: book/part-viii/35-heaps-tries-greedy.md

type TrieNode = { next: Map<string, TrieNode>; end: boolean };

class WordDictionary {
  private root: TrieNode = { next: new Map(), end: false };

  addWord(word: string): void {
    let cur = this.root;
    for (const c of word) {
      let nx = cur.next.get(c);
      if (!nx) {
        nx = { next: new Map(), end: false };
        cur.next.set(c, nx);
      }
      cur = nx;
    }
    cur.end = true;
  }

  search(word: string): boolean {
    const match = (i: number, node: TrieNode): boolean => {
      if (i === word.length) return node.end;
      const c = word[i];
      if (c !== ".") {
        const nx = node.next.get(c);
        return nx !== undefined && match(i + 1, nx);
      }
      for (const child of node.next.values()) if (match(i + 1, child)) return true;
      return false;
    };
    return match(0, this.root);
  }
}

export {};
