// P2: Intersection of two arrays
// Source: solutions/ch08/README.md

func intersection(_ a: [Int], _ b: [Int]) -> [Int] {
    Array(Set(a).intersection(Set(b)))
}
