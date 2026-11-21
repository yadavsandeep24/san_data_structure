// Q4. Find the Bugs in This Function (Recent Completed Envelopes)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

class Envelope {
  final String id;
  final String status;
  final int? completedAt;
  const Envelope(this.id, this.status, this.completedAt);
}

List<Envelope> recentCompleted(List<Envelope> all, int n) {
  if (n < 0) throw ArgumentError.value(n, 'n', 'must be non-negative');
  final done = [
    for (var i = 0; i < all.length; i++)
      if (all[i].status.toLowerCase() == 'completed' && all[i].completedAt != null) (i, all[i]),
  ];
  // Dart's sort is not stable: break ties by input position.
  done.sort((a, b) {
    final c = b.$2.completedAt!.compareTo(a.$2.completedAt!);
    return c != 0 ? c : a.$1.compareTo(b.$1);
  });
  return done.take(n).map((p) => p.$2).toList();
}
