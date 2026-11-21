// P2: Remove k digits
// Source: solutions/ch16/README.md

String removeKdigits(String num, int k) {
  var remaining = k;
  final stack = <int>[]; // code units
  for (final c in num.codeUnits) {
    while (remaining > 0 && stack.isNotEmpty && stack.last > c) {
      stack.removeLast();
      remaining--;
    }
    stack.add(c);
  }
  stack.removeRange(stack.length - remaining, stack.length);
  var start = 0;
  while (start < stack.length && stack[start] == 0x30) {
    start++;
  }
  final result = String.fromCharCodes(stack.sublist(start));
  return result.isEmpty ? '0' : result;
}
