// Binary search on the answer
// Source: book/part-vi/21-searching-sorting.md

func minDailyQuota(_ files: [Int], _ days: Int) -> Int {
    func daysNeeded(_ quota: Int) -> Int {
        var used = 0, count = 1
        for f in files {
            if used + f > quota { count += 1; used = 0 }
            used += f
        }
        return count
    }
    var lo = files.max()!, hi = files.reduce(0, +)
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if daysNeeded(mid) <= days { hi = mid } else { lo = mid + 1 }
    }
    return lo
}
