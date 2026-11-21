// Q7. Search a 2D Matrix (Paged Sorted Catalogue)
// Source: book/part-viii/33-stacks-binary-search.md

func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    guard let first = matrix.first, !first.isEmpty else { return false }
    let cols = first.count
    var lo = 0, hi = matrix.count * cols - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        let v = matrix[mid / cols][mid % cols] // treat the grid as one sorted array
        if v == target { return true }
        if v < target { lo = mid + 1 } else { hi = mid - 1 }
    }
    return false
}
