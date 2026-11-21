// Worked examples
// Source: book/part-v/20-decision-guide.md

class Cart {
  private order: string[] = [];
  private qty = new Map<string, number>();

  add(sku: string): void {
    const n = this.qty.get(sku) ?? 0;
    if (n === 0) this.order.push(sku);
    this.qty.set(sku, n + 1);
  }

  contains(sku: string): boolean {
    return this.qty.has(sku);
  }

  lines(): [string, number][] {
    return this.order.map((s) => [s, this.qty.get(s)!]);
  }
}

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

  list(): string[] {
    return this.q.slice(this.head).reverse();
  }
}

export {};
