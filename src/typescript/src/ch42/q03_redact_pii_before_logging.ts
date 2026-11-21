// Q3. Redact PII Before Logging (Crash Reports)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

const EMAIL = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g;
const PHONE = /\+?\d[\d\s-]{8,}\d/g;

function redact(text: string): string {
  return text
    .replace(EMAIL, (v) => v[0] + "***" + v.substring(v.indexOf("@")))
    .replace(PHONE, (m) => {
      const digits = m.replace(/\D/g, "");
      return "•".repeat(Math.max(0, digits.length - 4)) + digits.slice(-4);
    });
}

export {};
