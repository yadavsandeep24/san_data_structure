// Sample: order-preserving unique IDs (Chapter 3)
List<String> uniquePreserveOrder(List<String> ids) {
  final seen = <String>{};
  final out = <String>[];
  for (final id in ids) {
    if (seen.add(id)) out.add(id);
  }
  return out;
}
