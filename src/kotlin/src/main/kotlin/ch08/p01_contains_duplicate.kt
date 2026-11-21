// P1: Contains duplicate
// Source: solutions/ch08/README.md
package ch08.p01_contains_duplicate

fun containsDuplicate(nums: IntArray): Boolean {
    val seen = HashSet<Int>()
    for (x in nums) if (!seen.add(x)) return true
    return false
}
