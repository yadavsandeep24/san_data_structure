// Q3. All Primes up to n (Sieve)
// Source: book/part-viii/37-math-and-number-drills.md

List<int> primesUpTo(int n) {
  if (n < 2) return [];
  final composite = List<bool>.filled(n + 1, false);
  for (var p = 2; p * p <= n; p++) {                 // int is 64-bit, so p * p fits
    if (composite[p]) continue;
    for (var m = p * p; m <= n; m += p) {
      composite[m] = true;                           // start at p², smaller ones are done
    }
  }
  return [for (var x = 2; x <= n; x++) if (!composite[x]) x];
}
