// Q1. GCD and LCM (Reminder Schedules)
// Source: book/part-viii/37-math-and-number-drills.md

int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);

int lcm(int a, int b) {
  if (a <= 0 || b <= 0) throw ArgumentError('need positive inputs');
  final result = BigInt.from(a ~/ gcd(a, b)) * BigInt.from(b);   // divide first; BigInt can't wrap
  if (!result.isValidInt) throw RangeError('lcm does not fit in an int');
  return result.toInt();
}
