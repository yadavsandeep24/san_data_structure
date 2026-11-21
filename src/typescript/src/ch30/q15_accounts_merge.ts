// Q15. Accounts Merge (Union-Find Hard)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

function accountsMerge(accounts: string[][]): string[][] {
  const parent = new Map<string, string>();
  const emailName = new Map<string, string>();
  const find = (x: string): string => {
    if (parent.get(x) !== x) parent.set(x, find(parent.get(x)!));
    return parent.get(x)!;
  };
  const union = (a: string, b: string) => parent.set(find(a), find(b));
  for (const acc of accounts) {
    const name = acc[0];
    for (let i = 1; i < acc.length; i++) {
      const e = acc[i];
      if (!parent.has(e)) parent.set(e, e);
      emailName.set(e, name);
      union(acc[1], e);
    }
  }
  const groups = new Map<string, string[]>();
  for (const e of parent.keys()) {
    const r = find(e);
    if (!groups.has(r)) groups.set(r, []);
    groups.get(r)!.push(e);
  }
  return [...groups.entries()].map(([root, emails]) => {
    emails.sort();
    return [emailName.get(root)!, ...emails];
  });
}

export {};
