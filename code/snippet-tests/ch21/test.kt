fun main() { val r = java.util.Random(5)
  repeat(300) { val f = IntArray(1 + r.nextInt(8)) { 1 + r.nextInt(9) }; val d = 1 + r.nextInt(f.size)
    var q = f.max(); fun need(Q: Int): Int { var u = 0; var c = 1; for (x in f) { if (u + x > Q) { c++; u = 0 }; u += x }; return c }
    while (need(q) > d) q++; check(minDailyQuota(f, d) == q) }
  println("kotlin ok") }
