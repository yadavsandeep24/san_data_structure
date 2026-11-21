// Q8 — Comment threads from a flat list (Swift / Dart)
// Source: solutions/ch42/README.md

class Comment {
  final String id;
  final String? parentId;
  final int at;
  final String text;
  const Comment(this.id, this.parentId, this.at, this.text);
}

class Thread {
  final Comment comment;
  final List<Thread> replies;
  const Thread(this.comment, this.replies);
}

/// Roots newest first, replies oldest first. Orphans (parent missing) become roots.
List<Thread> buildThreads(List<Comment> all) {
  final ids = {for (final c in all) c.id};
  bool isRoot(Comment c) => c.parentId == null || !ids.contains(c.parentId) || c.parentId == c.id;
  final children = <String, List<Comment>>{};
  for (final c in all) {
    if (!isRoot(c)) children.putIfAbsent(c.parentId!, () => []).add(c);
  }
  final seen = <String>{};
  Thread build(Comment c) {
    seen.add(c.id);
    final kids = (children[c.id] ?? []).where((k) => !seen.contains(k.id)).toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    return Thread(c, kids.map(build).toList());
  }
  final roots = all.where(isRoot).toList()..sort((a, b) => b.at.compareTo(a.at));
  return roots.map(build).toList();
}
