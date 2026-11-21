// P1: Membership under scroll
// Source: solutions/ch01/README.md

int countSelectedVisible(List<String> visibleIds, List<String> selectedIds) {
  final selected = selectedIds.toSet();
  return visibleIds.where(selected.contains).length;
}
