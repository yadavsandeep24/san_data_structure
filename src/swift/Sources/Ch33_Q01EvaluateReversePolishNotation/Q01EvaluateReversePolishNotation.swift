// Q1. Evaluate Reverse Polish Notation (Calculator Keypad Engine)
// Source: book/part-viii/33-stacks-binary-search.md

func evalRPN(_ tokens: [String]) -> Int {
    var stack: [Int] = []
    for t in tokens {
        if t == "+" || t == "-" || t == "*" || t == "/" {
            let b = stack.removeLast()
            let a = stack.removeLast()
            switch t {
            case "+": stack.append(a + b)
            case "-": stack.append(a - b)
            case "*": stack.append(a * b)
            default: stack.append(a / b) // Swift Int division truncates toward zero
            }
        } else {
            stack.append(Int(t) ?? 0)
        }
    }
    return stack.removeLast()
}
