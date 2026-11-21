// Kotlin, Dart and TypeScript string notes
// Source: book/part-vii/26-strings.md
import 'package:characters/characters.dart';

final s = '🇺🇸';
void example() {
  print(s.length);            // 4 (UTF-16 units for many flags)
  print(s.characters.length); // 1
}
