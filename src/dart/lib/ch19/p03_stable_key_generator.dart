// P3: Stable key generator
// Source: solutions/ch19/README.md

sealed class FeedEntry {}
class Post extends FeedEntry {
  Post(this.id);
  final String id;
}
class Ad extends FeedEntry {
  Ad(this.id);
  final String id;
}
class Header extends FeedEntry {
  Header(this.sectionId);
  final String sectionId;
}

String stableKey(FeedEntry entry) {
  switch (entry) {
    case Post(:final id):
      assert(id.isNotEmpty);
      return 'post:$id';
    case Ad(:final id):
      assert(id.isNotEmpty);
      return 'ad:$id';
    case Header(:final sectionId):
      assert(sectionId.isNotEmpty);
      return 'header:$sectionId';
  }
}
