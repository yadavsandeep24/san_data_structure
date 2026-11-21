// Worked code: append vs insert front
// Source: book/part-ii/03-arrays-dynamic-arrays.md

var end = [Int]()
func example() {
    end.append(1)                 // O(1) amortized
    end.insert(99, at: 0)         // O(n)
}

var reserved: [Int] = []
func example2() {
    reserved.reserveCapacity(10_000) // avoid repeated growth copies
}
