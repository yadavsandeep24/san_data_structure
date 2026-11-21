// Screen navigation as a graph
// Source: book/part-iii/11-graphs-intro.md
package ch11.screen_navigation_as_a_graph

val nav = mapOf(
    "Home" to listOf("Product", "Login", "Cart"),
    "Product" to listOf("Cart", "Home"),
    "Cart" to listOf("Checkout", "Home"),
    "Checkout" to listOf("Home"),
    "Login" to listOf("Home"),
)
