// Q4. Find the Bugs in This Function (Recent Completed Envelopes)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

type Envelope = { id: string; status: string; completedAt: number | null };

function recentCompleted(all: Envelope[], n: number): Envelope[] {
  if (!Number.isInteger(n) || n < 0) throw new RangeError(`n must be a non-negative integer, was ${n}`);
  return all
    .filter((e) => e.status.toLowerCase() === "completed" && e.completedAt !== null)
    .sort((a, b) => b.completedAt! - a.completedAt!) // newest first; sort is stable
    .slice(0, n);
}

export {};
