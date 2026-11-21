// Q6. Fraction to Recurring Decimal (Fee Split Display)
// Source: book/part-viii/37-math-and-number-drills.md

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

export {};
