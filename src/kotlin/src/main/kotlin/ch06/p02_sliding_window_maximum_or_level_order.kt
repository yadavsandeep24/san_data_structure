// P2: Sliding window maximum or level-order
// Source: solutions/ch06/README.md
package ch06.p02_sliding_window_maximum_or_level_order

fun maxSlidingWindow(nums: IntArray, k: Int): IntArray {
    if (nums.isEmpty() || k <= 0) return intArrayOf()
    val dq = ArrayDeque<Int>()
    val res = IntArray(nums.size - k + 1)
    for (i in nums.indices) {
        while (dq.isNotEmpty() && dq.first() <= i - k) dq.removeFirst()
        while (dq.isNotEmpty() && nums[dq.last()] <= nums[i]) dq.removeLast()
        dq.addLast(i)
        if (i >= k - 1) res[i - k + 1] = nums[dq.first()]
    }
    return res
}

class TreeNode(var value: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

fun levelOrder(root: TreeNode?): List<List<Int>> {
    if (root == null) return emptyList()
    val res = mutableListOf<List<Int>>()
    val q = ArrayDeque<TreeNode>()
    q.addLast(root)
    while (q.isNotEmpty()) {
        val level = mutableListOf<Int>()
        repeat(q.size) {
            val node = q.removeFirst()
            level += node.value
            node.left?.let { q.addLast(it) }
            node.right?.let { q.addLast(it) }
        }
        res += level
    }
    return res
}
