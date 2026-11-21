// Worked code: sets in four languages
// Source: book/part-iii/08-sets.md

const seen = new Set<string>();
seen.add('p1');
seen.add('p1');
console.log(seen.has('p1'));   // true

// Insertion order preserved
const ordered = new Set<string>(['first', 'second']);
console.log([...ordered]);     // ['first', 'second']

export {};
