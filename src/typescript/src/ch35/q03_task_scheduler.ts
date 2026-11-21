// Q3. Task Scheduler (Notification Cooldown Slots)
// Source: book/part-viii/35-heaps-tries-greedy.md

function leastInterval(tasks: string[], n: number): number {
  if (tasks.length === 0) return 0;
  const freq = new Array<number>(26).fill(0);
  for (const t of tasks) freq[t.charCodeAt(0) - 65]++;
  const maxF = Math.max(...freq);
  const maxCount = freq.filter((f) => f === maxF).length;
  return Math.max(tasks.length, (maxF - 1) * (n + 1) + maxCount);
}

export {};
