
function eq(a: unknown, b: unknown, msg: string) { if (JSON.stringify(a) !== JSON.stringify(b)) throw new Error(msg + ' got ' + JSON.stringify(a) + ' want ' + JSON.stringify(b)); }
const R = (n: number) => Math.floor(Math.random() * n);
for (let t = 0; t < 400; t++) {
  const n = 1 + R(10); const a = Array.from({ length: n }, () => R(9) - 4);
  const sr = new SpendRanges(a); const l = R(n), r = l + R(n - l);
  eq(sr.total(l, r), a.slice(l, r + 1).reduce((x, y) => x + y, 0), 'range');
  const H = 1 + R(8); const bk: [number, number][] = Array.from({ length: R(6) }, () => { const s = R(H); return [s, s + R(H - s)] as [number, number]; });
  eq(bookingsPerHour(H, bk), Array.from({ length: H }, (_, h) => bk.filter(([s, e]) => s <= h && h <= e).length), 'book');
  let piv = -1; for (let i = 0; i < n && piv < 0; i++) { if (a.slice(0, i).reduce((x, y) => x + y, 0) === a.slice(i + 1).reduce((x, y) => x + y, 0)) piv = i; }
  eq(pivotIndex(a), piv, 'pivot');
  const b = a.map(x => (x + 4) % 2); let bl = 0;
  for (let i = 0; i < n; i++) for (let j = i; j < n; j++) { const w = b.slice(i, j + 1); if (w.filter(x => x === 1).length * 2 === w.length) bl = Math.max(bl, w.length); }
  eq(findMaxLength(b), bl, 'fml');
  const trips: [number, number, number][] = Array.from({ length: R(5) }, () => { const f = R(10); return [1 + R(4), f, f + 1 + R(5)] as [number, number, number]; });
  const cap = R(10); let ok = true; for (let x = 0; x <= 20; x++) { if (trips.filter(([, f, to]) => f <= x && x < to).reduce((s, tr) => s + tr[0], 0) > cap) ok = false; }
  eq(carPooling(trips, cap), ok, 'car');
}
console.log('ts ok');
