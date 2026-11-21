// Q12. Random Sample from a Stream (Reservoir Sampling of Audit Events)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q12_random_sample_from_a_stream

import kotlin.random.Random

fun <T> reservoirSample(items: Sequence<T>, k: Int, random: Random = Random.Default): List<T> {
    require(k >= 0)
    val reservoir = ArrayList<T>(k)
    items.forEachIndexed { i, item ->
        if (i < k) reservoir.add(item)
        else {
            val j = random.nextLong(i + 1L)             // keep item i with probability k / (i + 1)
            if (j < k) reservoir[j.toInt()] = item
        }
    }
    return reservoir
}
