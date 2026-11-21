// P1: Minimal list diffs (insert / remove / update)
// Source: solutions/ch19/README.md

class Row {
  Row(this.id, this.value);
  final String id;
  final String value;
}

sealed class Edit {}
class Insert extends Edit {
  Insert(this.index, this.id);
  final int index;
  final String id;
}
class Remove extends Edit {
  Remove(this.id);
  final String id;
}
class Update extends Edit {
  Update(this.id);
  final String id;
}

List<Edit> minimalDiff(List<Row> old, List<Row> neu) {
  final oldMap = {for (final o in old) o.id: o};
  final newIds = neu.map((e) => e.id).toSet();
  final edits = <Edit>[];
  for (final o in old) {
    if (!newIds.contains(o.id)) edits.add(Remove(o.id));
  }
  for (var i = 0; i < neu.length; i++) {
    final n = neu[i];
    final prev = oldMap[n.id];
    if (prev == null) {
      edits.add(Insert(i, n.id));
    } else if (prev.value != n.value) {
      edits.add(Update(n.id));
    }
  }
  return edits;
}
