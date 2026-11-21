// P3: Simplify absolute path
// Source: solutions/ch05/README.md

func simplifyPath(_ path: String) -> String {
    var st: [String] = []
    for part in path.split(separator: "/", omittingEmptySubsequences: false).map(String.init) {
        switch part {
        case "", ".": break
        case "..": if !st.isEmpty { st.removeLast() }
        default: st.append(part)
        }
    }
    return "/" + st.joined(separator: "/")
}
