
import 'dart:math';
void eq(Object? a, Object? b, String m) { if (a.toString() != b.toString()) throw Exception('$m got $a want $b'); }
void main() {
  final r = Random(1);
  for (var t = 0; t < 500; t++) {
    final n = r.nextInt(12);
    final a = List.generate(n, (_) => r.nextInt(5) - 2);
    final s = [...a]..sort();
    final d = [...s]; final k = dedupeSortedInPlace(d); eq(d.sublist(0, k), s.toSet().toList(), 'dedupe');
    final m = [...a]; moveZeroes(m); eq(m, [...a.where((x) => x != 0), ...a.where((x) => x == 0)], 'mz');
    eq(sortedSquares(s), (s.map((x) => x * x).toList()..sort()), 'sq');
    final c = a.map((x) => x.abs() % 3).toList(); final c2 = [...c]; sortColors(c2); eq(c2, [...c]..sort(), 'colors');
  }
  eq(isSubsequence('jdoe', 'John Doe'), true, 's1'); eq(isSubsequence('jdx', 'John Doe'), false, 's2');
  print('dart tests passed');
}
