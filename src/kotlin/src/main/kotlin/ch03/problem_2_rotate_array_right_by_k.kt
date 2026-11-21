// Problem 2 — Rotate array right by k
// Source: solutions/ch03/README.md
package ch03.problem_2_rotate_array_right_by_k

fun rotateRightInPlace(a: IntArray, kRaw: Int) {
    val n = a.size
    if (n == 0) return
    val k = ((kRaw % n) + n) % n                 // handle negative k safely
    if (k == 0) return

    fun reverse(from: Int, to: Int) {            // inclusive from, exclusive to
        var i = from
        var j = to - 1
        while (i < j) {
            val tmp = a[i]
            a[i] = a[j]
            a[j] = tmp
            i++
            j--
        }
    }

    reverse(0, n)                                // Θ(n)
    reverse(0, k)                                // Θ(k)
    reverse(k, n)                                // Θ(n - k)
}

// Example: a = [1,2,3,4,5], k = 2 → [4,5,1,2,3]
