fun check(c: Boolean, m: String) { if (!c) throw AssertionError(m) }
fun main() {
    val r = java.util.Random(11)
    repeat(400) {
        val n = 1 + r.nextInt(10); val a = IntArray(n) { r.nextInt(6) }
        check(nextGreaterValues(a).toList() == List(n) { i -> ((i + 1) until n).firstOrNull { a[it] > a[i] }?.let { a[it] } ?: -1 }, "ng")
        check(nextGreaterCircular(a).toList() == List(n) { i -> (1 until n).firstOrNull { a[(i + it) % n] > a[i] }?.let { a[(i + it) % n] } ?: -1 }, "ngc")
        val ps = PriceSpan(); for (i in 0 until n) { var s = 0; var j = i; while (j >= 0 && a[j] <= a[i]) { s++; j-- }; check(ps.next(a[i]) == s, "span") }
        var tot = 0; for (i in 0 until n) for (j in i until n) tot += (i..j).minOf { a[it] }; check(sumSubarrayMins(a) == tot, "ssm")
        val num = a.joinToString(""); val k = r.nextInt(n + 1)
        var best: String? = null
        fun rec(i: Int, cur: String) { if (cur.length == n - k) { val v = cur.trimStart('0').ifEmpty { "0" }; val b = best; if (b == null || v.length < b.length || (v.length == b.length && v < b)) best = v; return }; if (i == n) return; rec(i + 1, cur + num[i]); rec(i + 1, cur) }
        rec(0, ""); check(removeKdigits(num, k) == best, "rk")
    }
    check(sumSubarrayMins(IntArray(30000) { 30000 }) >= 0, "big")
    println("kotlin ok")
}
