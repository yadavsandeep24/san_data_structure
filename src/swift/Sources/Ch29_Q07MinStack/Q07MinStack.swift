// Q7. Min Stack (Debug Overlay)
// Source: book/part-viii/29-interview-questions-q01-q10.md

final class MinStack {
    private var st: [(Int, Int)] = []
    func push(_ x: Int) {
        let m = st.last.map { min(x, $0.1) } ?? x
        st.append((x, m))
    }
    func pop() { st.removeLast() }
    func top() -> Int { st.last!.0 }
    func getMin() -> Int { st.last!.1 }
}
