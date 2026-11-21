// P2: Fix this code — membership in list
// Source: solutions/ch20/README.md

// BAD (kept under a different name so both versions compile)

void bindRowSlow(String sku, List<String> cartSkus, bool Function(bool) setChecked) {
  setChecked(cartSkus.contains(sku)); // O(m)
}

// GOOD
Set<String> buildCartSet(List<String> cartSkus) => cartSkus.toSet();

void bindRow(String sku, Set<String> cartSet, void Function(bool) setChecked) {
  setChecked(cartSet.contains(sku)); // O(1)
}
