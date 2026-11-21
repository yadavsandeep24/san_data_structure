// Q2. Contains Duplicate (Dedupe Guard)
// Source: book/part-viii/29-interview-questions-q01-q10.md

function containsDuplicate(nums: number[]): boolean {
  const s = new Set<number>();
  for (const x of nums) {
    if (s.has(x)) return true;
    s.add(x);
  }
  return false;
}

export {};
