// Q2. Fast Power with a Modulus (Toy Signature Check)
// Source: book/part-viii/37-math-and-number-drills.md

// BigInt: b * b can reach ~1e18, past the 2^53 limit where number loses digits.
function modPow(base: bigint, exponent: bigint, mod: bigint): bigint {
  if (exponent < 0n || mod < 1n) throw new RangeError("bad input");
  let result = 1n % mod;
  let b = ((base % mod) + mod) % mod;              // make a negative base positive
  let e = exponent;
  while (e > 0n) {
    if (e & 1n) result = (result * b) % mod;        // this bit is set: multiply it in
    b = (b * b) % mod;                              // square for the next bit
    e >>= 1n;
  }
  return result;
}

export {};
