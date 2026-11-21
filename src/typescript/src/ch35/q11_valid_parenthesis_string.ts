// Q11. Valid Parenthesis String (Template Brackets with Wildcards)
// Source: book/part-viii/35-heaps-tries-greedy.md

function checkValidString(s: string): boolean {
  let lo = 0, hi = 0; // range of possible open-bracket counts
  for (const c of s) {
    if (c === "(") { lo++; hi++; }
    else if (c === ")") { lo--; hi--; }
    else { lo--; hi++; } // '*'
    if (hi < 0) return false;
    if (lo < 0) lo = 0;
  }
  return lo === 0;
}

export {};
