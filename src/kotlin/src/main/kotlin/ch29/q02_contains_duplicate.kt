// Q2. Contains Duplicate (Dedupe Guard)
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q02_contains_duplicate

fun containsDuplicate(nums: IntArray): Boolean {
    val s = HashSet<Int>()
    for (x in nums) if (!s.add(x)) return true
    return false
}
