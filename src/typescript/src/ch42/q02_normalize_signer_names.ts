// Q2. Normalize Signer Names (Duplicate Recipients)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

function canonical(name: string): string {
  return name
    .normalize("NFD")
    .replace(/\p{Mn}+/gu, "") // José -> Jose
    .toLowerCase()
    .split(/[\s,]+/)
    .filter((s) => s.length > 0)
    .sort() // "Doe, Jane" == "Jane Doe"
    .join(" ");
}

function duplicateGroups(names: string[]): string[][] {
  const groups = new Map<string, string[]>();
  for (const n of names) {
    const key = canonical(n);
    const g = groups.get(key);
    if (g) g.push(n);
    else groups.set(key, [n]);
  }
  return [...groups.values()].filter((g) => g.length > 1);
}

export {};
