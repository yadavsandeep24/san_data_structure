// Q35. Implement Trie (Autocomplete Core)
// Source: book/part-viii/29-interview-questions-q31-q40.md

class TrieNode {
  next = new Map<string, TrieNode>();
  end = false;
}
class Trie {
  private root = new TrieNode();
  insert(word: string): void {
    let n = this.root;
    for (const c of word) {
      let nx = n.next.get(c);
      if (!nx) { nx = new TrieNode(); n.next.set(c, nx); }
      n = nx;
    }
    n.end = true;
  }
  search(word: string): boolean { return this.walk(word)?.end ?? false; }
  startsWith(prefix: string): boolean { return this.walk(prefix) !== null; }
  private walk(s: string): TrieNode | null {
    let n: TrieNode | undefined = this.root;
    for (const c of s) { n = n.next.get(c); if (!n) return null; }
    return n;
  }
}

export {};
