// Q2. Fast Power with a Modulus (Toy Signature Check)
// Source: book/part-viii/37-math-and-number-drills.md

int modPow(int base, int exponent, int mod) {
  if (exponent < 0 || mod < 1 || mod > 3037000499) throw ArgumentError('bad input');
  var result = 1 % mod;
  var b = ((base % mod) + mod) % mod;
  var e = exponent;
  while (e > 0) {
    if (e & 1 == 1) result = result * b % mod;
    b = b * b % mod;                                 // fits: (mod - 1)^2 < 2^63 on the Dart VM
    e >>= 1;
  }
  return result;
}
