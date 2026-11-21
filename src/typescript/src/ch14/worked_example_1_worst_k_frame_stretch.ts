// Worked example 1: worst k-frame stretch (fixed window)
// Source: book/part-iv/14-sliding-window.md

function maxWindowSum(frames: number[], k: number): number {
  let sum = 0;
  for (let i = 0; i < k; i++) sum += frames[i];
  let best = sum;
  for (let right = k; right < frames.length; right++) {
    sum += frames[right] - frames[right - k];
    best = Math.max(best, sum);
  }
  return best;
}

export {};
