// Q3. Task Scheduler (Notification Cooldown Slots)
// Source: book/part-viii/35-heaps-tries-greedy.md
import 'dart:math';

int leastInterval(List<String> tasks, int n) {
  if (tasks.isEmpty) return 0;
  final freq = List<int>.filled(26, 0);
  for (final t in tasks) {
    freq[t.codeUnitAt(0) - 65]++;
  }
  final maxF = freq.reduce(max);
  final maxCount = freq.where((f) => f == maxF).length;
  return max(tasks.length, (maxF - 1) * (n + 1) + maxCount);
}
