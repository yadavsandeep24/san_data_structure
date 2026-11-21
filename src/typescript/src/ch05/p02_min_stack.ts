// P2: Min stack
// Source: solutions/ch05/README.md

class MinStack {
  private vals: number[] = [];
  private mins: number[] = [];

  push(x: number): void {
    this.vals.push(x);
    const m = this.mins.length ? Math.min(x, this.mins[this.mins.length - 1]) : x;
    this.mins.push(m);
  }

  pop(): void {
    this.vals.pop();
    this.mins.pop();
  }

  top(): number { return this.vals[this.vals.length - 1]; }
  getMin(): number { return this.mins[this.mins.length - 1]; }
}

export {};
