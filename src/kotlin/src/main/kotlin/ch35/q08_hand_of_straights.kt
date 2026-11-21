// Q8. Hand of Straights (Consecutive Ticket Batches)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q08_hand_of_straights

import java.util.TreeMap

fun isNStraightHand(hand: IntArray, groupSize: Int): Boolean {
    if (hand.size % groupSize != 0) return false
    val count = TreeMap<Int, Int>()
    for (h in hand) count.merge(h, 1, Int::plus)
    while (count.isNotEmpty()) {
        val first = count.firstKey() // smallest card must start a group
        for (v in first until first + groupSize) {
            val c = count[v] ?: return false
            if (c == 1) count.remove(v) else count[v] = c - 1
        }
    }
    return true
}
