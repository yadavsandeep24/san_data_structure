// P3. Offline-First Feed
// Source: solutions/ch38/README.md

type Entity = { id: string; body: string };
class FeedBuffer {
  private items: Entity[] = [];
  private index = new Map<string, number>();
  applyPage(page: Entity[], prepend: boolean): void {
    const fresh = page.filter((e) => !this.index.has(e.id));
    this.items = prepend ? [...fresh, ...this.items] : [...this.items, ...fresh];
    this.reindex();
  }
  private reindex() {
    this.index.clear();
    this.items.forEach((e, i) => this.index.set(e.id, i));
  }
  snapshot() { return this.items.slice(); }
}

export {};
