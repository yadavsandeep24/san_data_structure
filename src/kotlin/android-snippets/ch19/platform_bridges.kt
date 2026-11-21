// Platform bridges
// Source: book/part-v/19-efficient-list-rendering.md
package ch19.platform_bridges

LazyColumn {
    items(items = feed, key = { it.id }) { item ->
        FeedRow(item)
    }
}
