// Swift actors
// Source: book/part-vii/28-concurrency.md

actor SafeCounter {
    private var value = 0
    func increment() { value += 1 }
    func get() -> Int { value }
}

// usage
let c = SafeCounter()
func example() async throws {
    await c.increment()
    print(await c.get())
}
