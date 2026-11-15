fun check(c: Boolean, m: String) { if (!c) throw AssertionError(m) }
fun main() {
    val r = java.util.Random(3)
    repeat(400) {
        val n = 1 + r.nextInt(12); val a = IntArray(n) { r.nextInt(10) }; val k = 1 + r.nextInt(n)
        val bin = IntArray(n) { a[it] % 2 }; val kk = r.nextInt(4); val B = r.nextInt(30); val f = IntArray(n) { a[it] % 4 }
        var bw = -1; var bl = 0; var bo = 0; var bf = 0
        for (i in 0..n - k) bw = maxOf(bw, (i until i + k).sumOf { a[it] })
        for (i in 0 until n) for (j in i until n) {
            val L = j - i + 1
            if ((i..j).sumOf { a[it] } <= B) bl = maxOf(bl, L)
            if ((i..j).count { bin[it] == 0 } <= kk) bo = maxOf(bo, L)
            if ((i..j).map { f[it] }.toSet().size <= 2) bf = maxOf(bf, L)
        }
        check(maxWindowSum(a, k) == bw, "mws"); check(findMaxAverage(a, k) == bw.toDouble() / k, "avg")
        check(longestWithinBudget(a, B) == bl, "b"); check(longestOnes(bin, kk) == bo, "o"); check(totalFruit(f) == bf, "f")
    }
    println("kotlin ok")
}
