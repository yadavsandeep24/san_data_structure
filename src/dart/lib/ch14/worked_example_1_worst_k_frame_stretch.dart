// Worked example 1: worst k-frame stretch (fixed window)
// Source: book/part-iv/14-sliding-window.md

int maxWindowSum(List<int> frames, int k) {
  var sum = 0;
  for (var i = 0; i < k; i++) {
    sum += frames[i];
  }
  var best = sum;
  for (var right = k; right < frames.length; right++) {
    sum += frames[right] - frames[right - k];
    if (sum > best) best = sum;
  }
  return best;
}
