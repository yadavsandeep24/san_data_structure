// Set algebra: union, intersection, difference
// Source: book/part-iii/08-sets.md
package ch08.set_algebra_union_intersection_difference

val a = setOf(1, 2, 3)
val b = setOf(2, 3, 4)
val union = a union b              // 1,2,3,4
val inter = a intersect b          // 2,3
val diff = a subtract b            // 1
