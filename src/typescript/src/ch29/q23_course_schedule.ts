// Q23. Course Schedule (Cycle Detect)
// Source: book/part-viii/29-interview-questions-q21-q30.md

function canFinish(numCourses: number, prerequisites: number[][]): boolean {
  const adj: number[][] = Array.from({ length: numCourses }, () => []);
  const indeg: number[] = Array(numCourses).fill(0);
  for (const [a, b] of prerequisites) { adj[b].push(a); indeg[a]++; }
  const q: number[] = [];
  for (let i = 0; i < numCourses; i++) if (indeg[i] === 0) q.push(i);
  let seen = 0, head = 0;
  while (head < q.length) {
    const u = q[head++]; seen++;
    for (const v of adj[u]) if (--indeg[v] === 0) q.push(v);
  }
  return seen === numCourses;
}

export {};
