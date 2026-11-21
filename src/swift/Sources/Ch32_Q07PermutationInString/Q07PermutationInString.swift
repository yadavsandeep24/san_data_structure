// Q7. Permutation in String (Scrambled Code Search)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func checkInclusion(_ s1: String, _ s2: String) -> Bool {
    let p = Array(s1.utf8), s = Array(s2.utf8)
    if p.count > s.count { return false }
    let a = UInt8(ascii: "a")
    var need = [Int](repeating: 0, count: 26)
    for c in p { need[Int(c - a)] += 1 }
    var missing = p.count
    for i in 0..<s.count {
        if need[Int(s[i] - a)] > 0 { missing -= 1 }
        need[Int(s[i] - a)] -= 1
        if i >= p.count {
            need[Int(s[i - p.count] - a)] += 1
            if need[Int(s[i - p.count] - a)] > 0 { missing += 1 }
        }
        if missing == 0 { return true }
    }
    return false
}
