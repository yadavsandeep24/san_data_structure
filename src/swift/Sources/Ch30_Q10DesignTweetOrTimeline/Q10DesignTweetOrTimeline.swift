// Q10. Design Tweet or Timeline (Simplified)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

final class Twitter {
    private var time = 0
    private var tweets: [Int: [(time: Int, id: Int)]] = [:] // newest first
    private var follows: [Int: Set<Int>] = [:]

    func postTweet(_ userId: Int, _ tweetId: Int) {
        time += 1
        tweets[userId, default: []].insert((time, tweetId), at: 0)
    }

    func getNewsFeed(_ userId: Int) -> [Int] {
        var people = follows[userId] ?? []
        people.insert(userId)
        typealias Item = (t: Int, id: Int, u: Int, idx: Int)
        var heap: [Item] = []
        func push(_ x: Item) { heap.append(x); heap.sort { $0.t > $1.t } }
        for u in people {
            if let first = tweets[u]?.first { push((first.time, first.id, u, 0)) }
        }
        var out: [Int] = []
        while out.count < 10 && !heap.isEmpty {
            let cur = heap.removeFirst()
            out.append(cur.id)
            let list = tweets[cur.u] ?? []
            let ni = cur.idx + 1
            if ni < list.count { push((list[ni].time, list[ni].id, cur.u, ni)) }
        }
        return out
    }

    func follow(_ followerId: Int, _ followeeId: Int) {
        if followerId != followeeId { follows[followerId, default: []].insert(followeeId) }
    }

    func unfollow(_ followerId: Int, _ followeeId: Int) {
        follows[followerId]?.remove(followeeId)
    }
}
