// Q5. Text Editor with a Cursor (Note Field on a Form)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

class TextEditor {
  private left: string[] = [];
  private right: string[] = []; // stored backwards: its end is the cursor

  insert(text: string): void {
    for (const ch of text) this.left.push(ch);
  }

  moveLeft(x: number): void {
    for (let k = Math.min(x, this.left.length); k > 0; k--) this.right.push(this.left.pop()!);
  }

  moveRight(x: number): void {
    for (let k = Math.min(x, this.right.length); k > 0; k--) this.left.push(this.right.pop()!);
  }

  backspace(x: number): number {
    const n = Math.min(x, this.left.length);
    this.left.length -= n;
    return n;
  }

  delete(x: number): number {
    const n = Math.min(x, this.right.length);
    this.right.length -= n;
    return n;
  }

  // Up to x characters immediately left of the cursor.
  print(x: number): string {
    return this.left.slice(Math.max(0, this.left.length - x)).join("");
  }

  text(): string {
    return this.left.join("") + [...this.right].reverse().join("");
  }
}

export {};
