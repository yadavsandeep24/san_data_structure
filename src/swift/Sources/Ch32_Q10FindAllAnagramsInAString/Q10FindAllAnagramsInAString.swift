// Q10. Find All Anagrams in a String (Every Scrambled Match)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func findAnagrams(_ s: String, _ p: String) -> [Int] {
    let sb = Array(s.utf8), pb = Array(p.utf8)
    var out: [Int] = []
    if pb.count > sb.count { return out }
    let a = UInt8(ascii: "a")
    var need = [Int](repeating: 0, count: 26)
    for c in pb { need[Int(c - a)] += 1 }
    var missing = pb.count
    for i in 0..<sb.count {
        if need[Int(sb[i] - a)] > 0 { missing -= 1 }
        need[Int(sb[i] - a)] -= 1
        if i >= pb.count {
            need[Int(sb[i - pb.count] - a)] += 1
            if need[Int(sb[i - pb.count] - a)] > 0 { missing += 1 }
        }
        if missing == 0 { out.append(i - pb.count + 1) }
    }
    return out
}
