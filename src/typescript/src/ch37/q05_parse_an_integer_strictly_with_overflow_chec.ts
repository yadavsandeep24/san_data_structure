// Q5. Parse an Integer Strictly, with Overflow Checks (Page Number Input)
// Source: book/part-viii/37-math-and-number-drills.md

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

export {};
