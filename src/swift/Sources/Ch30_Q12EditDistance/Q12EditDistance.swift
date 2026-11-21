// Q12. Edit Distance
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

func minDistance(_ word1: String, _ word2: String) -> Int {
    let a = Array(word1), b = Array(word2)
    let m = a.count, n = b.count
    var prev = Array(0...n)
    for i in stride(from: 1, through: m, by: 1) {
        var cur = Array(repeating: 0, count: n + 1)
        cur[0] = i
        for j in stride(from: 1, through: n, by: 1) {
            cur[j] = a[i - 1] == b[j - 1]
                ? prev[j - 1]
                : 1 + min(prev[j], cur[j - 1], prev[j - 1])
        }
        prev = cur
    }
    return prev[n]
}
