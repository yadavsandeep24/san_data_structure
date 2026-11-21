// P1: Course schedule
// Source: solutions/ch25/README.md

function canFinish(numCourses: number, prerequisites: number[][]): boolean {
  const g: number[][] = Array.from({ length: numCourses }, () => []);
  const indeg = new Array(numCourses).fill(0);
  for (const [a, b] of prerequisites) {
    g[b].push(a);
    indeg[a]++;
  }
  const q: number[] = [];
  for (let i = 0; i < numCourses; i++) if (indeg[i] === 0) q.push(i);
  let head = 0, seen = 0;
  while (head < q.length) {
    const u = q[head++];
    seen++;
    for (const v of g[u]) {
      if (--indeg[v] === 0) q.push(v);
    }
  }
  return seen === numCourses;
}

export {};
