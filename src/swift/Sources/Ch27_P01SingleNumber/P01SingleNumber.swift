// P1: Single number
// Source: solutions/ch27/README.md

func singleNumber(_ nums: [Int]) -> Int {
    nums.reduce(0, ^)
}
