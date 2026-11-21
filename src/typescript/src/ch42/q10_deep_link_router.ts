// Q10. Deep-Link Router (Open the Right Envelope Screen)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

type Match<T> = { value: T; params: Record<string, string> };
type RouteNode<T> = {
  kids: Map<string, RouteNode<T>>;
  param: { name: string; node: RouteNode<T> } | null;
  wildcard: T | null;
  value: T | null;
};

const newNode = <T>(): RouteNode<T> => ({ kids: new Map(), param: null, wildcard: null, value: null });
const segments = (s: string) => s.split("?")[0].split("/").filter((p) => p.length > 0);

class Router<T> {
  private root: RouteNode<T> = newNode<T>();

  add(pattern: string, value: T): void {
    let n = this.root;
    for (const seg of segments(pattern)) {
      if (seg === "*") { n.wildcard = value; return; }
      if (seg.startsWith(":")) {
        n.param ??= { name: seg.slice(1), node: newNode<T>() };
        n = n.param.node;
      } else {
        let k = n.kids.get(seg);
        if (!k) { k = newNode<T>(); n.kids.set(seg, k); }
        n = k;
      }
    }
    n.value = value;
  }

  /** Static segments beat :params, which beat *. Backtracks if a static branch dead-ends. */
  match(path: string): Match<T> | null {
    const segs = segments(path);
    const go = (n: RouteNode<T>, i: number, params: Record<string, string>): Match<T> | null => {
      if (i === segs.length) {
        const v = n.value ?? n.wildcard;
        return v === null ? null : { value: v, params };
      }
      const k = n.kids.get(segs[i]);
      const viaStatic = k ? go(k, i + 1, params) : null;
      if (viaStatic) return viaStatic;
      const viaParam = n.param ? go(n.param.node, i + 1, { ...params, [n.param.name]: segs[i] }) : null;
      if (viaParam) return viaParam;
      return n.wildcard === null ? null : { value: n.wildcard, params };
    };
    return go(this.root, 0, {});
  }
}

export {};
