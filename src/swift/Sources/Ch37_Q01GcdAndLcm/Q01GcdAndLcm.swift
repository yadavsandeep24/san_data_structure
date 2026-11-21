// Q1. GCD and LCM (Reminder Schedules)
// Source: book/part-viii/37-math-and-number-drills.md

func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? a : gcd(b, a % b) }

func lcm(_ a: Int, _ b: Int) -> Int? {
    precondition(a > 0 && b > 0)
    let (result, overflow) = (a / gcd(a, b)).multipliedReportingOverflow(by: b)   // divide first
    return overflow ? nil : result                      // nil instead of trapping past Int.max
}
