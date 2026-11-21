// P2: Fix this code — membership in list
// Source: solutions/ch20/README.md
package ch20.p02_fix_this_code_membership_in_list

// BAD
fun bindRow(sku: String, cartSkus: List<String>, check: CheckBox) {
    check.isChecked = cartSkus.contains(sku) // O(m) per row
}

// GOOD — build once when cart changes
fun buildCartSet(cartSkus: List<String>): Set<String> = cartSkus.toHashSet()

fun bindRow(sku: String, cartSet: Set<String>, check: CheckBox) {
    check.isChecked = cartSet.contains(sku) // O(1) average
}

// BAD — O(m) list scan per visible row, on every recomposition
@Composable
fun CartListSlow(skus: List<String>, cartSkus: List<String>, onToggle: (String) -> Unit) {
    LazyColumn {
        items(skus, key = { it }) { sku ->
            Checkbox(checked = cartSkus.contains(sku), onCheckedChange = { onToggle(sku) })
        }
    }
}

// GOOD — Set rebuilt only when the cart changes (or expose a Set from the ViewModel)
@Composable
fun CartList(skus: List<String>, cartSkus: List<String>, onToggle: (String) -> Unit) {
    val cartSet = remember(cartSkus) { cartSkus.toHashSet() }
    LazyColumn {
        items(skus, key = { it }) { sku ->
            Checkbox(checked = sku in cartSet, onCheckedChange = { onToggle(sku) })
        }
    }
}
