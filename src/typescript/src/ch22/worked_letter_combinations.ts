// Worked: letter combinations (sketch)
// Source: book/part-vi/22-recursion-backtracking.md

function letterCombinations(digits: string): string[] {
  if (!digits) return [];
  const map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"];
  const out: string[] = [];
  const path: string[] = [];
  const dfs = (i: number) => {
    if (i === digits.length) {
      out.push(path.join(""));
      return;
    }
    for (const c of map[digits.charCodeAt(i) - 48]) {
      path.push(c);
      dfs(i + 1);
      path.pop();
    }
  };
  dfs(0);
  return out;
}

export {};
