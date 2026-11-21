// Platform bridges
// Source: book/part-v/19-efficient-list-rendering.md

Widget feedList(List<FeedItem> feed) => ListView.builder(
      itemCount: feed.length,
      itemBuilder: (context, i) {
        final item = feed[i];
        return FeedRow(key: ValueKey(item.id), item: item);
      },
    );
