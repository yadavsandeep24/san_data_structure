// Classic bit tricks
// Source: book/part-vii/27-bits-matrix.md

func singleNumber(_ nums: [Int]) -> Int {
    nums.reduce(0, ^)
}

func isPowerOfTwo(_ n: Int) -> Bool {
    n > 0 && (n & (n - 1)) == 0
}

func hammingWeight(_ n: Int) -> Int {
    var x = UInt32(truncatingIfNeeded: n) // 32-bit view, same as Kotlin Int / TS `>>> 0`
    var c = 0
    while x != 0 {
        x &= x - 1
        c += 1
    }
    return c
}
