// Worked code: HashMap / Dictionary / Map
// Source: book/part-iii/07-hash-tables.md
package ch07.worked_code_hashmap_dictionary_map

val ages = hashMapOf<String, Int>()
fun example() {
    ages["ada"] = 36
    ages["linus"] = 54
    println(ages["ada"])          // 36
    println("ada" in ages)        // true
    ages.remove("linus")
}

// Preserve insertion order for UI sections
val sections = LinkedHashMap<String, List<String>>()
fun example2() {
    sections["Account"] = listOf("Profile", "Security")
    sections["Device"] = listOf("Notifications")
    for ((title, rows) in sections) {
        // render title, then rows — order stable
    }
}
