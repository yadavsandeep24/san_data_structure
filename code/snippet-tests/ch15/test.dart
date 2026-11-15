
import 'dart:math';
void eq(Object? a, Object? b, String m) { if (a.toString() != b.toString()) throw Exception('$m got $a want $b'); }
int sumL(List<int> l) => l.fold(0, (x, y) => x + y);
void main() {
  final r = Random(5);
  for (var t = 0; t < 400; t++) {
    final n = 1 + r.nextInt(10); final a = List.generate(n, (_) => r.nextInt(9) - 4);
    final sr = SpendRanges(a); final l = r.nextInt(n); final rr = l + r.nextInt(n - l);
    eq(sr.total(l, rr), sumL(a.sublist(l, rr + 1)), 'range');
    final H = 1 + r.nextInt(8); final bk = List.generate(r.nextInt(6), (_) { final s = r.nextInt(H); return [s, s + r.nextInt(H - s)]; });
    eq(bookingsPerHour(H, bk), List.generate(H, (h) => bk.where((b) => b[0] <= h && h <= b[1]).length), 'book');
    var piv = -1; for (var i = 0; i < n && piv < 0; i++) { if (sumL(a.sublist(0, i)) == sumL(a.sublist(i + 1))) piv = i; }
    eq(pivotIndex(a), piv, 'pivot');
    final b = a.map((x) => (x + 4) % 2).toList(); var bl = 0;
    for (var i = 0; i < n; i++) for (var j = i; j < n; j++) { final w = b.sublist(i, j + 1); if (w.where((x) => x == 1).length * 2 == w.length) bl = max(bl, w.length); }
    eq(findMaxLength(b), bl, 'fml');
    final trips = List.generate(r.nextInt(5), (_) { final f = r.nextInt(10); return [1 + r.nextInt(4), f, f + 1 + r.nextInt(5)]; });
    final cap = r.nextInt(10); var ok = true;
    for (var x = 0; x <= 20; x++) { if (trips.where((tr) => tr[1] <= x && x < tr[2]).fold<int>(0, (s, tr) => s + tr[0]) > cap) ok = false; }
    eq(carPooling(trips, cap), ok, 'car');
  }
  print('dart ok');
}
