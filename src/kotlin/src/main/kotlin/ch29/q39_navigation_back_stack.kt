// Q39. Navigation Back Stack
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q39_navigation_back_stack

class NavStack {
    private val stack = ArrayList<String>()
    fun push(route: String) { stack.add(route) }
    fun pop(): String? = stack.removeLastOrNull()
    fun peek(): String? = stack.lastOrNull()
    fun replace(route: String) {
        if (stack.isEmpty()) stack.add(route) else stack[stack.lastIndex] = route
    }
    fun popToRoot() { if (stack.isNotEmpty()) stack.subList(1, stack.size).clear() }
    fun snapshot(): List<String> = stack.toList()
}
