// Worked example 2: longest prefetch run within a byte budget (variable window)
// Source: book/part-iv/14-sliding-window.md

int longestWithinBudget(List<int> sizes, int budget) {
  var left = 0, sum = 0, best = 0;
  for (var right = 0; right < sizes.length; right++) {
    sum += sizes[right];
    while (sum > budget) {
      sum -= sizes[left];
      left++;
    }
    if (right - left + 1 > best) best = right - left + 1;
  }
  return best;
}
