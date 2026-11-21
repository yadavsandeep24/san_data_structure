// Binary search on the answer
// Source: book/part-vi/21-searching-sorting.md

function minDailyQuota(files: number[], days: number): number {
  const daysNeeded = (quota: number): number => {
    let used = 0;
    let count = 1;
    for (const f of files) {
      if (used + f > quota) {
        count++;
        used = 0;
      }
      used += f;
    }
    return count;
  };
  let lo = Math.max(...files);
  let hi = files.reduce((s, x) => s + x, 0);
  while (lo < hi) {
    const mid = lo + Math.floor((hi - lo) / 2);
    if (daysNeeded(mid) <= days) hi = mid;
    else lo = mid + 1;
  }
  return lo;
}

export {};
