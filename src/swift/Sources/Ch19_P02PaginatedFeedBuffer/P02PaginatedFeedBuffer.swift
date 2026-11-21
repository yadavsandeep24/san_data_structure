// P2: Paginated feed buffer
// Source: solutions/ch19/README.md

struct FeedItem: Hashable {
    let id: String
    let body: String
}

struct Page {
    let items: [FeedItem]
    let nextCursor: String?
}

final class FeedBuffer {
    private(set) var items: [FeedItem] = []
    private var seen: Set<String> = []
    private(set) var nextCursor: String?

    func append(_ page: Page) {
        for item in page.items where seen.insert(item.id).inserted {
            items.append(item)
        }
        nextCursor = page.nextCursor
    }

    func reset() {
        items.removeAll()
        seen.removeAll()
        nextCursor = nil
    }

    var hasMore: Bool { nextCursor != nil }
}
