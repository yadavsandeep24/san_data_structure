# Chapter 31 — Solution Index & Extra Ports

Full **Kotlin, Swift, Dart and TypeScript** solutions live inline in [`book/part-ix/31-math-and-number-drills.md`](../../book/part-ix/31-math-and-number-drills.md). This file adds a timed-review index, plus notes on the Swift/Dart ports of the most interview-heavy problems (the same code is also inline in the chapter).

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-ix/31-math-and-number-drills.md#q1-gcd-and-lcm-reminder-schedules) | GCD and LCM | Euclid | `gcd(b, a % b)` until 0; `lcm = a / gcd * b` with `multiplyExact` |
| [Q2](../../book/part-ix/31-math-and-number-drills.md#q2-fast-power-with-a-modulus-toy-signature-check) | Fast Power with a Modulus | Binary exponentiation | Square the base each bit; multiply in set bits; mod ≤ 3,037,000,499 so squares fit a `Long` |
| [Q3](../../book/part-ix/31-math-and-number-drills.md#q3-all-primes-up-to-n-sieve) | All Primes up to n | Sieve | Cross out multiples from `p²` while `p² ≤ n` (check as `Long`) |
| [Q4](../../book/part-ix/31-math-and-number-drills.md#q4-integer-square-root-without-floating-point-thumbnail-grid) | Integer Square Root | Binary search | Last `r` with `r ≤ x / r`; round mid up; cap hi at 3,037,000,499 |
| [Q5](../../book/part-ix/31-math-and-number-drills.md#q5-parse-an-integer-strictly-with-overflow-checks-page-number-input) | Parse an Integer Strictly | Strings / overflow | Build as a negative; reject if `value < (MIN + digit) / 10` |
| [Q6](../../book/part-ix/31-math-and-number-drills.md#q6-fraction-to-recurring-decimal-fee-split-display) | Fraction to Recurring Decimal | Hash map | Long division; map remainder → position; repeat ⇒ wrap in brackets; `BigInteger` for `Long.MIN_VALUE` |
| [Q7](../../book/part-ix/31-math-and-number-drills.md#q7-trailing-zeros-of-n-big-number-sanity-check) | Trailing Zeros of n! | Counting factors | Sum `n / 5^k`; stop before the power of 5 overflows |
| [Q8](../../book/part-ix/31-math-and-number-drills.md#q8-exhibit-labels-a-to-z-aa-ab-legal-exhibits) | Exhibit Labels A to Z, AA, AB | Base 26, no zero | `n--` then `n % 26` each step; decode `acc * 26 + (c - 'A' + 1)` with exact math |
| [Q9](../../book/part-ix/31-math-and-number-drills.md#q9-do-two-signature-fields-overlap-field-placement-check) | Do Two Signature Fields Overlap? | Geometry | `min(rights) − max(lefts)` × same for y, both `> 0`, in `Long` |
| [Q10](../../book/part-ix/31-math-and-number-drills.md#q10-pdf-points-to-screen-pixels-signature-field-overlay) | PDF Points to Screen Pixels | Coordinate transform | One `scale`; flip y then scale; undo in reverse order |
| [Q11](../../book/part-ix/31-math-and-number-drills.md#q11-short-ids-in-base-62-signing-link-codes) | Short IDs in Base 62 | Base conversion | Repeated `% 62` / `/ 62`; decode with `multiplyExact`, reject bad chars |
| [Q12](../../book/part-ix/31-math-and-number-drills.md#q12-random-sample-from-a-stream-reservoir-sampling-of-audit-events) | Random Sample from a Stream | Reservoir sampling | Keep first k; item i replaces slot `j = rand(0..i)` if `j < k` |

---

## Q2 — Fast power with a modulus (Swift / Dart)

Both use 64-bit `Int`, so the same 3,037,000,499 cap applies. Swift traps on overflow instead of wrapping; Dart's VM `int` wraps silently, so the cap matters even more there (and on Dart web, `int` is a JS double — use `BigInt.modPow`).

### Swift

```swift
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
```

### Dart

```dart
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
```

---

## Q5 — Parse an integer strictly (Swift / Dart)

Swift targets `Int32` so the limits match Kotlin's `Int`. Dart has no 32-bit int type, so the limits are constants.

### Swift

```swift
func parseIntStrict(_ s: String) -> Int32? {
    let chars = Array(s.utf8)
    guard let first = chars.first else { return nil }
    let negative = first == UInt8(ascii: "-")
    let start = (first == UInt8(ascii: "-") || first == UInt8(ascii: "+")) ? 1 : 0
    if start == chars.count { return nil }
    var value: Int32 = 0                                // built as a negative, like the Kotlin version
    for c in chars[start...] {
        guard c >= UInt8(ascii: "0") && c <= UInt8(ascii: "9") else { return nil }
        let digit = Int32(c - UInt8(ascii: "0"))
        if value < (Int32.min + digit) / 10 { return nil }  // value * 10 - digit would overflow
        value = value * 10 - digit
    }
    if negative { return value }
    return value == Int32.min ? nil : -value
}
```

### Dart

```dart
const int intMin = -2147483648;                      // 32-bit limits; Dart's own int is 64-bit

int? parseIntStrict(String s) {
  if (s.isEmpty) return null;
  final negative = s[0] == '-';
  final start = (s[0] == '-' || s[0] == '+') ? 1 : 0;
  if (start == s.length) return null;
  var value = 0;                                     // built as a negative, like the Kotlin version
  for (var i = start; i < s.length; i++) {
    final digit = s.codeUnitAt(i) - 48;
    if (digit < 0 || digit > 9) return null;
    if (value < (intMin + digit) ~/ 10) return null; // value * 10 - digit would overflow
    value = value * 10 - digit;
  }
  if (negative) return value;
  return value == intMin ? null : -value;
}
```

---

## Q6 — Fraction to recurring decimal (Swift / Dart)

Swift has no built-in big integer. It uses `UInt` magnitudes (so `|Int.min|` fits) and a 128-bit multiply/divide for `remainder * 10`, which can pass `UInt64.max` when the denominator is huge. Dart uses `BigInt`, like the Kotlin version.

### Swift

```swift
func fractionToDecimal(_ numerator: Int, _ denominator: Int) -> String {
    precondition(denominator != 0)
    if numerator == 0 { return "0" }
    var out = (numerator < 0) != (denominator < 0) ? "-" : ""
    let n = numerator.magnitude, d = denominator.magnitude   // UInt: |Int.min| fits
    out += String(n / d)
    var remainder = n % d
    if remainder == 0 { return out }
    out += "."
    var digits: [Character] = []
    var seenAt: [UInt: Int] = [:]                       // remainder -> index in digits
    while remainder != 0 {
        if let start = seenAt[remainder] {
            return out + String(digits[..<start]) + "(" + String(digits[start...]) + ")"
        }
        seenAt[remainder] = digits.count
        // remainder * 10 can pass UInt64.max, so use the full 128-bit product
        let (q, r) = d.dividingFullWidth(remainder.multipliedFullWidth(by: 10))
        digits.append(Character(String(q)))
        remainder = r
    }
    return out + String(digits)
}
```

### Dart

```dart
String fractionToDecimal(int numerator, int denominator) {
  if (denominator == 0) throw ArgumentError('divide by zero');
  if (numerator == 0) return '0';
  final sb = StringBuffer();
  if ((numerator < 0) != (denominator < 0)) sb.write('-');
  final n = BigInt.from(numerator).abs();            // abs of the min 64-bit int needs BigInt
  final d = BigInt.from(denominator).abs();
  sb.write(n ~/ d);
  var remainder = n % d;
  if (remainder == BigInt.zero) return sb.toString();
  sb.write('.');
  var out = sb.toString();
  final seenAt = <BigInt, int>{};                    // remainder -> where its digit was written
  while (remainder != BigInt.zero) {
    final start = seenAt[remainder];
    if (start != null) return '${out.substring(0, start)}(${out.substring(start)})';
    seenAt[remainder] = out.length;
    remainder *= BigInt.from(10);
    out += (remainder ~/ d).toString();
    remainder %= d;
  }
  return out;
}
```

---

## Q12 — Reservoir sampling (Swift / Dart)

Inject the generator so tests can seed it (Swift: any `RandomNumberGenerator`, e.g. a small SplitMix64; Dart: `Random(seed)`).

### Swift

```swift
func reservoirSample<T, S: Sequence, G: RandomNumberGenerator>(
    _ items: S, _ k: Int, using rng: inout G
) -> [T] where S.Element == T {
    var reservoir: [T] = []
    reservoir.reserveCapacity(k)
    for (i, item) in items.enumerated() {
        if i < k { reservoir.append(item) }
        else {
            let j = Int.random(in: 0...i, using: &rng)  // keep item i with probability k / (i + 1)
            if j < k { reservoir[j] = item }
        }
    }
    return reservoir
}
```

### Dart

```dart
import 'dart:math';

List<T> reservoirSample<T>(Iterable<T> items, int k, [Random? random]) {
  final rng = random ?? Random();
  final reservoir = <T>[];
  var i = 0;
  for (final item in items) {
    if (i < k) {
      reservoir.add(item);
    } else {
      final j = rng.nextInt(i + 1);                  // keep item i with probability k / (i + 1)
      if (j < k) reservoir[j] = item;
    }
    i++;
  }
  return reservoir;
}
```

---

## Counts

- **12** math & number drills — Kotlin, Swift, Dart, TS in chapter  
- **4** Swift/Dart ports repeated here with porting notes (Q2, Q5, Q6, Q12)  
- Timed protocol: **15–25 min**, complexity and overflow plan spoken first  

Back: [Chapter 31](../../book/part-ix/31-math-and-number-drills.md)
