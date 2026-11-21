// Q1. Evaluate Reverse Polish Notation (Calculator Keypad Engine)
// Source: book/part-viii/33-stacks-binary-search.md

function evalRPN(tokens: string[]): number {
  const stack: number[] = [];
  for (const t of tokens) {
    if (t === "+" || t === "-" || t === "*" || t === "/") {
      const b = stack.pop()!;
      const a = stack.pop()!;
      if (t === "+") stack.push(a + b);
      else if (t === "-") stack.push(a - b);
      else if (t === "*") stack.push(a * b);
      else stack.push(Math.trunc(a / b)); // truncate toward zero
    } else {
      stack.push(Number(t));
    }
  }
  return stack.pop()!;
}

export {};
