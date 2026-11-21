// File system as a tree
// Source: book/part-iii/09-trees-basics.md

struct FsNode {
    let name: String
    var isDirectory = false
    var children: [FsNode] = []
    var isFile: Bool { !isDirectory }
}

func walk(_ n: FsNode, _ visit: (FsNode) -> Void) {
    visit(n)
    for c in n.children { walk(c, visit) }
}
