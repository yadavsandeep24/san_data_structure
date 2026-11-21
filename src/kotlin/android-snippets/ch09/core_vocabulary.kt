// Core vocabulary
// Source: book/part-iii/09-trees-basics.md
package ch09.core_vocabulary

fun maxViewDepth(root: View): Int {
    val stack = ArrayDeque<Pair<View, Int>>()
    stack.addLast(root to 1)
    var max = 0
    while (stack.isNotEmpty()) {
        val (view, depth) = stack.removeLast()
        max = maxOf(max, depth)
        if (view is ViewGroup) {
            for (i in 0 until view.childCount) stack.addLast(view.getChildAt(i) to depth + 1)
        }
    }
    return max
}

@Composable
fun CartHeader(itemCount: Int, total: () -> String) {
    Column {
        Text("$itemCount items")   // not re-run when only the total changes
        TotalLine(total)           // total() is read inside → only this scope recomposes
    }
}

@Composable
fun TotalLine(total: () -> String) = Text(total())

@Composable
fun ParallaxHeader(scroll: ScrollState) {
    // Read scroll in the layout phase (lambda offset): no recomposition per pixel.
    Box(Modifier.offset { IntOffset(0, scroll.value / 2) })
}
