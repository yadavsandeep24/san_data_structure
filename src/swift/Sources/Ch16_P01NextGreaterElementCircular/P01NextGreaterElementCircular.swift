// P1: Next greater element, circular
// Source: solutions/ch16/README.md

func nextGreaterCircular(_ a: [Int]) -> [Int] {
    let n = a.count
    var ans = [Int](repeating: -1, count: n)
    var stack: [Int] = []
    for i in 0..<(2 * n) {
        let x = a[i % n]
        while let top = stack.last, a[top] < x {
            ans[top] = x
            stack.removeLast()
        }
        if i < n { stack.append(i) }
    }
    return ans
}
