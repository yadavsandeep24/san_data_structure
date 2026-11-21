// P1: Minimal list diffs (insert / remove / update)
// Source: solutions/ch19/README.md

type Row = { id: string; value: string };
type Edit =
  | { type: "insert"; index: number; id: string }
  | { type: "remove"; id: string }
  | { type: "update"; id: string };

function minimalDiff(old: Row[], neu: Row[]): Edit[] {
  const oldMap = new Map(old.map((r) => [r.id, r]));
  const newIds = new Set(neu.map((r) => r.id));
  const edits: Edit[] = [];
  for (const o of old) {
    if (!newIds.has(o.id)) edits.push({ type: "remove", id: o.id });
  }
  neu.forEach((n, index) => {
    const prev = oldMap.get(n.id);
    if (!prev) edits.push({ type: "insert", index, id: n.id });
    else if (prev.value !== n.value) edits.push({ type: "update", id: n.id });
  });
  return edits;
}

export {};
