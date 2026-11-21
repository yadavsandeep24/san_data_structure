// Q5. Text Editor with a Cursor (Note Field on a Form)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

final class TextEditor {
    private var left: [Character] = []
    private var right: [Character] = []   // stored backwards: its end is the cursor

    func insert(_ text: String) { left.append(contentsOf: text) }

    func moveLeft(_ x: Int) {
        for _ in 0..<min(x, left.count) { right.append(left.removeLast()) }
    }

    func moveRight(_ x: Int) {
        for _ in 0..<min(x, right.count) { left.append(right.removeLast()) }
    }

    @discardableResult func backspace(_ x: Int) -> Int {
        let n = min(x, left.count)
        left.removeLast(n)
        return n
    }

    @discardableResult func delete(_ x: Int) -> Int {
        let n = min(x, right.count)
        right.removeLast(n)
        return n
    }

    // Up to x characters immediately left of the cursor.
    func print(_ x: Int) -> String { String(left.suffix(max(0, x))) }

    func text() -> String { String(left) + String(right.reversed()) }
}
