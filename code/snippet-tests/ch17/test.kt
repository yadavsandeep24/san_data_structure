fun check(c: Boolean, m: String) { if (!c) throw AssertionError(m) }
fun main() {
    val r = java.util.Random(17)
    fun gen() = List(r.nextInt(7)) { val s = r.nextInt(15); intArrayOf(s, s + 1 + r.nextInt(5)) }
    repeat(500) {
        val iv = gen()
        val pk = (0 until 25).maxOf { x -> iv.count { it[0] <= x && x < it[1] } }
        check(peakConcurrent(iv) == pk, "peak"); check(canAttendAll(iv) == (pk <= 1), "attend")
        val m = mergeBusy(iv)
        for (x in 0 until 25) check(m.any { it[0] <= x && x < it[1] } == iv.any { it[0] <= x && x < it[1] }, "mcov")
        for (i in 1 until m.size) check(m[i][0] > m[i - 1][1], "merged")
        val kept = iv.indices.count { i -> iv.indices.none { j -> j != i && iv[j][0] <= iv[i][0] && iv[i][1] <= iv[j][1] && (iv[j][0] != iv[i][0] || iv[j][1] != iv[i][1] || j < i) } }
        check(removeCoveredIntervals(iv) == kept, "cov")
        val A = mergeBusy(gen()); val B = mergeBusy(gen()); val d = 1 + r.nextInt(4)
        fun ok(L: List<IntArray>, st: Int) = L.any { it[0] <= st && st + d <= it[1] }
        val st = (0 until 30).firstOrNull { ok(A, it) && ok(B, it) }
        val got = meetingScheduler(A, B, d)
        check((got?.toList()) == st?.let { listOf(it, it + d) }, "sched")
    }
    println("kotlin ok")
}
