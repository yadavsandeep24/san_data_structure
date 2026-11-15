
import 'dart:math';
void eq(Object? a, Object? b, String m) { if (a.toString() != b.toString()) throw Exception('$m got $a want $b'); }
void main() {
  final r = Random(2);
  for (var t = 0; t < 400; t++) {
    final n = 1 + r.nextInt(12); final a = List.generate(n, (_) => r.nextInt(10)); final k = 1 + r.nextInt(n);
    var bw = -1, bl = 0, bo = 0, bf = 0; final bin = a.map((x) => x % 2).toList(); final kk = r.nextInt(4); final B = r.nextInt(30);
    for (var i = 0; i + k <= n; i++) bw = max(bw, a.sublist(i, i + k).fold(0, (x, y) => x + y));
    for (var i = 0; i < n; i++) for (var j = i; j < n; j++) {
      final L = j - i + 1;
      if (a.sublist(i, j + 1).fold(0, (x, y) => x + y) <= B) bl = max(bl, L);
      if (bin.sublist(i, j + 1).where((x) => x == 0).length <= kk) bo = max(bo, L);
      if (a.sublist(i, j + 1).map((x) => x % 4).toSet().length <= 2) bf = max(bf, L);
    }
    eq(maxWindowSum(a, k), bw, 'mws'); eq(findMaxAverage(a, k), bw / k, 'avg');
    eq(longestWithinBudget(a, B), bl, 'b'); eq(longestOnes(bin, kk), bo, 'o'); eq(totalFruit(a.map((x) => x % 4).toList()), bf, 'f');
  }
  print('dart ok');
}
