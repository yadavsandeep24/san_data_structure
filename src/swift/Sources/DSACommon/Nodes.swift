/// Shared node types for list and tree problems.
/// Supports both `.value` and `.val` field names used across the book.
public final class ListNode {
    public var value: Int
    public var next: ListNode?
    public init(_ value: Int, _ next: ListNode? = nil) { self.value = value; self.next = next }
    public var val: Int { get { value } set { value = newValue } }
}

public final class TreeNode {
    public var value: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ value: Int, _ left: TreeNode? = nil, _ right: TreeNode? = nil) {
        self.value = value; self.left = left; self.right = right
    }
    public var val: Int { get { value } set { value = newValue } }
}
