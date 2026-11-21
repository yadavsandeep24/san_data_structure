// Q7. Count Balanced Binary Substrings (Pen-Down Runs)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

func countBinarySubstrings(_ s: String) -> Int {
    let c = Array(s)
    var previous = 0, current = 1, count = 0
    for i in c.indices.dropFirst() {
        if c[i] == c[i - 1] {
            current += 1
        } else {
            count += min(previous, current)
            previous = current
            current = 1
        }
    }
    return count + min(previous, current)
}
