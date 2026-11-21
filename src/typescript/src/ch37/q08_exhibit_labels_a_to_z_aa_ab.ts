// Q8. Exhibit Labels A to Z, AA, AB (Legal Exhibits)
// Source: book/part-viii/37-math-and-number-drills.md

const INT32_MAX = 2147483647;                       // same limit as Kotlin's Int

function columnTitle(num: number): string {
  if (!Number.isInteger(num) || num <= 0 || num > INT32_MAX) throw new RangeError("need 1.." + INT32_MAX);
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
    const digit = code - 64;
    if (value > Math.floor((INT32_MAX - digit) / 26)) throw new RangeError("label past " + INT32_MAX);
    value = value * 26 + digit;
  }
  return value;
}

export {};
