// Q3. Largest Rectangle in Histogram (Biggest Banner in a Bar Chart)
// Source: book/part-viii/33-stacks-binary-search.md

function largestRectangleArea(heights: number[]): number {
  const stack: number[] = []; // indices, heights increasing
  let best = 0;
  for (let i = 0; i <= heights.length; i++) {
    const h = i === heights.length ? 0 : heights[i]; // sentinel flushes the stack
    while (stack.length && heights[stack[stack.length - 1]] >= h) {
      const height = heights[stack.pop()!];
      const left = stack.length ? stack[stack.length - 1] : -1;
      best = Math.max(best, height * (i - left - 1));
    }
    stack.push(i);
  }
  return best;
}

export {};
