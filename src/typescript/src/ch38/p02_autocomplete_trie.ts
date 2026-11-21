// P2. Autocomplete Trie
// Source: solutions/ch38/README.md

class AutoComplete {
  private root: any = { kids: new Map<string, any>(), end: false };
  insert(word: string): void {
    let n = this.root;
    for (const c of word.toLowerCase()) {
      if (!n.kids.has(c)) n.kids.set(c, { kids: new Map(), end: false });
      n = n.kids.get(c);
    }
    n.end = true;
  }
  suggest(prefix: string, k: number): string[] {
    let n = this.root;
    const p = prefix.toLowerCase();
    for (const c of p) { if (!n.kids.has(c)) return []; n = n.kids.get(c); }
    const out: string[] = [];
    const dfs = (cur: any, path: string) => {
      if (out.length >= k) return;
      if (cur.end) out.push(path);
      for (const [ch, child] of [...cur.kids.entries()].sort()) {
        dfs(child, path + ch);
        if (out.length >= k) return;
      }
    };
    dfs(n, p);
    return out;
  }
}

export {};
