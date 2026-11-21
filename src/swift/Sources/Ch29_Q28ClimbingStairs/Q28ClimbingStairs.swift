// Q28. Climbing Stairs
// Source: book/part-viii/29-interview-questions-q21-q30.md

func climbStairs(_ n: Int) -> Int {
    if n <= 2 { return n }
    var a = 1, b = 2
    for _ in 3...n { (a, b) = (b, a + b) }
    return b
}
