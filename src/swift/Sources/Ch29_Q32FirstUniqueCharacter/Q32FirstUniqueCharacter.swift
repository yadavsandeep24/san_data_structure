// Q32. First Unique Character
// Source: book/part-viii/29-interview-questions-q31-q40.md

func firstUniqChar(_ s: String) -> Int {
    let chars = Array(s)
    var freq: [Character: Int] = [:]
    for c in chars { freq[c, default: 0] += 1 }
    for (i, c) in chars.enumerated() where freq[c] == 1 { return i }
    return -1
}
