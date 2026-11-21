// Q7. Count Balanced Binary Substrings (Pen-Down Runs)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

int countBinarySubstrings(String s) {
  var previous = 0, current = 1, count = 0;
  for (var i = 1; i < s.length; i++) {
    if (s[i] == s[i - 1]) {
      current++;
    } else {
      count += current < previous ? current : previous;
      previous = current;
      current = 1;
    }
  }
  return count + (current < previous ? current : previous);
}
