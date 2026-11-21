// P3: Flatten nested map keys
// Source: solutions/ch10/README.md

type Json = null | boolean | number | string | Json[] | { [k: string]: Json };

function flatten(node: Json, prefix = ''): Map<string, Json> {
  const out = new Map<string, Json>();
  const walk = (n: Json, path: string) => {
    if (n !== null && typeof n === 'object' && !Array.isArray(n)) {
      const keys = Object.keys(n);
      if (!keys.length && path) out.set(path, n);
      for (const k of keys) {
        const next = path ? `${path}.${k}` : k;
        walk(n[k], next);
      }
    } else if (Array.isArray(n)) {
      if (!n.length && path) out.set(path, n);
      n.forEach((v, i) => walk(v, `${path}[${i}]`));
    } else {
      out.set(path, n);
    }
  };
  walk(node, prefix);
  return out;
}

export {};
