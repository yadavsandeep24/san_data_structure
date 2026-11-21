// Q3. Copy List with Random Pointer (Deep Copy a Linked Playlist)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q03_copy_list_with_random_pointer

import ch34.shared_node_classes.*

class Node(var `val`: Int) {
    var next: Node? = null
    var random: Node? = null
}

fun copyRandomList(head: Node?): Node? {
    val copies = HashMap<Node, Node>()
    var cur = head
    while (cur != null) { // pass 1: clone every node
        copies[cur] = Node(cur.`val`)
        cur = cur.next
    }
    cur = head
    while (cur != null) { // pass 2: wire next + random through the map
        val copy = copies.getValue(cur)
        copy.next = cur.next?.let { copies.getValue(it) }
        copy.random = cur.random?.let { copies.getValue(it) }
        cur = cur.next
    }
    return head?.let { copies.getValue(it) }
}
