// Pattern: contains duplicate
// Source: book/part-iii/08-sets.md
package ch08.pattern_contains_duplicate

fun containsDuplicate(nums: IntArray): Boolean {
    val seen = HashSet<Int>()
    for (x in nums) {
        if (!seen.add(x)) return true // add returns false if already present
    }
    return false
}
