// P5. Navigation Back Stack
// Source: solutions/ch38/README.md
package ch38.p05_navigation_back_stack

class NavStack {
    private val stack = ArrayDeque<String>()
    fun push(r: String) = stack.addLast(r)
    fun pop(): String? = if (stack.isEmpty()) null else stack.removeLast()
    fun peek(): String? = stack.lastOrNull()
    fun replace(r: String) { if (stack.isEmpty()) push(r) else { stack.removeLast(); stack.addLast(r) } }
    fun popToRoot() { while (stack.size > 1) stack.removeLast() }
    fun snapshot() = stack.toList()
}

// Views: FragmentManager (root fragment added without addToBackStack)
class FragmentNavStack(
    private val fm: FragmentManager,
    @IdRes private val container: Int,
    private val screen: (route: String) -> Fragment,
) {
    fun push(r: String) = fm.commit {
        setReorderingAllowed(true)
        replace(container, screen(r))
        addToBackStack(r)
    }
    fun pop() = fm.popBackStack()
    fun popToRoot() = fm.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE)
    fun peek(): String? = fm.backStackEntryCount.takeIf { it > 0 }?.let { fm.getBackStackEntryAt(it - 1).name }
    fun snapshot(): List<String?> = (0 until fm.backStackEntryCount).map { fm.getBackStackEntryAt(it).name }
}

// Compose: Navigation Compose NavController
class ComposeNavStack(private val nav: NavController) {
    fun push(r: String) = nav.navigate(r)
    fun pop() = nav.popBackStack()
    fun peek(): String? = nav.currentDestination?.route   // route pattern, e.g. "detail/{id}"
    fun replace(r: String) {
        val current = nav.currentDestination?.route
        nav.navigate(r) { if (current != null) popUpTo(current) { inclusive = true } }
    }
    fun popToRoot() = nav.popBackStack(nav.graph.findStartDestination().id, inclusive = false)
}
