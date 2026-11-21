// P2: Paginated feed buffer
// Source: solutions/ch19/README.md

class FeedItem {
  FeedItem(this.id, this.body);
  final String id;
  final String body;
}

class Page {
  Page(this.items, this.nextCursor);
  final List<FeedItem> items;
  final String? nextCursor;
}

class FeedBuffer {
  final _items = <FeedItem>[];
  final _seen = <String>{};
  String? nextCursor;

  List<FeedItem> get items => List.unmodifiable(_items);
  bool get hasMore => nextCursor != null;

  void append(Page page) {
    for (final item in page.items) {
      if (_seen.add(item.id)) _items.add(item);
    }
    nextCursor = page.nextCursor;
  }

  void reset() {
    _items.clear();
    _seen.clear();
    nextCursor = null;
  }
}
