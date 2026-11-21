// Worked code: sets in four languages
// Source: book/part-iii/08-sets.md
import 'dart:collection';

final seen = <String>{};
void example() {
  seen.add('p1');
  seen.add('p1');
  print(seen.contains('p1'));    // true
}

final ordered = LinkedHashSet<String>();
void example2() {
  ordered.add('first');
  ordered.add('second');
  print(ordered.toList());       // [first, second]
}
