// Q12. Random Sample from a Stream (Reservoir Sampling of Audit Events)
// Source: book/part-viii/37-math-and-number-drills.md

func reservoirSample<T, S: Sequence, G: RandomNumberGenerator>(
    _ items: S, _ k: Int, using rng: inout G
) -> [T] where S.Element == T {
    var reservoir: [T] = []
    reservoir.reserveCapacity(k)
    for (i, item) in items.enumerated() {
        if i < k { reservoir.append(item) }
        else {
            let j = Int.random(in: 0...i, using: &rng)  // keep item i with probability k / (i + 1)
            if j < k { reservoir[j] = item }
        }
    }
    return reservoir
}
