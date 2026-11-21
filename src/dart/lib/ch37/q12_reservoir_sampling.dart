// Q12 — Reservoir sampling (Swift / Dart)
// Source: solutions/ch37/README.md
import 'dart:math';

List<T> reservoirSample<T>(Iterable<T> items, int k, [Random? random]) {
  final rng = random ?? Random();
  final reservoir = <T>[];
  var i = 0;
  for (final item in items) {
    if (i < k) {
      reservoir.add(item);
    } else {
      final j = rng.nextInt(i + 1);                  // keep item i with probability k / (i + 1)
      if (j < k) reservoir[j] = item;
    }
    i++;
  }
  return reservoir;
}
