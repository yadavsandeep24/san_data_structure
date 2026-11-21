// Tries for autocomplete
// Source: book/part-iii/10-trees-practical.md

class TrieNode {
  children = new Map<string, TrieNode>();
  end = false;
}

class Trie {
  private root = new TrieNode();

  insert(word: string): void {
    let n = this.root;
    for (const ch of word) {
      if (!n.children.has(ch)) n.children.set(ch, new TrieNode());
      n = n.children.get(ch)!;
    }
    n.end = true;
  }

  search(word: string): boolean {
    const n = this.walk(word);
    return !!n && n.end;
  }

  startsWith(prefix: string): boolean {
    return !!this.walk(prefix);
  }

  private walk(s: string): TrieNode | null {
    let n = this.root;
    for (const ch of s) {
      const next = n.children.get(ch);
      if (!next) return null;
      n = next;
    }
    return n;
  }
}

export {};
