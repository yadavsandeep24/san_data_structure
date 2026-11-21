// Worked examples (four languages)
// Source: book/part-v/19-efficient-list-rendering.md

class FeedItem {
  FeedItem({required this.id, required this.title});
  final String id;
  final String title;
}

// ListView.builder(itemBuilder: ..., findChildIndexCallback / Key)
Widget buildRow(FeedItem item) => ListTile(key: ValueKey(item.id), title: Text(item.title));

sealed class ListEdit {}

class Insert extends ListEdit {
  Insert(this.index, this.id);
  final int index;
  final String id;
}

class Remove extends ListEdit {
  Remove(this.id);
  final String id;
}

class Update extends ListEdit {
  Update(this.id);
  final String id;
}

class Item {
  const Item(this.id, this.body);
  final String id;
  final String body;
}

List<ListEdit> diff(List<Item> old, List<Item> next) {
  final oldMap = {for (final o in old) o.id: o};
  final newIds = {for (final n in next) n.id};
  final edits = <ListEdit>[];
  for (final o in old) {
    if (!newIds.contains(o.id)) edits.add(Remove(o.id));
  }
  for (var index = 0; index < next.length; index++) {
    final n = next[index];
    final prev = oldMap[n.id];
    if (prev == null) {
      edits.add(Insert(index, n.id));
    } else if (prev.body != n.body) {
      edits.add(Update(n.id));
    }
  }
  return edits;
}

List<FeedItem> appendPage(
  List<FeedItem> buffer,
  Set<String> seen,
  List<FeedItem> page,
) {
  final next = [...buffer];
  for (final item in page) {
    if (!seen.add(item.id)) continue; // add returns false if already present
    next.add(item);
  }
  return next;
}
