// JSON as a tree
// Source: book/part-iii/10-trees-practical.md

function flatten(node: unknown, prefix = ''): Map<string, unknown> {
  const out = new Map<string, unknown>();
  function walk(n: unknown, path: string): void {
    if (Array.isArray(n)) {
      if (n.length === 0 && path) out.set(path, n);
      n.forEach((v, i) => walk(v, `${path}[${i}]`));
    } else if (n !== null && typeof n === 'object') {
      const entries = Object.entries(n);
      if (entries.length === 0 && path) out.set(path, n);
      for (const [k, v] of entries) walk(v, path ? `${path}.${k}` : k);
    } else {
      out.set(path, n);
    }
  }
  walk(node, prefix);
  return out;
}

export {};
