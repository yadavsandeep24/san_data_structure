
const R = (n: number) => Math.floor(Math.random() * n);
for (let t = 0; t < 300; t++) { const f = Array.from({ length: 1 + R(8) }, () => 1 + R(9)); const d = 1 + R(f.length);
  let q = Math.max(...f); const need = (Q: number) => { let u = 0, c = 1; for (const x of f) { if (u + x > Q) { c++; u = 0; } u += x; } return c; };
  while (need(q) > d) q++; if (minDailyQuota(f, d) !== q) throw new Error('q'); }
console.log('ts ok');
