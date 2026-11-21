// Worked example 2: online price span (answer after popping)
// Source: book/part-iv/16-monotonic-stack-deque.md

class PriceSpan {
  private prices: number[] = [];
  private spans: number[] = [];
  next(price: number): number {
    let span = 1;
    while (this.prices.length > 0 && this.prices[this.prices.length - 1] <= price) {
      this.prices.pop();
      span += this.spans.pop()!;
    }
    this.prices.push(price);
    this.spans.push(span);
    return span;
  }
}

export {};
