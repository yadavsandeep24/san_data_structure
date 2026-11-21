// Q2. Daily Temperatures (Warmer-Day Countdown)
// Source: book/part-viii/33-stacks-binary-search.md

func dailyTemperatures(_ temps: [Int]) -> [Int] {
    var ans = [Int](repeating: 0, count: temps.count)
    var stack: [Int] = [] // indices, temperatures strictly decreasing
    for i in temps.indices {
        while let j = stack.last, temps[j] < temps[i] {
            stack.removeLast()
            ans[j] = i - j
        }
        stack.append(i)
    }
    return ans
}
