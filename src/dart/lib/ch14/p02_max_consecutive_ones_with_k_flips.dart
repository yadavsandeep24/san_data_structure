// P2: Max consecutive ones with k flips
// Source: solutions/ch14/README.md

int longestOnes(List<int> a, int k) {
  var left = 0, zeros = 0, best = 0;
  for (var right = 0; right < a.length; right++) {
    if (a[right] == 0) zeros++;
    while (zeros > k) {
      if (a[left] == 0) zeros--;
      left++;
    }
    if (right - left + 1 > best) best = right - left + 1;
  }
  return best;
}
