
function eq(a: unknown, b: unknown, msg: string) { if (JSON.stringify(a) !== JSON.stringify(b)) throw new Error(msg + ' got ' + JSON.stringify(a) + ' want ' + JSON.stringify(b)); }
const R = (n: number) => Math.floor(Math.random() * n);
for (let t = 0; t < 400; t++) {
  const n = 1 + R(12); const a = Array.from({ length: n }, () => R(10)); const k = 1 + R(n);
  let bw = -Infinity, bl = 0, bo = 0, bf = 0;
  for (let i = 0; i + k <= n; i++) bw = Math.max(bw, a.slice(i, i + k).reduce((x, y) => x + y, 0));
  const bin = a.map(x => x % 2); const kk = R(4); const B = R(30);
  for (let i = 0; i < n; i++) for (let j = i; j < n; j++) {
    const w = a.slice(i, j + 1); const L = j - i + 1;
    if (w.reduce((x, y) => x + y, 0) <= B) bl = Math.max(bl, L);
    if (bin.slice(i, j + 1).filter(x => x === 0).length <= kk) bo = Math.max(bo, L);
    if (new Set(w.map(x => x % 4)).size <= 2) bf = Math.max(bf, L);
  }
  eq(maxWindowSum(a, k), bw, 'mws'); eq(findMaxAverage(a, k), bw / k, 'avg');
  eq(longestWithinBudget(a, B), bl, 'budget'); eq(longestOnes(bin, kk), bo, 'ones'); eq(totalFruit(a.map(x => x % 4)), bf, 'fruit');
}
console.log('ts ok');
