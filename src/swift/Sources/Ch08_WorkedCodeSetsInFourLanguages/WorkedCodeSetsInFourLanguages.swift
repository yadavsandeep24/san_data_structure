// Worked code: sets in four languages
// Source: book/part-iii/08-sets.md

var seen: Set<String> = []
func example() {
    seen.insert("p1")
    seen.insert("p1")
    print(seen.contains("p1"))     // true
}

// Order + membership
var order: [String] = []
var member: Set<String> = []
func select(_ id: String) {
    if member.insert(id).inserted { order.append(id) }
}
