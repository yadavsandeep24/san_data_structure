// Q2. Two Sum II: Input Array Is Sorted (Sorted Price Pair)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

List<int> twoSumSorted(List<int> numbers, int target) {
  var i = 0;
  var j = numbers.length - 1;
  while (i < j) {
    final sum = numbers[i] + numbers[j];
    if (sum == target) return [i + 1, j + 1];
    if (sum < target) {
      i++;
    } else {
      j--;
    }
  }
  return [];
}
