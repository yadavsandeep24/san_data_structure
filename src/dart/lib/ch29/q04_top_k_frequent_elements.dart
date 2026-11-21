// Q4. Top K Frequent Elements
// Source: book/part-viii/29-interview-questions-q01-q10.md

List<int> topKFrequent(List<int> nums, int k) {
  final freq = <int, int>{};
  for (final x in nums) freq[x] = (freq[x] ?? 0) + 1;
  final buckets = List.generate(nums.length + 1, (_) => <int>[]);
  freq.forEach((v, f) => buckets[f].add(v));
  final out = <int>[];
  for (var f = buckets.length - 1; f >= 0; f--) {
    for (final v in buckets[f]) {
      out.add(v);
      if (out.length == k) return out;
    }
  }
  return out;
}
