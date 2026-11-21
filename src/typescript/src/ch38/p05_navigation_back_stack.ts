// P5. Navigation Back Stack
// Source: solutions/ch38/README.md

class NavStack {
  private stack: string[] = [];
  push(r: string) { this.stack.push(r); }
  pop() { return this.stack.pop(); }
  peek() { return this.stack[this.stack.length - 1]; }
  replace(r: string) {
    if (!this.stack.length) this.push(r); else this.stack[this.stack.length - 1] = r;
  }
  popToRoot() { if (this.stack.length) this.stack.length = 1; }
  snapshot() { return this.stack.slice(); }
}

export {};
