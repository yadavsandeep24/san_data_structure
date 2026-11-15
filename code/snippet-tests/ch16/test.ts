
function eq(a: unknown, b: unknown, msg: string) { if (JSON.stringify(a) !== JSON.stringify(b)) throw new Error(msg + ' got ' + JSON.stringify(a) + ' want ' + JSON.stringify(b)); }
const R = (n: number) => Math.floor(Math.random() * n);
for (let t = 0; t < 400; t++) {
  const n = 1 + R(10); const a = Array.from({ length: n }, () => R(6));
  eq(nextGreaterValues(a), a.map((x, i) => { for (let j = i + 1; j < n; j++) if (a[j] > x) return a[j]; return -1; }), 'ng');
  eq(nextGreaterCircular(a), a.map((x, i) => { for (let d = 1; d < n; d++) if (a[(i + d) % n] > x) return a[(i + d) % n]; return -1; }), 'ngc');
  const ps = new PriceSpan(); a.forEach((x, i) => { let s = 0; for (let j = i; j >= 0 && a[j] <= x; j--) s++; eq(ps.next(x), s, 'span'); });
  let tot = 0; for (let i = 0; i < n; i++) for (let j = i; j < n; j++) tot += Math.min(...a.slice(i, j + 1)); eq(sumSubarrayMins(a), tot, 'ssm');
  const num = a.map(String).join(''); const k = R(n + 1);
  // brute: best over all subsets of size n-k
  let best: string | null = null;
  const rec = (i: number, cur: string) => { if (cur.length === n - k) { const v = cur.replace(/^0+/, '') || '0'; if (best === null || v.length < best.length || (v.length === best.length && v < best)) best = v; return; } if (i === n) return; rec(i + 1, cur + num[i]); rec(i + 1, cur); };
  rec(0, ''); eq(removeKdigits(num, k), best, 'rk ' + num + ' ' + k);
}
console.log('ts ok');
