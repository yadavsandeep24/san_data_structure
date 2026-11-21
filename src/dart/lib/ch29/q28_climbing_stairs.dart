// Q28. Climbing Stairs
// Source: book/part-viii/29-interview-questions-q21-q30.md

int climbStairs(int n) {
  if (n <= 2) return n;
  var a = 1, b = 2;
  for (var i = 3; i <= n; i++) {
    final c = a + b; a = b; b = c;
  }
  return b;
}
