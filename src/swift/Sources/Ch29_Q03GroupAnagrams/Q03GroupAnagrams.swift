// Q3. Group Anagrams (Facet Grouping)
// Source: book/part-viii/29-interview-questions-q01-q10.md

func groupAnagrams(_ strs: [String]) -> [[String]] {
    var m: [String: [String]] = [:]
    for s in strs {
        let k = String(s.sorted())
        m[k, default: []].append(s)
    }
    return Array(m.values)
}
