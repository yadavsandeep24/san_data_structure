// Q4. Container With Most Water (Widest Chart Band)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function maxArea(height: number[]): number {
  let i = 0;
  let j = height.length - 1;
  let best = 0;
  while (i < j) {
    best = Math.max(best, (j - i) * Math.min(height[i], height[j]));
    if (height[i] < height[j]) i++;
    else j--;
  }
  return best;
}

export {};
