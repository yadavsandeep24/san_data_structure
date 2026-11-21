// P1: Queue with two stacks
// Source: solutions/ch06/README.md

class MyQueue {
  private inbound: number[] = [];
  private outbound: number[] = [];

  push(x: number): void { this.inbound.push(x); }

  pop(): number {
    this.move();
    return this.outbound.pop()!;
  }

  peek(): number {
    this.move();
    return this.outbound[this.outbound.length - 1];
  }

  empty(): boolean { return !this.inbound.length && !this.outbound.length; }

  private move(): void {
    if (!this.outbound.length) {
      while (this.inbound.length) this.outbound.push(this.inbound.pop()!);
    }
  }
}

export {};
