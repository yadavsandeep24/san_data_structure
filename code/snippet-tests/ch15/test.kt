fun check(c: Boolean, m: String) { if (!c) throw AssertionError(m) }
fun main() {
    val r = java.util.Random(7)
    repeat(400) {
        val n = 1 + r.nextInt(10); val a = IntArray(n) { r.nextInt(9) - 4 }
        val sr = SpendRanges(LongArray(n) { a[it].toLong() }); val l = r.nextInt(n); val rr = l + r.nextInt(n - l)
        check(sr.total(l, rr) == (l..rr).sumOf { a[it].toLong() }, "range")
        val H = 1 + r.nextInt(8); val bk = List(r.nextInt(6)) { val s = r.nextInt(H); intArrayOf(s, s + r.nextInt(H - s)) }
        check(bookingsPerHour(H, bk).toList() == List(H) { h -> bk.count { it[0] <= h && h <= it[1] } }, "book")
        var piv = -1; for (i in 0 until n) { if (piv < 0 && (0 until i).sumOf { a[it] } == (i + 1 until n).sumOf { a[it] }) piv = i }
        check(pivotIndex(a) == piv, "pivot")
        val b = IntArray(n) { (a[it] + 4) % 2 }; var bl = 0
        for (i in 0 until n) for (j in i until n) { val c1 = (i..j).count { b[it] == 1 }; if (c1 * 2 == j - i + 1) bl = maxOf(bl, j - i + 1) }
        check(findMaxLength(b) == bl, "fml")
        check(countSubarraysWithSum(a, 1) == (0 until n).sumOf { i -> (i until n).count { j -> (i..j).sumOf { a[it] } == 1 } }, "cnt")
        val trips = Array(r.nextInt(5)) { val f = r.nextInt(10); intArrayOf(1 + r.nextInt(4), f, f + 1 + r.nextInt(5)) }
        val cap = r.nextInt(10); val ok = (0..20).all { x -> trips.filter { it[1] <= x && x < it[2] }.sumOf { it[0] } <= cap }
        check(carPooling(trips, cap) == ok, "car")
        val g = Array(3) { IntArray(4) { r.nextInt(5) } }; val gs = GridSums(g)
        check(gs.sum(1, 1, 2, 3) == (1..2).sumOf { rr2 -> (1..3).sumOf { g[rr2][it].toLong() } }, "grid")
    }
    println("kotlin ok")
}
