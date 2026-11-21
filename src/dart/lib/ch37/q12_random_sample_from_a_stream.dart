// Q12. Random Sample from a Stream (Reservoir Sampling of Audit Events)
// Source: book/part-viii/37-math-and-number-drills.md
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
