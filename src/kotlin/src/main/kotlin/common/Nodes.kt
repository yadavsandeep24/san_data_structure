package dsa.common

/** Shared node types for list and tree problems. Supports both `.value` and `.`val`` field names used across the book. */
class ListNode(var value: Int, var next: ListNode? = null) {
    var `val`: Int
        get() = value
        set(v) { value = v }
}

class TreeNode(var value: Int, var left: TreeNode? = null, var right: TreeNode? = null) {
    var `val`: Int
        get() = value
        set(v) { value = v }
}
