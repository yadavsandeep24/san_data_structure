// Q5. Graph Valid Tree (Folder Hierarchy Sanity Check)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function validTree(n: number, edges: number[][]): boolean {
  if (edges.length !== n - 1) return false;
  const parent = Array.from({ length: n }, (_, i) => i);
  const size = new Array<number>(n).fill(1);
  const find = (x: number): number => {
    while (parent[x] !== x) {
      parent[x] = parent[parent[x]]; // path halving
      x = parent[x];
    }
    return x;
  };
  for (const [a, b] of edges) {
    const ra = find(a), rb = find(b);
    if (ra === rb) return false; // edge closes a cycle
    if (size[ra] < size[rb]) { // union by size: hang the smaller tree
      parent[ra] = rb;
      size[rb] += size[ra];
    } else {
      parent[rb] = ra;
      size[ra] += size[rb];
    }
  }
  return true;
}

export {};
