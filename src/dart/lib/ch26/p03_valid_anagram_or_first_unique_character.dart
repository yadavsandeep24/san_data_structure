// P3: Valid anagram or first unique character
// Source: solutions/ch26/README.md

bool isAnagram(String s, String t) {
  if (s.length != t.length) return false;
  final cnt = List.filled(26, 0);
  for (var i = 0; i < s.length; i++) {
    cnt[s.codeUnitAt(i) - 97]++;
    cnt[t.codeUnitAt(i) - 97]--;
  }
  return cnt.every((x) => x == 0);
}

int firstUniqChar(String s) {
  final cnt = List.filled(26, 0);
  for (var i = 0; i < s.length; i++) {
    cnt[s.codeUnitAt(i) - 97]++;
  }
  for (var i = 0; i < s.length; i++) {
    if (cnt[s.codeUnitAt(i) - 97] == 1) return i;
  }
  return -1;
}
