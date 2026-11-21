// Q3. 3Sum (Zero-Net Settlement Triples)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function threeSum(nums: number[]): number[][] {
  const a = [...nums].sort((x, y) => x - y);
  const out: number[][] = [];
  for (let i = 0; i < a.length; i++) {
    if (a[i] > 0) break;
    if (i > 0 && a[i] === a[i - 1]) continue;
    let lo = i + 1;
    let hi = a.length - 1;
    while (lo < hi) {
      const sum = a[i] + a[lo] + a[hi];
      if (sum < 0) lo++;
      else if (sum > 0) hi--;
      else {
        out.push([a[i], a[lo], a[hi]]);
        lo++;
        hi--;
        while (lo < hi && a[lo] === a[lo - 1]) lo++;
      }
    }
  }
  return out;
}

export {};
