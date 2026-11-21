// Q11. Short IDs in Base 62 (Signing Link Codes)
// Source: book/part-viii/37-math-and-number-drills.md

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

export {};
