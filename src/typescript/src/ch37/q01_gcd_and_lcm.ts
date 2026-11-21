// Q1. GCD and LCM (Reminder Schedules)
// Source: book/part-viii/37-math-and-number-drills.md

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

export {};
