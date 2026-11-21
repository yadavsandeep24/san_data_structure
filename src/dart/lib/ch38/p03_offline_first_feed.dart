// P3. Offline-First Feed
// Source: solutions/ch38/README.md

class FeedBuffer {
  final items = <Entity>[];
  final index = <String, int>{};
  void applyPage(List<Entity> page, {required bool prepend}) {
    final fresh = page.where((e) => !index.containsKey(e.id)).toList();
    if (prepend) items.insertAll(0, fresh); else items.addAll(fresh);
    _reindex();
  }
  void _reindex() {
    index.clear();
    for (var i = 0; i < items.length; i++) index[items[i].id] = i;
  }
}
class Entity { final String id, body; Entity(this.id, this.body); }
