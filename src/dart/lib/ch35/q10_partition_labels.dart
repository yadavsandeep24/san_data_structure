// Q10. Partition Labels (Chunking a Sync Log)
// Source: book/part-viii/35-heaps-tries-greedy.md
import 'dart:math';

List<int> partitionLabels(String s) {
  final last = <String, int>{};
  for (var i = 0; i < s.length; i++) {
    last[s[i]] = i;
  }
  final sizes = <int>[];
  var start = 0, end = 0;
  for (var i = 0; i < s.length; i++) {
    end = max(end, last[s[i]] ?? i);
    if (i == end) {
      sizes.add(end - start + 1);
      start = i + 1;
    }
  }
  return sizes;
}
