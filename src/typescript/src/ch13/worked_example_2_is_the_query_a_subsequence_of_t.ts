// Worked example 2: is the query a subsequence of the name? (one cursor per sequence)
// Source: book/part-iv/13-two-pointers.md

function isSubsequence(query: string, name: string): boolean {
  const q = query.toLowerCase();
  const n = name.toLowerCase();
  let qi = 0;
  for (let ni = 0; ni < n.length && qi < q.length; ni++) {
    if (n[ni] === q[qi]) qi++;
  }
  return qi === q.length;
}

export {};
