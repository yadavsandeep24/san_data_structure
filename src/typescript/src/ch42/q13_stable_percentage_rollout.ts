// Q13. Stable Percentage Rollout (New Signing Flow Flag)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

const utf8 = new TextEncoder();

function fnv1a(s: string): number {
  let h = 0x811c9dc5 | 0;
  for (const b of utf8.encode(s)) {
    h ^= b;
    h = Math.imul(h, 0x01000193);
  }
  return h; // signed 32-bit, same bits as the Kotlin Int
}

/** Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags. */
function bucket(flag: string, userId: string): number {
  const h = fnv1a(`${flag}:${userId}`);
  return ((h % 10_000) + 10_000) % 10_000; // floorMod
}

function isOn(flag: string, userId: string, percent: number): boolean {
  return bucket(flag, userId) < Math.trunc(percent * 100);
}

export {};
