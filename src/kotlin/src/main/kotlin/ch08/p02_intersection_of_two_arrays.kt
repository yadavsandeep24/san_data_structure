// P2: Intersection of two arrays
// Source: solutions/ch08/README.md
package ch08.p02_intersection_of_two_arrays

fun intersection(a: IntArray, b: IntArray): IntArray {
    val setA = a.toHashSet()
    val out = HashSet<Int>()
    for (x in b) if (x in setA) out.add(x)
    return out.toIntArray()
}
