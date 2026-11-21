// Q11. Simplify a Signature Stroke (Ramer-Douglas-Peucker)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
import 'dart:math';

class Pt {
  final double x, y;
  const Pt(this.x, this.y);
}

double distToSegment(Pt p, Pt a, Pt b) {
  final dx = b.x - a.x, dy = b.y - a.y;
  final len2 = dx * dx + dy * dy;
  double len(double x, double y) => sqrt(x * x + y * y);
  if (len2 == 0) return len(p.x - a.x, p.y - a.y);
  final t = (((p.x - a.x) * dx + (p.y - a.y) * dy) / len2).clamp(0.0, 1.0);
  return len(p.x - (a.x + t * dx), p.y - (a.y + t * dy));
}

/// Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack.
List<Pt> simplify(List<Pt> points, double epsilon) {
  if (points.length < 3) return points;
  final keep = List<bool>.filled(points.length, false);
  keep[0] = keep[points.length - 1] = true;
  final stack = <(int, int)>[(0, points.length - 1)];
  while (stack.isNotEmpty) {
    final (s, e) = stack.removeLast();
    var maxD = 0.0, idx = -1;
    for (var i = s + 1; i < e; i++) {
      final d = distToSegment(points[i], points[s], points[e]);
      if (d > maxD) {
        maxD = d;
        idx = i;
      }
    }
    if (maxD > epsilon) {
      keep[idx] = true;
      stack..add((s, idx))..add((idx, e));
    }
  }
  return [for (var i = 0; i < points.length; i++) if (keep[i]) points[i]];
}
