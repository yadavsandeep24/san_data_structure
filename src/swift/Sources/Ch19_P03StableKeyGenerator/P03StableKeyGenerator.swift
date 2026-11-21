// P3: Stable key generator
// Source: solutions/ch19/README.md

enum FeedEntry {
    case post(id: String)
    case ad(id: String)
    case header(sectionId: String)
}

func stableKey(_ entry: FeedEntry) -> String {
    switch entry {
    case .post(let id):
        precondition(!id.isEmpty); return "post:\(id)"
    case .ad(let id):
        precondition(!id.isEmpty); return "ad:\(id)"
    case .header(let sectionId):
        precondition(!sectionId.isEmpty); return "header:\(sectionId)"
    }
}
