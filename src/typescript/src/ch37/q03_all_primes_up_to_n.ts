// Q3. All Primes up to n (Sieve)
// Source: book/part-viii/37-math-and-number-drills.md

function primesUpTo(n: number): number[] {
  if (n < 2) return [];
  const composite = new Uint8Array(n + 1);
  for (let p = 2; p * p <= n; p++) {
    if (composite[p]) continue;
    for (let m = p * p; m <= n; m += p) composite[m] = 1;   // start at p², smaller ones are done
  }
  const primes: number[] = [];
  for (let x = 2; x <= n; x++) if (!composite[x]) primes.push(x);
  return primes;
}

export {};
