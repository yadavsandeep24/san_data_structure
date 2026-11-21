// Q8. Build Comment Threads from a Flat List (Document Comments)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

type Comment = { id: string; parentId: string | null; at: number; text: string };
type Thread = { comment: Comment; replies: Thread[] };

/** Roots newest first, replies oldest first. Orphans (parent missing) become roots. */
function buildThreads(all: Comment[]): Thread[] {
  const byId = new Map(all.map((c) => [c.id, c]));
  const children = new Map<string, Comment[]>();
  for (const c of all) {
    if (c.parentId === null || !byId.has(c.parentId) || c.parentId === c.id) continue;
    const list = children.get(c.parentId);
    if (list) list.push(c);
    else children.set(c.parentId, [c]);
  }
  const seen = new Set<string>();
  const build = (c: Comment): Thread => {
    seen.add(c.id);
    const kids = (children.get(c.id) ?? []).filter((k) => !seen.has(k.id)).sort((a, b) => a.at - b.at);
    return { comment: c, replies: kids.map(build) };
  };
  return all
    .filter((c) => c.parentId === null || !byId.has(c.parentId) || c.parentId === c.id)
    .sort((a, b) => b.at - a.at)
    .map(build);
}

const countThread = (t: Thread): number => 1 + t.replies.reduce((s, r) => s + countThread(r), 0);

export {};
