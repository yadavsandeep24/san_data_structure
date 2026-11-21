// Q5. Serialize or Deserialize Binary Tree
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

class TreeNode {
  val: number;
  left: TreeNode | null = null;
  right: TreeNode | null = null;
  constructor(val = 0) { this.val = val; }
}

function serialize(root: TreeNode | null): string {
  if (!root) return "#";
  const q: (TreeNode | null)[] = [root];
  const out: string[] = [];
  while (q.length) {
    const n = q.shift()!;
    if (!n) { out.push("#"); continue; }
    out.push(String(n.val));
    q.push(n.left, n.right);
  }
  return out.join(",");
}

function deserialize(data: string): TreeNode | null {
  if (data === "#" || data === "") return null;
  const parts = data.split(",");
  const root = new TreeNode(+parts[0]);
  const q: TreeNode[] = [root];
  let i = 1;
  while (q.length && i < parts.length) {
    const n = q.shift()!;
    if (parts[i] !== "#") {
      n.left = new TreeNode(+parts[i]);
      q.push(n.left);
    }
    i++;
    if (i < parts.length && parts[i] !== "#") {
      n.right = new TreeNode(+parts[i]);
      q.push(n.right);
    }
    i++;
  }
  return root;
}

export {};
