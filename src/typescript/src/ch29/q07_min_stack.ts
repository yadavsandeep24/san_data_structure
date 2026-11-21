// Q7. Min Stack (Debug Overlay)
// Source: book/part-viii/29-interview-questions-q01-q10.md

class MinStack {
  private st: [number, number][] = [];
  push(x: number): void {
    const m = this.st.length ? Math.min(x, this.st[this.st.length - 1][1]) : x;
    this.st.push([x, m]);
  }
  pop(): void { this.st.pop(); }
  top(): number { return this.st[this.st.length - 1][0]; }
  getMin(): number { return this.st[this.st.length - 1][1]; }
}

export {};
