// File system as a tree
// Source: book/part-iii/09-trees-basics.md
package ch09.file_system_as_a_tree

class FsNode(
    val name: String,
    val isDirectory: Boolean = false,
    val children: List<FsNode> = emptyList(),
) {
    val isFile: Boolean get() = !isDirectory
}

fun walk(n: FsNode, visit: (FsNode) -> Unit) {
    visit(n)
    for (c in n.children) walk(c, visit)
}
