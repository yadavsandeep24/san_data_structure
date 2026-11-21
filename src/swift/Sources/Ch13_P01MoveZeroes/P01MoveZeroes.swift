// P1: Move zeroes
// Source: solutions/ch13/README.md

func moveZeroes(_ a: inout [Int]) {
    var write = 0
    for read in a.indices where a[read] != 0 {
        a[write] = a[read]
        write += 1
    }
    while write < a.count {
        a[write] = 0
        write += 1
    }
}
