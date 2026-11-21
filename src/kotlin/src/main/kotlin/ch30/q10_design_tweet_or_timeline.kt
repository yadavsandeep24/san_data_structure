// Q10. Design Tweet or Timeline (Simplified)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q10_design_tweet_or_timeline

class Twitter {
    private var time = 0
    private val tweets = HashMap<Int, MutableList<Pair<Int, Int>>>() // user → (time, tweetId)
    private val follows = HashMap<Int, MutableSet<Int>>()

    fun postTweet(userId: Int, tweetId: Int) {
        tweets.getOrPut(userId) { mutableListOf() }.add(0, ++time to tweetId)
    }

    fun getNewsFeed(userId: Int): List<Int> {
        val people = (follows[userId] ?: emptySet()) + userId
        data class Item(val t: Int, val id: Int, val u: Int, val idx: Int)
        val heap = java.util.PriorityQueue<Item>(compareByDescending { it.t })
        for (u in people) {
            val list = tweets[u] ?: continue
            if (list.isNotEmpty()) heap.add(Item(list[0].first, list[0].second, u, 0))
        }
        val out = mutableListOf<Int>()
        while (out.size < 10 && heap.isNotEmpty()) {
            val cur = heap.poll()
            out += cur.id
            val list = tweets[cur.u]!!
            val ni = cur.idx + 1
            if (ni < list.size) heap.add(Item(list[ni].first, list[ni].second, cur.u, ni))
        }
        return out
    }

    fun follow(followerId: Int, followeeId: Int) {
        if (followerId != followeeId)
            follows.getOrPut(followerId) { hashSetOf() }.add(followeeId)
    }

    fun unfollow(followerId: Int, followeeId: Int) {
        follows[followerId]?.remove(followeeId)
    }
}
