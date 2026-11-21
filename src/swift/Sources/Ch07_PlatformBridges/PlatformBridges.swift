// Platform bridges
// Source: book/part-iii/07-hash-tables.md

struct Post { let id: String; let title: String }   // minimal model for this example

// Normalize API list once
func indexById(_ posts: [Post]) -> [String: Post] {
    Dictionary(posts.map { ($0.id, $0) }, uniquingKeysWith: { _, last in last })
}
