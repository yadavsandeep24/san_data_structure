// Q39. Navigation Back Stack
// Source: book/part-viii/29-interview-questions-q31-q40.md

class NavStack {
  private stack: string[] = [];
  push(route: string): void { this.stack.push(route); }
  pop(): string | undefined { return this.stack.pop(); }
  peek(): string | undefined { return this.stack[this.stack.length - 1]; }
  replace(route: string): void {
    if (!this.stack.length) this.stack.push(route);
    else this.stack[this.stack.length - 1] = route;
  }
  popToRoot(): void { if (this.stack.length) this.stack.length = 1; }
  snapshot(): string[] { return this.stack.slice(); }
}

export {};
