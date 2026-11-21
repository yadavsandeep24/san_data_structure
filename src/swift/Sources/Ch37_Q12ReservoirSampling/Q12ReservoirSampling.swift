// Q12 — Reservoir sampling (Swift / Dart)
// Source: solutions/ch37/README.md

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
