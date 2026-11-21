// File system as a tree
// Source: book/part-iii/09-trees-basics.md

type FsNode = {
  name: string;
  isDirectory: boolean;
  children: FsNode[];
};

function walk(n: FsNode, visit: (n: FsNode) => void): void {
  visit(n);
  for (const c of n.children) walk(c, visit);
}

export {};
