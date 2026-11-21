// P1: Membership under scroll
// Source: solutions/ch01/README.md
package ch01.p01_membership_under_scroll

fun countSelectedVisible(visibleIds: List<String>, selectedIds: List<String>): Int {
    val selected = selectedIds.toHashSet()          // O(m)
    return visibleIds.count { it in selected }      // O(n), O(1) average per check
}
