// Worked example 1: next higher price (answer on pop)
// Source: book/part-iv/16-monotonic-stack-deque.md

function nextGreaterValues(prices: number[]): number[] {
  const ans = new Array<number>(prices.length).fill(-1);
  const stack: number[] = [];
  for (let i = 0; i < prices.length; i++) {
    while (stack.length > 0 && prices[stack[stack.length - 1]] < prices[i]) {
      ans[stack.pop()!] = prices[i];
    }
    stack.push(i);
  }
  return ans;
}

export {};
