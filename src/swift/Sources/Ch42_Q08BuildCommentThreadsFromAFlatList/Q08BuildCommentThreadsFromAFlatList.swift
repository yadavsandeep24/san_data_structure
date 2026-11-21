// Q8. Build Comment Threads from a Flat List (Document Comments)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

struct Comment { let id: String; let parentId: String?; let at: Int64; let text: String }
struct Thread { let comment: Comment; let replies: [Thread] }

/// Roots newest first, replies oldest first. Orphans (parent missing) become roots.
func buildThreads(_ all: [Comment]) -> [Thread] {
    let ids = Set(all.map(\.id))
    func isRoot(_ c: Comment) -> Bool {
        guard let p = c.parentId else { return true }
        return !ids.contains(p) || p == c.id
    }
    var children: [String: [Comment]] = [:]
    for c in all where !isRoot(c) { children[c.parentId!, default: []].append(c) }
    var seen = Set<String>()
    func build(_ c: Comment) -> Thread {
        seen.insert(c.id)
        let kids = (children[c.id] ?? []).filter { !seen.contains($0.id) }.sorted { $0.at < $1.at }
        return Thread(comment: c, replies: kids.map(build))
    }
    return all.filter(isRoot).sorted { $0.at > $1.at }.map(build)
}
