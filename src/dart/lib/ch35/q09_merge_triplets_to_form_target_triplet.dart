// Q9. Merge Triplets to Form Target Triplet (Release Gate Versions)
// Source: book/part-viii/35-heaps-tries-greedy.md

bool mergeTriplets(List<List<int>> triplets, List<int> target) {
  final hit = [false, false, false];
  for (final t in triplets) {
    if (t[0] > target[0] || t[1] > target[1] || t[2] > target[2]) continue; // would overshoot
    for (var i = 0; i < 3; i++) {
      if (t[i] == target[i]) hit[i] = true;
    }
  }
  return hit.every((h) => h);
}
