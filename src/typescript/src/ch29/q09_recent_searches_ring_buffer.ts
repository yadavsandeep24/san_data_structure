// Q9. Recent Searches Ring Buffer
// Source: book/part-viii/29-interview-questions-q01-q10.md

class RecentSearches {
  private q: string[] = [];
  private head = 0;
  private seen = new Set<string>();
  constructor(private k: number) {}
  add(term: string): void {
    if (this.seen.has(term)) {
      const i = this.q.indexOf(term, this.head);
      if (i >= 0) this.q.splice(i, 1);
    } else {
      this.seen.add(term);
    }
    this.q.push(term);
    while (this.q.length - this.head > this.k) {
      this.seen.delete(this.q[this.head++]);
    }
  }
  list(): string[] { return this.q.slice(this.head).reverse(); }
}

export {};
