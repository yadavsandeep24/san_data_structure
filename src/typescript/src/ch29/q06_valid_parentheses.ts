// Q6. Valid Parentheses (Schema or Deep Link Path)
// Source: book/part-viii/29-interview-questions-q01-q10.md

function isValid(s: string): boolean {
  const st: string[] = [];
  const pair: Record<string, string> = { ")": "(", "]": "[", "}": "{" };
  for (const c of s) {
    if ("([{".includes(c)) st.push(c);
    else if (!st.length || st.pop() !== pair[c]) return false;
  }
  return st.length === 0;
}

export {};
