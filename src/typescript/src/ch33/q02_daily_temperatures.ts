// Q2. Daily Temperatures (Warmer-Day Countdown)
// Source: book/part-viii/33-stacks-binary-search.md

function dailyTemperatures(temps: number[]): number[] {
  const ans = new Array<number>(temps.length).fill(0);
  const stack: number[] = []; // indices, temperatures strictly decreasing
  for (let i = 0; i < temps.length; i++) {
    while (stack.length && temps[stack[stack.length - 1]] < temps[i]) {
      const j = stack.pop()!;
      ans[j] = i - j;
    }
    stack.push(i);
  }
  return ans;
}

export {};
