// Worked examples (four languages)
// Source: book/part-ii/05-stacks.md

class Stack<T> {
  private data: T[] = [];
  push(x: T): void { this.data.push(x); }
  pop(): T | undefined { return this.data.pop(); }
  peek(): T | undefined { return this.data[this.data.length - 1]; }
  isEmpty(): boolean { return this.data.length === 0; }
}

function isValid(s: string): boolean {
  const st: string[] = [];
  const pair: Record<string, string> = { ')': '(', ']': '[', '}': '{' };
  for (const c of s) {
    if ('([{'.includes(c)) st.push(c);
    else if (!st.length || st.pop() !== pair[c]) return false;
  }
  return st.length === 0;
}

class MinStack {
  private vals: number[] = [];
  private mins: number[] = [];
  push(x: number): void {
    this.vals.push(x);
    const m = this.mins.length ? Math.min(x, this.mins[this.mins.length - 1]) : x;
    this.mins.push(m);
  }
  pop(): void { this.vals.pop(); this.mins.pop(); }
  top(): number { return this.vals[this.vals.length - 1]; }
  getMin(): number { return this.mins[this.mins.length - 1]; }
}

export {};
