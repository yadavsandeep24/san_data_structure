// P2: Paginated feed buffer
// Source: solutions/ch19/README.md

type FeedItem = { id: string; body: string };
type Page = { items: FeedItem[]; nextCursor: string | null };

class FeedBuffer {
  private items: FeedItem[] = [];
  private seen = new Set<string>();
  nextCursor: string | null = null;

  snapshot(): FeedItem[] {
    return this.items.slice();
  }

  append(page: Page): void {
    for (const item of page.items) {
      if (this.seen.has(item.id)) continue;
      this.seen.add(item.id);
      this.items.push(item);
    }
    this.nextCursor = page.nextCursor;
  }

  reset(): void {
    this.items = [];
    this.seen.clear();
    this.nextCursor = null;
  }

  hasMore(): boolean {
    return this.nextCursor != null;
  }
}

export {};
