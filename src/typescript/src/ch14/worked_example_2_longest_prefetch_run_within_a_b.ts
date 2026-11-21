// Worked example 2: longest prefetch run within a byte budget (variable window)
// Source: book/part-iv/14-sliding-window.md

function longestWithinBudget(sizes: number[], budget: number): number {
  let left = 0;
  let sum = 0;
  let best = 0;
  for (let right = 0; right < sizes.length; right++) {
    sum += sizes[right];
    while (sum > budget) {
      sum -= sizes[left];
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}

export {};
