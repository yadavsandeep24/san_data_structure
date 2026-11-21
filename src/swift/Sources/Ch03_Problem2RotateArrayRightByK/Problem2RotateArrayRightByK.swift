// Problem 2 — Rotate array right by k
// Source: solutions/ch03/README.md

func rotateRightInPlace(_ a: inout [Int], kRaw: Int) {
    let n = a.count
    guard n > 0 else { return }
    var k = kRaw % n
    if k < 0 { k += n }
    guard k != 0 else { return }

    a.reverse()                                  // Θ(n)
    a[..<k].reverse()                            // Θ(k)
    a[k...].reverse()                            // Θ(n - k)
}

// var a = [1, 2, 3, 4, 5]; rotateRightInPlace(&a, kRaw: 2) // [4, 5, 1, 2, 3]
