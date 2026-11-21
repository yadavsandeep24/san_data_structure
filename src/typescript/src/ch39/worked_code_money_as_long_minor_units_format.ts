// Worked code (a) — Money as Long minor units + format
// Source: book/part-ix/39-money-idempotency-reliability.md

export type Money = { amountMinor: number; currencyCode: string }; // use bigint in strict ledgers

export function addMoney(a: Money, b: Money): Money {
  if (a.currencyCode !== b.currencyCode) throw new Error("currency mismatch");
  return { amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode };
}

export function formatMoney(m: Money, locale = "en-IN"): string {
  return new Intl.NumberFormat(locale, {
    style: "currency",
    currency: m.currencyCode,
  }).format(m.amountMinor / 100);
}

/** Parse "199.99" → 19999 minor units; avoids parseFloat drift for 2-decimal currencies. */
export function parseMajorToMinor(text: string, scale = 2): number {
  const t = text.trim();
  const neg = t.startsWith("-");
  const raw = neg ? t.slice(1) : t;
  const [w, f = ""] = raw.split(".");
  const frac = (f + "0".repeat(scale)).slice(0, scale);
  const minor = Number(w) * 10 ** scale + Number(frac || 0);
  return neg ? -minor : minor;
}

export {};
