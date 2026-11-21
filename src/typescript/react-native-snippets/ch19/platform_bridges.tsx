// Platform bridges
// Source: book/part-v/19-efficient-list-rendering.md
// React Native snippet: needs a React Native project (not type-checked here).

function FeedList({ feed }: { feed: FeedItem[] }) {
  return (
    <FlatList
      data={feed}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <FeedRow item={item} />}
    />
  );
}
