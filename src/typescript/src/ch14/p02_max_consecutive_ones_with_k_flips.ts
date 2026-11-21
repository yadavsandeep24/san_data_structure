// P2: Max consecutive ones with k flips
// Source: solutions/ch14/README.md

function longestOnes(a: number[], k: number): number {
  let left = 0;
  let zeros = 0;
  let best = 0;
  for (let right = 0; right < a.length; right++) {
    if (a[right] === 0) zeros++;
    while (zeros > k) {
      if (a[left] === 0) zeros--;
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}

export {};
