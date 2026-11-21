// Q13. Stable Percentage Rollout (New Signing Flow Flag)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

func fnv1a(_ s: String) -> Int32 {
    var h = Int32(bitPattern: 0x811C9DC5)
    for b in s.utf8 {
        h ^= Int32(b)
        h = h &* 0x01000193        // wrapping multiply, same bits as Kotlin Int
    }
    return h
}

/// Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags.
func bucket(_ flag: String, _ userId: String) -> Int {
    let r = Int(fnv1a("\(flag):\(userId)")) % 10_000
    return r < 0 ? r + 10_000 : r  // floorMod
}

func isOn(_ flag: String, _ userId: String, _ percent: Double) -> Bool {
    bucket(flag, userId) < Int(percent * 100)
}
