// Q10. Design Tweet or Timeline (Simplified)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

class Twitter {
  private time = 0;
  private tweets = new Map<number, [number, number][]>(); // [time, id]
  private follows = new Map<number, Set<number>>();

  postTweet(userId: number, tweetId: number): void {
    if (!this.tweets.has(userId)) this.tweets.set(userId, []);
    this.tweets.get(userId)!.unshift([++this.time, tweetId]);
  }

  getNewsFeed(userId: number): number[] {
    const people = new Set(this.follows.get(userId) ?? []);
    people.add(userId);
    type Item = { t: number; id: number; u: number; idx: number };
    const heap: Item[] = [];
    const push = (x: Item) => { heap.push(x); heap.sort((a, b) => b.t - a.t); };
    for (const u of people) {
      const list = this.tweets.get(u);
      if (list?.length) push({ t: list[0][0], id: list[0][1], u, idx: 0 });
    }
    const out: number[] = [];
    while (out.length < 10 && heap.length) {
      const cur = heap.shift()!;
      out.push(cur.id);
      const list = this.tweets.get(cur.u)!;
      const ni = cur.idx + 1;
      if (ni < list.length) push({ t: list[ni][0], id: list[ni][1], u: cur.u, idx: ni });
    }
    return out;
  }

  follow(followerId: number, followeeId: number): void {
    if (followerId === followeeId) return;
    if (!this.follows.has(followerId)) this.follows.set(followerId, new Set());
    this.follows.get(followerId)!.add(followeeId);
  }

  unfollow(followerId: number, followeeId: number): void {
    this.follows.get(followerId)?.delete(followeeId);
  }
}

export {};
