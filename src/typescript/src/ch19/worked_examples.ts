// Worked examples (four languages)
// Source: book/part-v/19-efficient-list-rendering.md

type FeedItem = { id: string; title: string };

const keyExtractor = (item: FeedItem) => item.id; // FlatList

type ListEdit =
  | { kind: "insert"; index: number; id: string }
  | { kind: "remove"; id: string }
  | { kind: "update"; id: string };

type Item = { id: string; body: string };

function diff(old: Item[], next: Item[]): ListEdit[] {
  const oldMap = new Map(old.map((o) => [o.id, o]));
  const newIds = new Set(next.map((n) => n.id));
  const edits: ListEdit[] = [];
  for (const o of old) if (!newIds.has(o.id)) edits.push({ kind: "remove", id: o.id });
  next.forEach((n, index) => {
    const prev = oldMap.get(n.id);
    if (!prev) edits.push({ kind: "insert", index, id: n.id });
    else if (prev.body !== n.body) edits.push({ kind: "update", id: n.id });
  });
  return edits;
}

function appendPage(
  buffer: FeedItem[],
  seen: Set<string>,
  page: FeedItem[],
): FeedItem[] {
  const next = buffer.slice();
  for (const item of page) {
    if (seen.has(item.id)) continue;
    seen.add(item.id);
    next.push(item);
  }
  return next;
}

export {};
