// Practice
// Source: book/part-v/20-decision-guide.md
package ch20.practice

// CartActivity.bindRow — called for every visible row during scroll
fun bindRow(sku: String, cartSkus: List<String>, check: CheckBox) {
    check.isChecked = cartSkus.contains(sku) // ???
}
