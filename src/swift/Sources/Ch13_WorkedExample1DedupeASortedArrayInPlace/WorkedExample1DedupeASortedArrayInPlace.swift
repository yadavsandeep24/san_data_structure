// Worked example 1: dedupe a sorted array in place (read/write)
// Source: book/part-iv/13-two-pointers.md

func dedupeSortedInPlace(_ a: inout [Int]) -> Int {
    if a.isEmpty { return 0 }
    var write = 1
    for read in 1..<a.count where a[read] != a[write - 1] {
        a[write] = a[read]
        write += 1
    }
    return write
}
