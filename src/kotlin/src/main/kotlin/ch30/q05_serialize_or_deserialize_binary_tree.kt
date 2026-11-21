// Q5. Serialize or Deserialize Binary Tree
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q05_serialize_or_deserialize_binary_tree

class TreeNode(var `val`: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

class Codec {
    fun serialize(root: TreeNode?): String {
        if (root == null) return "#"
        val q = ArrayDeque<TreeNode?>()
        q.add(root)
        val out = mutableListOf<String>()
        while (q.isNotEmpty()) {
            val n = q.removeFirst()
            if (n == null) { out += "#"; continue }
            out += n.`val`.toString()
            q.add(n.left)
            q.add(n.right)
        }
        return out.joinToString(",")
    }

    fun deserialize(data: String): TreeNode? {
        if (data == "#" || data.isEmpty()) return null
        val parts = data.split(",")
        val root = TreeNode(parts[0].toInt())
        val q = ArrayDeque<TreeNode>()
        q.add(root)
        var i = 1
        while (q.isNotEmpty() && i < parts.size) {
            val n = q.removeFirst()
            if (parts[i] != "#") {
                n.left = TreeNode(parts[i].toInt()).also { q.add(it) }
            }
            i++
            if (i < parts.size && parts[i] != "#") {
                n.right = TreeNode(parts[i].toInt()).also { q.add(it) }
            }
            i++
        }
        return root
    }
}
