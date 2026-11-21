// Q5. Best Time to Buy and Sell Stock (One-Trade Profit)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function maxProfit(prices: number[]): number {
  let minSoFar = Infinity;
  let best = 0;
  for (const p of prices) {
    if (p < minSoFar) minSoFar = p;
    else best = Math.max(best, p - minSoFar);
  }
  return best;
}

export {};
