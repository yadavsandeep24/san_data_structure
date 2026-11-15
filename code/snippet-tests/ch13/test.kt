fun check(c: Boolean, m: String) { if (!c) throw AssertionError(m) }
fun main() {
    val r = java.util.Random(1)
    repeat(500) {
        val n = r.nextInt(12)
        val a = IntArray(n) { r.nextInt(5) - 2 }
        val s = a.sortedArray()
        val d = s.copyOf(); val k = dedupeSortedInPlace(d); check(d.copyOf(k).toList() == s.distinct(), "dedupe")
        val m = a.copyOf(); moveZeroes(m); check(m.toList() == a.filter { it != 0 } + a.filter { it == 0 }, "mz")
        check(sortedSquares(s).toList() == s.map { it * it }.sorted(), "sq")
        val c = IntArray(n) { Math.abs(a[it]) % 3 }; val c2 = c.copyOf(); sortColors(c2); check(c2.toList() == c.sorted(), "colors")
    }
    check(isSubsequence("jdoe", "John Doe") && !isSubsequence("jdx", "John Doe"), "sub")
    val list = Node(1, Node(2, Node(3, Node(4))))
    check(middleNode(list)?.value == 3, "mid even"); check(middleNode(Node(1, Node(2, Node(3))))?.value == 2, "mid odd")
    println("kotlin tests passed")
}
