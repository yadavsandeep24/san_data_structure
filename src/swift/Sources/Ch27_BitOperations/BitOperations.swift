// Bit operations
// Source: book/part-vii/27-bits-matrix.md

struct Perm: OptionSet {
    let rawValue: Int
    static let read  = Perm(rawValue: 1 << 0)
    static let write = Perm(rawValue: 1 << 1)
    static let exec  = Perm(rawValue: 1 << 2)
}
var p: Perm = [.read, .write]
func example() {
    p.contains(.write) // true
    p.remove(.write)
}
