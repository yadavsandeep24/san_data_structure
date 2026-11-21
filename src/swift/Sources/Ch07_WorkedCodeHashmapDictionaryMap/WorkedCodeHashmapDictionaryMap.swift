// Worked code: HashMap / Dictionary / Map
// Source: book/part-iii/07-hash-tables.md

var ages: [String: Int] = [:]
func example() {
    ages["ada"] = 36
    ages["linus"] = 54
    print(ages["ada"] ?? -1)      // 36
    print(ages["ada"] != nil)     // true
    ages.removeValue(forKey: "linus")
}

// Insertion-ordered walk: keep a parallel key array, or rebuild from source of truth
let sectionOrder = ["Account", "Device"]
var sections: [String: [String]] = [
    "Account": ["Profile", "Security"],
    "Device": ["Notifications"],
]
func example2() {
    for title in sectionOrder {
        let rows = sections[title] ?? []
        // render…
    }
}
