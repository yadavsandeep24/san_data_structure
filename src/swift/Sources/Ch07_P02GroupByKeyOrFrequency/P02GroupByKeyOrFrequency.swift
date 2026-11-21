// P2: Group by key or frequency
// Source: solutions/ch07/README.md

func groupAnagrams(_ strs: [String]) -> [[String]] {
    var map: [String: [String]] = [:]
    for s in strs {
        let key = String(s.sorted())
        map[key, default: []].append(s)
    }
    return Array(map.values)
}
