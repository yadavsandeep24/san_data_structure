// Q1. Evaluate Reverse Polish Notation (Calculator Keypad Engine)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q01_evaluate_reverse_polish_notation

fun evalRPN(tokens: Array<String>): Int {
    val stack = ArrayDeque<Int>()
    for (t in tokens) {
        if (t == "+" || t == "-" || t == "*" || t == "/") {
            val b = stack.removeLast()
            val a = stack.removeLast()
            stack.addLast(
                when (t) {
                    "+" -> a + b
                    "-" -> a - b
                    "*" -> a * b
                    else -> a / b // Kotlin Int division truncates toward zero
                }
            )
        } else {
            stack.addLast(t.toInt())
        }
    }
    return stack.removeLast()
}
