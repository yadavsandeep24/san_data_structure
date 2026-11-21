// Q9. Do Two Signature Fields Overlap? (Field Placement Check)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q09_do_two_signature_fields_overlap

data class Box(val left: Int, val top: Int, val right: Int, val bottom: Int)

fun overlapArea(a: Box, b: Box): Long {
    val width = minOf(a.right, b.right).toLong() - maxOf(a.left, b.left)
    val height = minOf(a.bottom, b.bottom).toLong() - maxOf(a.top, b.top)
    return if (width > 0 && height > 0) width * height else 0L   // touching edges don't overlap
}
