# Chapter 31 — Math & Number Drills

Short math and number questions that show up in document-app and general mobile loops (Docusign-style): schedules, page numbers, page coordinates, exhibit labels, link codes. Each one is small, but each has a trap — usually **overflow**, a **sign**, or an **off-by-one**. This chapter complements the Chapter 24 medium bank and the Chapter 27 hard bank: easier algorithms, stricter edge cases.

Companion index: [`solutions/ch31/README.md`](../../solutions/ch31/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Time** | 15–25 minutes per problem; these are often the warm-up before a harder one |
| **Open** | Restate, one example, then name the edge: 0, negative, the type's limit |
| **Speak first** | Brute force in one line, then the better idea + **time/space complexity before code** |
| **Overflow** | Say out loud which type you use and why (`Long`, `BigInteger`, `BigInt`) before you write it |
| **Languages** | Chapter shows **Kotlin + TypeScript** fully; Swift/Dart for Q2, Q5, Q6, Q12 in `solutions/ch31` |
| **Mobile tell** | One sentence: user input, page coordinates, link security, or memory on a long stream |

Pair this chapter with [Chapter 22 — Bits & Matrix](../part-vi/22-bits-matrix.md) for the bit tricks, and with [Chapter 27](../part-viii/27-hard-drill-bank.md) once these feel easy.

**Overflow cheat sheet**

| Type | Max | Where it bites here |
|------|-----|---------------------|
| Kotlin `Int` | 2,147,483,647 (about 2.1 × 10⁹) | Q5 page numbers, Q8 labels, Q9 box width |
| Kotlin `Long` | about 9.2 × 10¹⁸ | Q1 `lcm`, Q2 squares, Q4 squares, Q7 powers of 5, Q11 decode |
| JS `number` | exact only up to 2⁵³ − 1 (about 9 × 10¹⁵) | anything that needs the full `Long` range → `BigInt` |

---

## Q1. GCD and LCM (Reminder Schedules)

**Topic:** Number theory / Euclid

**Statement**

Signing reminders for one envelope go out every `a` days and expiry warnings every `b` days, both starting today. After how many days do both fire on the same day? Write `gcd` and `lcm`. Example: `gcd(6, 4) = 2`, `lcm(6, 4) = 12`.

**Approach**

Brute force tries every divisor from `min(a, b)` down, or walks the multiples of `a`. Better: Euclid — `gcd(a, b) = gcd(b, a mod b)`; the remainder shrinks fast. Then `lcm = a / gcd × b`. **Divide first**, so the middle value never gets bigger than the answer. The answer itself can still pass `Long.MAX_VALUE`, so use `Math.multiplyExact` to throw instead of returning a wrong number. In TypeScript, `number` is exact only up to 2⁵³ − 1, so check `Number.isSafeInteger` on the result.

**Complexity:** Time O(log min(a, b)), Space O(1)

### Kotlin

```kotlin
tailrec fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

fun lcm(a: Long, b: Long): Long {
    require(a > 0 && b > 0)
    return Math.multiplyExact(a / gcd(a, b), b)        // divide first; throw if it still overflows
}
```

### TypeScript

```typescript
function gcd(a: number, b: number): number {
  while (b !== 0) [a, b] = [b, a % b];
  return a;
}

function lcm(a: number, b: number): number {
  if (!(a > 0 && b > 0)) throw new RangeError("need positive inputs");
  const result = (a / gcd(a, b)) * b;              // divide first
  if (!Number.isSafeInteger(result)) throw new RangeError("lcm above 2^53 - 1");
  return result;
}
```

---

## Q2. Fast Power with a Modulus (Toy Signature Check)

**Topic:** Math / bit manipulation

**Statement**

Compute `(base ^ exponent) mod m` with an exponent up to 10¹², for example inside a hash or a toy RSA-style signature check. Multiplying 10¹² times is too slow. Example: `modPow(3, 13, 7) = 3`.

**Approach**

Binary exponentiation. Write the exponent in binary. Squaring gives base¹, base², base⁴, base⁸, … for free; multiply into the result only the powers whose bit is 1. Take the remainder after every multiply. **Overflow:** both `result * b` and `b * b` are below (m − 1)², and that must fit in a `Long`, so `m` is capped at 3,037,000,499 (10⁹ + 7 is the usual choice). In TypeScript the product can reach about 10¹⁸, far past 2⁵³, so the whole function uses `BigInt`. Make a negative base positive first.

**Complexity:** Time O(log exponent), Space O(1)

### Kotlin

```kotlin
fun modPow(base: Long, exponent: Long, mod: Long): Long {
    require(exponent >= 0 && mod in 1..3_037_000_499L) // so (mod - 1)^2 fits in a Long
    var result = 1L % mod
    var b = ((base % mod) + mod) % mod                  // make a negative base positive
    var e = exponent
    while (e > 0) {
        if (e and 1L == 1L) result = result * b % mod   // this bit is set: multiply it in
        b = b * b % mod                                 // square for the next bit
        e = e shr 1
    }
    return result
}
```

### TypeScript

```typescript
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
```

*(Swift/Dart: same loop — see solutions/ch31.)*

---

## Q3. All Primes up to n (Sieve)

**Topic:** Sieve of Eratosthenes

**Statement**

Return every prime up to `n` (n up to 10⁶) — for example to pick bucket counts for a hash table in an offline document index. Testing each number on its own is O(n√n). Example: `n = 20` → `2, 3, 5, 7, 11, 13, 17, 19`.

**Approach**

Flip the question: instead of asking "what divides x?", take each prime `p` and cross out its multiples once. Start at `p²` — smaller multiples were already crossed out by smaller primes. Stop when `p²` passes `n`. Compute `p * p` as a `Long` in the loop check so it cannot overflow when `n` is near `Int.MAX_VALUE`. Up to 10⁶ there are 78,498 primes.

**Complexity:** Time O(n log log n), Space O(n)

### Kotlin

```kotlin
fun primesUpTo(n: Int): List<Int> {
    if (n < 2) return emptyList()
    val composite = BooleanArray(n + 1)
    var p = 2
    while (p.toLong() * p <= n) {                       // Long so p * p can't overflow near Int.MAX_VALUE
        if (!composite[p]) {
            var multiple = p * p                        // smaller multiples were crossed out by smaller primes
            while (multiple <= n) {
                composite[multiple] = true
                multiple += p
            }
        }
        p++
    }
    return (2..n).filter { !composite[it] }
}
```

### TypeScript

```typescript
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
```

---

## Q4. Integer Square Root without Floating Point (Thumbnail Grid)

**Topic:** Binary search on the answer

**Statement**

Return `⌊√x⌋` for any non-negative `Long`, without `Math.sqrt` — for example to size the smallest square grid of page thumbnails. Floating point can be off by one for large `x`. Example: `isqrt(17) = 4`.

**Approach**

"`r × r ≤ x`" is true for small `r` and false for big `r`, so binary search for the last `r` where it is true. The upper bound is `min(x, 3,037,000,499)` — the largest `r` whose square fits in a `Long`. Round `mid` **up**, or the loop can get stuck at `lo = mid`. Compare `mid <= x / mid` instead of `mid * mid <= x`, so nothing overflows. TypeScript uses `BigInt` to accept the full `Long` range.

**Complexity:** Time O(log x) — about 32 steps for a `Long`; Space O(1)

### Kotlin

```kotlin
fun isqrt(x: Long): Long {
    require(x >= 0)
    var lo = 0L
    var hi = minOf(x, 3_037_000_499L)                   // largest r whose square fits in a Long
    while (lo < hi) {
        val mid = lo + (hi - lo + 1) / 2                // round up so the loop always shrinks
        if (mid <= x / mid) lo = mid else hi = mid - 1  // mid * mid <= x, without overflow
    }
    return lo
}
```

### TypeScript

```typescript
// BigInt so the input can be any 64-bit value, like Kotlin's Long.
function isqrt(x: bigint): bigint {
  if (x < 0n) throw new RangeError("negative");
  let lo = 0n;
  let hi = x < 3_037_000_499n ? x : 3_037_000_499n;
  while (lo < hi) {
    const mid = lo + (hi - lo + 1n) / 2n;           // round up so the loop always shrinks
    if (mid <= x / mid) lo = mid; else hi = mid - 1n;
  }
  return lo;
}
```

---

## Q5. Parse an Integer Strictly, with Overflow Checks (Page Number Input)

**Topic:** Strings / edge cases

**Statement**

Write `parseIntStrict(s)`: an optional sign followed by digits. Return `null` for anything else, or if the value does not fit in an `Int` — for example a "go to page" box in a PDF viewer. Examples: `"-2147483648"` → −2,147,483,648; `"2147483648"` → `null`; `"+0"` → 0; `"12a"` → `null`.

**Approach**

The easy version builds the value in a `Long` and checks the range at the end. Interviewers then ask "now parse a `Long`" — and there is no bigger type. So build the value as a **negative** number: `Int.MIN_VALUE` has no positive twin, but every positive `Int` has a negative one. Before each step, check that `value * 10 - digit` will not go below `Int.MIN_VALUE`: `value < (Int.MIN_VALUE + digit) / 10` means it would. At the end flip the sign back, unless the value is exactly `Int.MIN_VALUE`. Test: empty, a lone sign, `"+0"`, `"-0"`, both limits and one past each. In real code, say you'd use `toIntOrNull()`.

**Complexity:** Time O(length), Space O(1)

### Kotlin

```kotlin
fun parseIntStrict(s: String): Int? {
    if (s.isEmpty()) return null
    val negative = s[0] == '-'
    val start = if (s[0] == '-' || s[0] == '+') 1 else 0
    if (start == s.length) return null                  // a lone sign
    var value = 0                                       // built as a negative: Int.MIN_VALUE has no positive twin
    for (i in start until s.length) {
        val digit = s[i] - '0'
        if (digit !in 0..9) return null
        if (value < (Int.MIN_VALUE + digit) / 10) return null   // value * 10 - digit would overflow
        value = value * 10 - digit
    }
    return if (negative) value else if (value == Int.MIN_VALUE) null else -value
}
```

### TypeScript

```typescript
const INT_MIN = -2147483648;

function parseIntStrict(s: string): number | null {
  if (s.length === 0) return null;
  const negative = s[0] === "-";
  const start = s[0] === "-" || s[0] === "+" ? 1 : 0;
  if (start === s.length) return null;              // a lone sign
  let value = 0;                                    // built as a negative, like the Kotlin version
  for (let i = start; i < s.length; i++) {
    const digit = s.charCodeAt(i) - 48;
    if (digit < 0 || digit > 9) return null;
    if (value < Math.trunc((INT_MIN + digit) / 10)) return null;   // value * 10 - digit would overflow
    value = value * 10 - digit;
  }
  if (negative) return value;
  return value === INT_MIN ? null : 0 - value;      // 0 - value, not -value: "0" must give 0, not -0
}
```

*(Swift/Dart: same negative-accumulator idea — see solutions/ch31.)*

---

## Q6. Fraction to Recurring Decimal (Fee Split Display)

**Topic:** Hash map / long division

**Statement**

Given a numerator and a denominator, return the decimal as a string, with any repeating part in brackets — for example to show a per-signer split of a fee exactly. Examples: `1/3` → `"0.(3)"`, `1/6` → `"0.1(6)"`, `22/7` → `"3.(142857)"`.

**Approach**

Do long division. A repeating part starts the moment a **remainder repeats**. Keep a map `remainder → position in the output`; when a remainder comes back, insert `(` at its position and add `)`. There are at most `d` different remainders, so the loop ends. Get the sign right (exactly one negative) and handle a zero numerator. **Overflow:** `Long.MIN_VALUE / -1` and `abs(Long.MIN_VALUE)` do not fit in a `Long`, so the Kotlin code uses `BigInteger`; TypeScript uses `BigInt` for the same reason.

**Complexity:** Time O(d), Space O(d), where d is the denominator

### Kotlin

```kotlin
fun fractionToDecimal(numerator: Long, denominator: Long): String {
    require(denominator != 0L)
    if (numerator == 0L) return "0"
    val sb = StringBuilder()
    if ((numerator < 0) != (denominator < 0)) sb.append('-')
    val n = BigInteger.valueOf(numerator).abs()         // abs(Long.MIN_VALUE) doesn't fit in a Long
    val d = BigInteger.valueOf(denominator).abs()
    sb.append(n / d)
    var remainder = n % d
    if (remainder == BigInteger.ZERO) return sb.toString()
    sb.append('.')
    val seenAt = HashMap<BigInteger, Int>()             // remainder -> where its digit was written
    while (remainder != BigInteger.ZERO) {
        seenAt[remainder]?.let { start ->
            sb.insert(start, '(').append(')')
            return sb.toString()
        }
        seenAt[remainder] = sb.length
        remainder *= BigInteger.TEN
        sb.append(remainder / d)
        remainder %= d
    }
    return sb.toString()
}
```

### TypeScript

```typescript
// BigInt: |numerator| up to 2^63 is past number's exact range.
function fractionToDecimal(numerator: bigint, denominator: bigint): string {
  if (denominator === 0n) throw new RangeError("divide by zero");
  if (numerator === 0n) return "0";
  let out = (numerator < 0n) !== (denominator < 0n) ? "-" : "";
  const n = numerator < 0n ? -numerator : numerator;
  const d = denominator < 0n ? -denominator : denominator;
  out += (n / d).toString();
  let remainder = n % d;
  if (remainder === 0n) return out;
  out += ".";
  const seenAt = new Map<bigint, number>();          // remainder -> where its digit was written
  while (remainder !== 0n) {
    const start = seenAt.get(remainder);
    if (start !== undefined) return out.slice(0, start) + "(" + out.slice(start) + ")";
    seenAt.set(remainder, out.length);
    remainder *= 10n;
    out += (remainder / d).toString();
    remainder %= d;
  }
  return out;
}
```

*(Swift/Dart: Swift uses `UInt` magnitudes and a 128-bit multiply; Dart uses `BigInt` — see solutions/ch31.)*

---

## Q7. Trailing Zeros of n! (Big Number Sanity Check)

**Topic:** Math / counting factors

**Statement**

How many zeros does `n!` end with, for `n` up to 10¹⁸? Computing `n!` is impossible — it has about n log n digits. Example: `10! = 3,628,800` → 2; `100!` → 24.

**Approach**

Each trailing zero is a 10 = 2 × 5. There are always more 2s than 5s, so count the 5s: `n/5` numbers give one 5, `n/25` give a second, `n/125` a third, and so on. **Overflow:** the power of 5 grows each step; stop before `power * 5` passes `Long.MAX_VALUE`, or it wraps negative and the loop never ends. TypeScript uses `BigInt` because 10¹⁸ is past 2⁵³.

**Complexity:** Time O(log₅ n), Space O(1)

### Kotlin

```kotlin
fun trailingZerosOfFactorial(n: Long): Long {
    var count = 0L
    var power = 5L
    while (power <= n) {
        count += n / power                              // multiples of 5, then extra 5s from 25, 125, ...
        if (power > Long.MAX_VALUE / 5) break           // next power would overflow a Long
        power *= 5
    }
    return count
}
```

### TypeScript

```typescript
// BigInt: n can be 10^18, which number cannot hold exactly.
function trailingZerosOfFactorial(n: bigint): bigint {
  let count = 0n;
  for (let power = 5n; power <= n; power *= 5n) count += n / power;
  return count;
}
```

---

## Q8. Exhibit Labels A to Z, AA, AB (Legal Exhibits)

**Topic:** Base conversion

**Statement**

Legal exhibits in a contract packet are labelled A, B, …, Z, AA, AB, …, like spreadsheet columns. Convert a number to its label and back. Examples: 1 → `"A"`, 26 → `"Z"`, 27 → `"AA"`, 703 → `"AAA"`.

**Approach**

It is base 26, but the digits are 1..26 instead of 0..25 — there is no zero. Subtract 1 before each step and it becomes normal base 26: last letter is `'A' + n % 26`, then `n /= 26`, then reverse. Going back: `value = value × 26 + (letter − 'A' + 1)`. Without the `n--`, 26 comes out wrong. **Overflow:** `Int.MAX_VALUE` is `"FXSHRXW"`; one letter more wraps an `Int`, so decoding uses `Math.multiplyExact` / `Math.addExact`. Reject anything that is not `A..Z`.

**Complexity:** Time O(log₂₆ n) both ways, Space O(length)

### Kotlin

```kotlin
fun columnTitle(number: Int): String {
    require(number > 0)
    val sb = StringBuilder()
    var n = number
    while (n > 0) {
        n--                                             // shift to 0-based: A..Z is 0..25 in each position
        sb.append('A' + n % 26)
        n /= 26
    }
    return sb.reverse().toString()
}

fun columnNumber(title: String): Int {
    require(title.isNotEmpty())
    return title.fold(0) { acc, c ->
        require(c in 'A'..'Z') { "not a label: $title" }
        Math.addExact(Math.multiplyExact(acc, 26), c - 'A' + 1)   // throw instead of wrapping past Int.MAX_VALUE
    }
}
```

### TypeScript

```typescript
function columnTitle(num: number): string {
  if (!Number.isInteger(num) || num <= 0) throw new RangeError("need a positive integer");
  let s = "";
  let n = num;
  while (n > 0) {
    n--;                                            // shift to 0-based
    s = String.fromCharCode(65 + (n % 26)) + s;
    n = Math.floor(n / 26);
  }
  return s;
}

function columnNumber(title: string): number {
  if (title.length === 0) throw new RangeError("empty label");
  let value = 0;
  for (const c of title) {
    const code = c.charCodeAt(0);
    if (code < 65 || code > 90) throw new RangeError("not a label: " + title);
    value = value * 26 + (code - 64);
  }
  if (!Number.isSafeInteger(value)) throw new RangeError("label too long");
  return value;
}
```

---

## Q9. Do Two Signature Fields Overlap? (Field Placement Check)

**Topic:** Geometry / intervals

**Statement**

Fields on a page are axis-aligned boxes `(left, top, right, bottom)`. Return the area where two fields overlap, or 0 — used to stop a sender from placing two signature fields on top of each other. Example: `(0, 0, 4, 3)` and `(2, 1, 6, 5)` → 4.

**Approach**

The shared part is itself a box: left edge = the bigger left, right edge = the smaller right; same for top and bottom. `width = min(rights) − max(lefts)`, `height = min(bottoms) − max(tops)`. Overlap only if **both** are `> 0` — boxes that only touch along an edge share no area. **Overflow:** the width itself can pass `Int.MAX_VALUE` (−10⁹ to 10⁹ is 2 × 10⁹), so subtract as `Long`; the product needs `Long` too. In TypeScript, page coordinates are small, so `number` is exact. With hundreds of fields, sort by left edge and sweep instead of checking every pair.

**Complexity:** Time O(1), Space O(1)

### Kotlin

```kotlin
data class Box(val left: Int, val top: Int, val right: Int, val bottom: Int)

fun overlapArea(a: Box, b: Box): Long {
    val width = minOf(a.right, b.right).toLong() - maxOf(a.left, b.left)
    val height = minOf(a.bottom, b.bottom).toLong() - maxOf(a.top, b.top)
    return if (width > 0 && height > 0) width * height else 0L   // touching edges don't overlap
}
```

### TypeScript

```typescript
type Box = { left: number; top: number; right: number; bottom: number };

function overlapArea(a: Box, b: Box): number {
  const width = Math.min(a.right, b.right) - Math.max(a.left, b.left);
  const height = Math.min(a.bottom, b.bottom) - Math.max(a.top, b.top);
  return width > 0 && height > 0 ? width * height : 0;   // touching edges don't overlap
}
```

---

## Q10. PDF Points to Screen Pixels (Signature Field Overlay)

**Topic:** Geometry / coordinate transforms

**Statement**

A signature field is stored in PDF coordinates: points (1/72 inch), origin at the **bottom-left**, y pointing **up**. The app shows the page fitted to the screen width in pixels, origin **top-left**, y pointing **down**. Map a field to the screen, and a tap back to the page. Example: page 612 × 792 pt shown 1224 px wide (scale 2): PDF `(100, 700)` → screen `(200, 184)`.

**Approach**

Only one number matters: `scale = viewWidthPx / pageWidthPt`. Page → screen: `x × scale`, `(pageHeight − y) × scale` — flip y, then scale. Screen → page is the exact undo in reverse order: `x / scale`, `pageHeight − y / scale`. Keep both directions side by side in one class so they cannot drift apart. Mobile tell: real pages can be rotated (`/Rotate`) and the crop box may not start at 0, so a real renderer uses a full matrix (Android `Matrix`, iOS `CGAffineTransform`); pinch-zoom adds another scale and offset on top.

**Complexity:** Time O(1) per point, Space O(1)

### Kotlin

```kotlin
// PDF: points (1/72 inch), origin bottom-left, y grows up. Screen: pixels, origin top-left, y grows down.
data class PageMapping(val pageWidthPt: Double, val pageHeightPt: Double, val viewWidthPx: Double) {
    val scale = viewWidthPx / pageWidthPt               // pixels per point; fit the page to the view's width

    fun pdfToScreen(xPt: Double, yPt: Double): Pair<Double, Double> =
        xPt * scale to (pageHeightPt - yPt) * scale     // flip y, then scale

    fun screenToPdf(xPx: Double, yPx: Double): Pair<Double, Double> =
        xPx / scale to pageHeightPt - yPx / scale       // undo: unscale, then flip
}
```

### TypeScript

```typescript
// PDF: points, origin bottom-left, y up. Screen: pixels, origin top-left, y down.
class PageMapping {
  readonly pageWidthPt: number;
  readonly pageHeightPt: number;
  readonly scale: number;                           // pixels per point

  constructor(pageWidthPt: number, pageHeightPt: number, viewWidthPx: number) {
    this.pageWidthPt = pageWidthPt;
    this.pageHeightPt = pageHeightPt;
    this.scale = viewWidthPx / pageWidthPt;         // fit the page to the view's width
  }

  pdfToScreen(xPt: number, yPt: number): [number, number] {
    return [xPt * this.scale, (this.pageHeightPt - yPt) * this.scale];   // flip y, then scale
  }

  screenToPdf(xPx: number, yPx: number): [number, number] {
    return [xPx / this.scale, this.pageHeightPt - yPx / this.scale];     // unscale, then flip
  }
}
```

---

## Q11. Short IDs in Base 62 (Signing Link Codes)

**Topic:** Base conversion

**Statement**

Turn a numeric envelope ID into a short code for a signing link, using `0-9`, `A-Z`, `a-z` (62 characters), and back. Examples: 61 → `"z"`, 62 → `"10"`, 125 → `"21"`.

**Approach**

Same as writing a number in decimal, with 62 digits instead of 10: take `value % 62`, look up the character, divide by 62, repeat, reverse. Decode: `value = value × 62 + digit`. An 11-character code covers any `Long` (`Long.MAX_VALUE` is `"AzL8n0Y58m7"`). **Overflow:** decoding untrusted text must reject unknown characters and values past `Long.MAX_VALUE` — `Math.multiplyExact` / `Math.addExact` throw instead of wrapping. TypeScript uses `BigInt` and the same `Long` limit. Security tell: sequential IDs are guessable, so a signing link also needs a random token and a server-side check.

**Complexity:** Time O(log₆₂ n), Space O(length)

### Kotlin

```kotlin
private const val ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

fun toBase62(value: Long): String {
    require(value >= 0)
    if (value == 0L) return "0"
    val sb = StringBuilder()
    var v = value
    while (v > 0) {
        sb.append(ALPHABET[(v % 62).toInt()])
        v /= 62
    }
    return sb.reverse().toString()
}

fun fromBase62(text: String): Long {
    require(text.isNotEmpty())
    return text.fold(0L) { acc, c ->
        val digit = ALPHABET.indexOf(c)
        require(digit >= 0) { "not base62: $c" }
        Math.addExact(Math.multiplyExact(acc, 62L), digit.toLong())   // throw instead of silently wrapping
    }
}
```

### TypeScript

```typescript
const ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const LONG_MAX = 9223372036854775807n;              // same range as a Kotlin Long

function toBase62(value: bigint): string {
  if (value < 0n || value > LONG_MAX) throw new RangeError("out of range");
  if (value === 0n) return "0";
  let s = "";
  for (let v = value; v > 0n; v /= 62n) s = ALPHABET[Number(v % 62n)] + s;
  return s;
}

function fromBase62(text: string): bigint {
  if (text.length === 0) throw new RangeError("empty code");
  let value = 0n;
  for (const c of text) {
    const digit = ALPHABET.indexOf(c);
    if (digit < 0) throw new RangeError("not base62: " + c);
    value = value * 62n + BigInt(digit);
    if (value > LONG_MAX) throw new RangeError("code too large");   // reject instead of growing forever
  }
  return value;
}
```

---

## Q12. Random Sample from a Stream (Reservoir Sampling of Audit Events)

**Topic:** Randomised / streaming

**Statement**

Audit events (opened, viewed, signed) stream past, and you don't know how many there will be. Keep a uniformly random sample of `k` of them using O(k) memory — for example to upload a small debug sample from a device. Example: stream 1..10, k = 3 → e.g. `[7, 2, 9]`; over many runs each item is kept about 30% of the time.

**Approach**

Brute force stores everything, shuffles, takes `k` — O(n) memory. Better: keep `k` slots. Put the first `k` items in. For item `i` (0-based) after that, pick a random `j` in `0..i`; if `j < k`, replace slot `j`. Why it is fair: item `i` gets in with chance `k/(i+1)`, and each later item `t` kicks it out with chance `1/(t+1)`; the product is `k/n` for everyone. Pass the `Random` in, so tests can use a seed. Kotlin uses `nextLong(i + 1L)` so the range math is done in `Long`.

**Complexity:** Time O(n), Space O(k), one pass

### Kotlin

```kotlin
fun <T> reservoirSample(items: Sequence<T>, k: Int, random: Random = Random.Default): List<T> {
    require(k >= 0)
    val reservoir = ArrayList<T>(k)
    items.forEachIndexed { i, item ->
        if (i < k) reservoir.add(item)
        else {
            val j = random.nextLong(i + 1L)             // keep item i with probability k / (i + 1)
            if (j < k) reservoir[j.toInt()] = item
        }
    }
    return reservoir
}
```

### TypeScript

```typescript
// rand() returns a float in [0, 1); pass a seeded one in tests.
function reservoirSample<T>(items: Iterable<T>, k: number, rand: () => number = Math.random): T[] {
  const reservoir: T[] = [];
  let i = 0;
  for (const item of items) {
    if (i < k) reservoir.push(item);
    else {
      const j = Math.floor(rand() * (i + 1));        // keep item i with probability k / (i + 1)
      if (j < k) reservoir[j] = item;
    }
    i++;
  }
  return reservoir;
}
```

*(Swift/Dart: same loop with an injected generator — see solutions/ch31.)*

---

## Drill checklist (say aloud)

1. Brute force in one line, then complexity **before** code.  
2. Name the type and its limit: `Int`, `Long`, `BigInteger`, `BigInt` — and where it could overflow.  
3. Divide before you multiply; compare `a <= x / b` instead of `a * b <= x`.  
4. Edges: 0, 1, negative, empty string, a lone sign, the exact limit and one past it.  
5. One mobile sentence: user input, page coordinates, link security, or memory on a stream.

Related: [Chapter 24 — Interview Questions](../part-vii/24-interview-questions.md) · [Chapter 27 — Hard Drill Bank](../part-viii/27-hard-drill-bank.md)
