// Q9. Do Two Signature Fields Overlap? (Field Placement Check)
// Source: book/part-viii/37-math-and-number-drills.md

struct Box { let left: Int32; let top: Int32; let right: Int32; let bottom: Int32 }

func overlapArea(_ a: Box, _ b: Box) -> Int {
    let width = Int(min(a.right, b.right)) - Int(max(a.left, b.left))     // widen first: Int32 math traps
    let height = Int(min(a.bottom, b.bottom)) - Int(max(a.top, b.top))
    return width > 0 && height > 0 ? width * height : 0  // touching edges don't overlap
}
