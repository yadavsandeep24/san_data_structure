// Types copied from Ch06_Implementations so this problem compiles on its own.

struct Queue<Element> {
    private var storage: [Element] = []
    private var head = 0

    var isEmpty: Bool { head >= storage.count }

    mutating func enqueue(_ x: Element) {
        storage.append(x)
    }

    mutating func dequeue() -> Element? {
        guard head < storage.count else { return nil }
        defer {
            head += 1
            if head > 32 && head * 2 >= storage.count {
                storage.removeFirst(head)
                head = 0
            }
        }
        return storage[head]
    }

    func peek() -> Element? {
        head < storage.count ? storage[head] : nil
    }
}
