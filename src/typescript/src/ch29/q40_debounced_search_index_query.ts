// Q40. Debounced Search Index Query
// Source: book/part-viii/29-interview-questions-q31-q40.md

class DebouncedSearch {
  private delayMs: number;
  private search: (text: string) => Promise<string[]>;
  private publish: (result: string[]) => void;
  private gen = 0;
  private timer: ReturnType<typeof setTimeout> | undefined;
  constructor(delayMs: number, search: (text: string) => Promise<string[]>, publish: (result: string[]) => void) {
    this.delayMs = delayMs; this.search = search; this.publish = publish;
  }
  onQuery(text: string): void {
    const my = ++this.gen;
    clearTimeout(this.timer);
    this.timer = setTimeout(async () => {
      const result = await this.search(text);
      if (my === this.gen) this.publish(result);
    }, this.delayMs);
  }
}

export {};
