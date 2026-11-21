// Q23. Course Schedule (Cycle Detect)
// Source: book/part-viii/29-interview-questions-q21-q30.md
import 'dart:collection';

bool canFinish(int numCourses, List<List<int>> prerequisites) {
  final adj = List.generate(numCourses, (_) => <int>[]);
  final indeg = List<int>.filled(numCourses, 0);
  for (final e in prerequisites) { adj[e[1]].add(e[0]); indeg[e[0]]++; }
  final q = Queue<int>();
  for (var i = 0; i < numCourses; i++) if (indeg[i] == 0) q.add(i);
  var seen = 0;
  while (q.isNotEmpty) {
    final u = q.removeFirst(); seen++;
    for (final v in adj[u]) if (--indeg[v] == 0) q.add(v);
  }
  return seen == numCourses;
}
