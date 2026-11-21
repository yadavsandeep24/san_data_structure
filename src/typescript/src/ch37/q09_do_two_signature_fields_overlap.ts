// Q9. Do Two Signature Fields Overlap? (Field Placement Check)
// Source: book/part-viii/37-math-and-number-drills.md

type Box = { left: number; top: number; right: number; bottom: number };

function overlapArea(a: Box, b: Box): number {
  const width = Math.min(a.right, b.right) - Math.max(a.left, b.left);
  const height = Math.min(a.bottom, b.bottom) - Math.max(a.top, b.top);
  return width > 0 && height > 0 ? width * height : 0;   // touching edges don't overlap
}

export {};
