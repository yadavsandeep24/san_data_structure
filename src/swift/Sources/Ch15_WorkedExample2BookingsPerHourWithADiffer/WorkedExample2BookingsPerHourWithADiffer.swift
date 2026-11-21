// Worked example 2: bookings per hour with a difference array
// Source: book/part-iv/15-prefix-sums.md

func bookingsPerHour(_ hours: Int, _ bookings: [(start: Int, end: Int)]) -> [Int] {
    var diff = [Int](repeating: 0, count: hours + 1)
    for b in bookings {
        diff[b.start] += 1
        diff[b.end + 1] -= 1
    }
    var out = [Int](repeating: 0, count: hours)
    var running = 0
    for h in 0..<hours {
        running += diff[h]
        out[h] = running
    }
    return out
}
