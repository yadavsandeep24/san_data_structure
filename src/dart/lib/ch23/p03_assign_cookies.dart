// P3: Assign cookies
// Source: solutions/ch23/README.md

int findContentChildren(List<int> g, List<int> s) {
  g.sort();
  s.sort();
  var i = 0, j = 0;
  while (i < g.length && j < s.length) {
    if (s[j] >= g[i]) i++;
    j++;
  }
  return i;
}
