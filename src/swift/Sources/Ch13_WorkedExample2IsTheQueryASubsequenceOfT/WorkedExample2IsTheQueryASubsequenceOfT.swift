// Worked example 2: is the query a subsequence of the name? (one cursor per sequence)
// Source: book/part-iv/13-two-pointers.md

func isSubsequence(_ query: String, _ name: String) -> Bool {
    let q = Array(query.lowercased())
    var qi = 0
    for ch in name.lowercased() {
        if qi == q.count { break }
        if ch == q[qi] { qi += 1 }
    }
    return qi == q.count
}
