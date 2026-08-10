// Smoke entry for kotlinc jar (Chapter 3 + 18 samples)
fun main() {
    val u = uniquePreserveOrder(listOf("a", "b", "a", "c"))
    check(u == listOf("a", "b", "c")) { "unique $u" }
    val k = kLargest(intArrayOf(3, 1, 5, 2, 4), 3)
    check(k == listOf(5, 4, 3)) { "kLargest $k" }
    println("kotlin")
}
