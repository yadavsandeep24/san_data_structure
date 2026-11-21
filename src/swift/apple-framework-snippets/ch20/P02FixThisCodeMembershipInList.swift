// P2: Fix this code — membership in list
// Source: solutions/ch20/README.md

// BAD
func bindRow(sku: String, cartSkus: [String], check: UISwitch) {
    check.isOn = cartSkus.contains(sku) // O(m)
}

// GOOD
func buildCartSet(_ cartSkus: [String]) -> Set<String> { Set(cartSkus) }

func bindRow(sku: String, cartSet: Set<String>, check: UISwitch) {
    check.isOn = cartSet.contains(sku) // O(1)
}
