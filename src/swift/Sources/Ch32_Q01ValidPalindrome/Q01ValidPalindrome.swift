// Q1. Valid Palindrome (Coupon Code Check)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func isPalindrome(_ s: String) -> Bool {
    let b = Array(s.utf8)
    func norm(_ c: UInt8) -> UInt8? {
        switch c {
        case UInt8(ascii: "a")...UInt8(ascii: "z"), UInt8(ascii: "0")...UInt8(ascii: "9"): return c
        case UInt8(ascii: "A")...UInt8(ascii: "Z"): return c + 32
        default: return nil
        }
    }
    var i = 0
    var j = b.count - 1
    while i < j {
        guard let x = norm(b[i]) else { i += 1; continue }
        guard let y = norm(b[j]) else { j -= 1; continue }
        if x != y { return false }
        i += 1
        j -= 1
    }
    return true
}
