// Practice
// Source: book/part-v/20-decision-guide.md

// Cart list itemBuilder — runs for every visible row during scroll
Widget buildRow(String sku, List<String> cartSkus) {
  return CheckboxListTile(
    title: Text(sku),
    value: cartSkus.contains(sku), // ???
    onChanged: (_) {},
  );
}
