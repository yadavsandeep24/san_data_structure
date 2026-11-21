// Q2. Fast Power with a Modulus (Toy Signature Check)
// Source: book/part-viii/37-math-and-number-drills.md

func modPow(_ base: Int, _ exponent: Int, _ mod: Int) -> Int {
    precondition(exponent >= 0 && (1...3_037_000_499).contains(mod))  // (mod - 1)^2 fits in Int64
    var result = 1 % mod
    var b = ((base % mod) + mod) % mod
    var e = exponent
    while e > 0 {
        if e & 1 == 1 { result = result * b % mod }
        b = b * b % mod
        e >>= 1
    }
    return result
}
