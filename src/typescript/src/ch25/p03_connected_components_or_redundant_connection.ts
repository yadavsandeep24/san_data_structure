// P3: Connected components or redundant connection
// Source: solutions/ch25/README.md

class UnionFind {
  parent: number[];
  rank: number[];
  components: number;
  constructor(n: number) {
    this.parent = Array.from({ length: n }, (_, i) => i);
    this.rank = Array(n).fill(0);
    this.components = n;
  }
  find(x: number): number {
    if (this.parent[x] !== x) this.parent[x] = this.find(this.parent[x]);
    return this.parent[x];
  }
  union(a: number, b: number): boolean {
    let ra = this.find(a), rb = this.find(b);
    if (ra === rb) return false;
    if (this.rank[ra] < this.rank[rb]) [ra, rb] = [rb, ra];
    this.parent[rb] = ra;
    if (this.rank[ra] === this.rank[rb]) this.rank[ra]++;
    this.components--;
    return true;
  }
}

function countComponents(n: number, edges: number[][]): number {
  const uf = new UnionFind(n);
  for (const [u, v] of edges) uf.union(u, v);
  return uf.components;
}

function findRedundantConnection(edges: number[][]): number[] {
  const uf = new UnionFind(edges.length + 1);
  for (const e of edges) {
    if (!uf.union(e[0], e[1])) return e;
  }
  return [];
}

export {};
