// Q13. Coin Change II (Ways to Make Change at the Till)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function change(amount: number, coins: number[]): number {
  const ways = new Array<number>(amount + 1).fill(0);
  ways[0] = 1;
  for (const coin of coins) { // coins outer => combinations, not orderings
    for (let a = coin; a <= amount; a++) ways[a] += ways[a - coin];
  }
  return ways[amount];
}

export {};
