// Q5. Text Editor with a Cursor (Note Field on a Form)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
import 'dart:math';

class TextEditor {
  final List<String> _left = [];
  final List<String> _right = []; // stored backwards: its end is the cursor

  void insert(String text) => _left.addAll(text.split(''));

  void moveLeft(int x) {
    for (var k = min(x, _left.length); k > 0; k--) _right.add(_left.removeLast());
  }

  void moveRight(int x) {
    for (var k = min(x, _right.length); k > 0; k--) _left.add(_right.removeLast());
  }

  int backspace(int x) {
    final n = min(x, _left.length);
    _left.length -= n;
    return n;
  }

  int delete(int x) {
    final n = min(x, _right.length);
    _right.length -= n;
    return n;
  }

  // Up to x characters immediately left of the cursor.
  String print(int x) => _left.sublist(max(0, _left.length - x)).join();

  String text() => _left.join() + _right.reversed.join();
}
