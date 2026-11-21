// Set algebra: union, intersection, difference
// Source: book/part-iii/08-sets.md

let a: Set = [1, 2, 3]
let b: Set = [2, 3, 4]
let union = a.union(b)             // 1,2,3,4
let inter = a.intersection(b)      // 2,3
let diff = a.subtracting(b)        // 1
