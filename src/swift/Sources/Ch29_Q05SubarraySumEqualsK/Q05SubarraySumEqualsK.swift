// Q5. Subarray Sum Equals K
// Source: book/part-viii/29-interview-questions-q01-q10.md

func subarraySum(_ nums: [Int], _ k: Int) -> Int {
    var freq: [Int: Int] = [0: 1]
    var sum = 0, ans = 0
    for x in nums {
        sum += x
        ans += freq[sum - k, default: 0]
        freq[sum, default: 0] += 1
    }
    return ans
}
