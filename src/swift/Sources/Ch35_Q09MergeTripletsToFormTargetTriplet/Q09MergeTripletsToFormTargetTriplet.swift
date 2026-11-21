// Q9. Merge Triplets to Form Target Triplet (Release Gate Versions)
// Source: book/part-viii/35-heaps-tries-greedy.md

func mergeTriplets(_ triplets: [[Int]], _ target: [Int]) -> Bool {
    var hit = [false, false, false]
    for t in triplets {
        if t[0] > target[0] || t[1] > target[1] || t[2] > target[2] { continue } // would overshoot
        for i in 0..<3 where t[i] == target[i] { hit[i] = true }
    }
    return hit.allSatisfy { $0 }
}
