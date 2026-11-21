// Worked code: HashMap / Dictionary / Map
// Source: book/part-iii/07-hash-tables.md
import 'dart:collection';

final ages = <String, int>{};
void example() {
  ages['ada'] = 36;
  ages['linus'] = 54;
  print(ages['ada']);           // 36
  print(ages.containsKey('ada'));
  ages.remove('linus');
}

// Default Map is LinkedHashMap — iteration order == insertion order
final sections = <String, List<String>>{};
void example2() {
  sections['Account'] = ['Profile', 'Security'];
  sections['Device'] = ['Notifications'];
}
void example3() {
  for (final e in sections.entries) {
    // e.key, e.value — stable order
  }
}
