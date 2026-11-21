// Q11. Simplify a Signature Stroke (Ramer-Douglas-Peucker)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
package ch42.q11_simplify_a_signature_stroke

import kotlin.math.hypot

data class Pt(val x: Double, val y: Double)

fun distToSegment(p: Pt, a: Pt, b: Pt): Double {
    val dx = b.x - a.x
    val dy = b.y - a.y
    val len2 = dx * dx + dy * dy
    if (len2 == 0.0) return hypot(p.x - a.x, p.y - a.y)
    val t = (((p.x - a.x) * dx + (p.y - a.y) * dy) / len2).coerceIn(0.0, 1.0)
    return hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy))
}

/** Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack. */
fun simplify(points: List<Pt>, epsilon: Double): List<Pt> {
    if (points.size < 3) return points
    val keep = BooleanArray(points.size).also { it[0] = true; it[points.lastIndex] = true }
    val stack = ArrayDeque(listOf(0 to points.lastIndex))
    while (stack.isNotEmpty()) {
        val (s, e) = stack.removeLast()
        var maxD = 0.0
        var idx = -1
        for (i in s + 1 until e) {
            val d = distToSegment(points[i], points[s], points[e])
            if (d > maxD) { maxD = d; idx = i }
        }
        if (maxD > epsilon) { keep[idx] = true; stack += s to idx; stack += idx to e }
    }
    return points.filterIndexed { i, _ -> keep[i] }
}
