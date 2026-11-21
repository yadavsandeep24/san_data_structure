// Q10. Design Tweet or Timeline (Simplified)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

typedef _Item = ({int t, int id, int u, int idx});

class Twitter {
  var _time = 0;
  final _tweets = <int, List<(int time, int id)>>{}; // newest first
  final _follows = <int, Set<int>>{};

  void postTweet(int userId, int tweetId) {
    (_tweets[userId] ??= []).insert(0, (++_time, tweetId));
  }

  List<int> getNewsFeed(int userId) {
    final people = {...?_follows[userId], userId};
    final heap = <_Item>[];
    void push(_Item x) {
      heap.add(x);
      heap.sort((a, b) => b.t.compareTo(a.t));
    }

    for (final u in people) {
      final list = _tweets[u];
      if (list != null && list.isNotEmpty) {
        push((t: list[0].$1, id: list[0].$2, u: u, idx: 0));
      }
    }
    final out = <int>[];
    while (out.length < 10 && heap.isNotEmpty) {
      final cur = heap.removeAt(0);
      out.add(cur.id);
      final list = _tweets[cur.u]!;
      final ni = cur.idx + 1;
      if (ni < list.length) {
        push((t: list[ni].$1, id: list[ni].$2, u: cur.u, idx: ni));
      }
    }
    return out;
  }

  void follow(int followerId, int followeeId) {
    if (followerId != followeeId) (_follows[followerId] ??= {}).add(followeeId);
  }

  void unfollow(int followerId, int followeeId) {
    _follows[followerId]?.remove(followeeId);
  }
}
