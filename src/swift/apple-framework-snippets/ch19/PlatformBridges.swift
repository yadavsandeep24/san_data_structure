// Platform bridges
// Source: book/part-v/19-efficient-list-rendering.md

struct FeedItem: Identifiable {
    let id: String
    var title: String
}

func example() {
    List(feed) { item in
        Text(item.title)
    }
}
