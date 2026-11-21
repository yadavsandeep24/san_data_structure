// P1: Climbing stairs
// Source: solutions/ch24/README.md

func climbStairs(_ n: Int) -> Int {
    if n <= 2 { return n }
    var a = 1, b = 2
    for _ in 3...n {
        let c = a + b
        a = b
        b = c
    }
    return b
}
