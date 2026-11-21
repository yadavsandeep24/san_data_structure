// Worked code: append vs insert front
// Source: book/part-ii/03-arrays-dynamic-arrays.md

const end: number[] = [];
end.push(1);                  // O(1) amortized
end.unshift(99);              // O(n) — avoid in hot paths

export {};
