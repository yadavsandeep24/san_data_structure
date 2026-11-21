// Practice
// Source: book/part-v/20-decision-guide.md

// CartViewController.configure — called for every visible cell during scroll
func configure(_ cell: UITableViewCell, sku: String, cartSkus: [String]) {
    cell.accessoryType = cartSkus.contains(sku) ? .checkmark : .none // ???
}
