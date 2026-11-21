// Q9. Recent Searches Ring Buffer
// Source: book/part-viii/29-interview-questions-q01-q10.md

class RecentSearches {
  RecentSearches(this.k);
  final int k;
  final q = <String>[];
  var head = 0;
  final seen = <String>{};
  void add(String term) {
    if (!seen.add(term)) {
      final i = q.indexOf(term, head);
      if (i >= 0) q.removeAt(i);
    }
    q.add(term);
    while (q.length - head > k) {
      seen.remove(q[head++]);
    }
  }
  List<String> list() => q.sublist(head).reversed.toList();
}
