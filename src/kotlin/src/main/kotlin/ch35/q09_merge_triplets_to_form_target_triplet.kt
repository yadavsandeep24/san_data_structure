// Q9. Merge Triplets to Form Target Triplet (Release Gate Versions)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q09_merge_triplets_to_form_target_triplet

fun mergeTriplets(triplets: Array<IntArray>, target: IntArray): Boolean {
    val hit = BooleanArray(3)
    for (t in triplets) {
        if (t[0] > target[0] || t[1] > target[1] || t[2] > target[2]) continue // would overshoot
        for (i in 0..2) if (t[i] == target[i]) hit[i] = true
    }
    return hit.all { it }
}
