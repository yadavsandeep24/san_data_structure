// P3: Assign cookies
// Source: solutions/ch23/README.md

func findContentChildren(_ g: [Int], _ s: [Int]) -> Int {
    let kids = g.sorted()
    let cookies = s.sorted()
    var i = 0, j = 0
    while i < kids.count && j < cookies.count {
        if cookies[j] >= kids[i] { i += 1 }
        j += 1
    }
    return i
}
