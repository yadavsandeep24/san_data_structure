// Q13. Stable Percentage Rollout (New Signing Flow Flag)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
package ch42.q13_stable_percentage_rollout

fun fnv1a(s: String): Int {
    var h = 0x811C9DC5.toInt()
    for (c in s.toByteArray()) {
        h = h xor (c.toInt() and 0xff)
        h *= 0x01000193
    }
    return h
}

/** Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags. */
fun bucket(flag: String, userId: String) = Math.floorMod(fnv1a("$flag:$userId"), 10_000)

fun isOn(flag: String, userId: String, percent: Double) = bucket(flag, userId) < (percent * 100).toInt()
