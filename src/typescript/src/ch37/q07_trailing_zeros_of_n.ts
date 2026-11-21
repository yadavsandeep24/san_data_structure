// Q7. Trailing Zeros of n! (Big Number Sanity Check)
// Source: book/part-viii/37-math-and-number-drills.md

// BigInt: n can be 10^18, which number cannot hold exactly.
function trailingZerosOfFactorial(n: bigint): bigint {
  let count = 0n;
  for (let power = 5n; power <= n; power *= 5n) count += n / power;
  return count;
}

export {};
