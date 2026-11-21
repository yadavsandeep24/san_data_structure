// Pattern: frequency map
// Source: book/part-iii/07-hash-tables.md

func freq(_ s: String) -> [Character: Int] {
    var m: [Character: Int] = [:]
    for c in s { m[c, default: 0] += 1 }
    return m
}
