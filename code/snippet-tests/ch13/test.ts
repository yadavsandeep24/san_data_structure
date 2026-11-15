
function eq(a: unknown, b: unknown, msg: string) { if (JSON.stringify(a) !== JSON.stringify(b)) throw new Error(msg + ' got ' + JSON.stringify(a) + ' want ' + JSON.stringify(b)); }
for (let t = 0; t < 500; t++) {
  const n = Math.floor(Math.random() * 12);
  const a = Array.from({ length: n }, () => Math.floor(Math.random() * 5) - 2);
  const s = [...a].sort((x, y) => x - y);
  const d = [...s]; const k = dedupeSortedInPlace(d); eq(d.slice(0, k), [...new Set(s)], 'dedupe');
  const m = [...a]; moveZeroes(m); eq(m, [...a.filter(x => x !== 0), ...a.filter(x => x === 0)], 'mz');
  eq(sortedSquares(s), s.map(x => x * x).sort((x, y) => x - y), 'sq');
  const c = a.map(x => Math.abs(x) % 3); const c2 = [...c]; sortColors(c2); eq(c2, [...c].sort(), 'colors');
}
eq(isSubsequence('jdoe', 'John Doe'), true, 'sub1'); eq(isSubsequence('jdx', 'John Doe'), false, 'sub2'); eq(isSubsequence('', 'x'), true, 'sub3');
console.log('ts tests passed');
