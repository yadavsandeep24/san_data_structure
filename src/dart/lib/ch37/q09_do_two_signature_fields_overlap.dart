// Q9. Do Two Signature Fields Overlap? (Field Placement Check)
// Source: book/part-viii/37-math-and-number-drills.md
import 'dart:math';

class Box {
  final int left, top, right, bottom;
  const Box(this.left, this.top, this.right, this.bottom);
}

int overlapArea(Box a, Box b) {
  final int width = min(a.right, b.right) - max(a.left, b.left);     // int is 64-bit: no 32-bit overflow
  final int height = min(a.bottom, b.bottom) - max(a.top, b.top);
  return width > 0 && height > 0 ? width * height : 0;          // touching edges don't overlap
}
