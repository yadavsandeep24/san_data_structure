// Q12. Best Time to Buy and Sell Stock with Cooldown (Price Chart Cooldown Rule)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function maxProfit(prices: number[]): number {
  let hold = -Infinity; // own a share
  let sold = 0;         // sold today (cooldown tomorrow)
  let rest = 0;         // no share, free to buy
  for (const p of prices) {
    const prevHold = hold;
    hold = Math.max(hold, rest - p);
    rest = Math.max(rest, sold);
    sold = prevHold + p;
  }
  return Math.max(sold, rest);
}

export {};
