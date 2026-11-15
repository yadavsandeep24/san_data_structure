
function eq(a: unknown, b: unknown, msg: string) { if (JSON.stringify(a) !== JSON.stringify(b)) throw new Error(msg + ' got ' + JSON.stringify(a) + ' want ' + JSON.stringify(b)); }
const R = (n: number) => Math.floor(Math.random() * n);
const gen = (): [number, number][] => Array.from({ length: R(7) }, () => { const s = R(15); return [s, s + 1 + R(5)] as [number, number]; });
for (let t = 0; t < 500; t++) {
  const iv = gen();
  const m = mergeBusy(iv);
  for (let x = 0; x < 25; x++) eq(m.some(([s, e]) => s <= x && x < e), iv.some(([s, e]) => s <= x && x < e), 'mcov');
  for (let i = 1; i < m.length; i++) if (m[i][0] <= m[i - 1][1]) throw new Error('not merged');
  let pk = 0; for (let x = 0; x < 25; x++) pk = Math.max(pk, iv.filter(([s, e]) => s <= x && x < e).length);
  eq(peakConcurrent(iv), pk, 'peak');
  eq(canAttendAll(iv), pk <= 1, 'attend');
  const kept = iv.filter((a, i) => !iv.some((b, j) => j !== i && b[0] <= a[0] && a[1] <= b[1] && (b[0] !== a[0] || b[1] !== a[1] || j < i))).length;
  eq(removeCoveredIntervals(iv), kept, 'covered');
  const mk = () => mergeBusy(gen()).filter(([s, e]) => true).map(([s, e]) => [s, e] as [number, number]);
  const A = mk().map(([s, e]) => [s, e - 0] as [number, number]); const B = mk(); const d = 1 + R(4);
  // ensure non-overlapping within list: mergeBusy merges touching -> fine
  let ans: [number, number] | null = null;
  for (let st = 0; st < 30 && !ans; st++) { const ok = (L: [number, number][]) => L.some(([s, e]) => s <= st && st + d <= e); if (ok(A) && ok(B)) ans = [st, st + d]; }
  eq(meetingScheduler(A, B, d), ans, 'sched');
}
console.log('ts ok');
