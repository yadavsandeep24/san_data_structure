// P2: Two-level (memory + disk) cache API sketch
// Source: solutions/ch18/README.md

protocol MemoryCache {
    associatedtype Key: Hashable
    associatedtype Value
    func get(_ key: Key) -> Value?
    func put(_ key: Key, _ value: Value)
    func remove(_ key: Key)
    func trimToHalf()
    func clear()
}

protocol DiskCache {
    associatedtype Key: Hashable
    associatedtype Value
    func get(_ key: Key) -> Value?
    func put(_ key: Key, _ value: Value)
    func remove(_ key: Key)
}

enum TrimLevel { case mild, critical }

final class TwoLevelCache<M: MemoryCache, D: DiskCache>
where M.Key == D.Key, M.Value == D.Value {
    private let memory: M
    private let disk: D
    init(memory: M, disk: D) {
        self.memory = memory
        self.disk = disk
    }

    func get(_ key: M.Key) -> M.Value? {
        if let v = memory.get(key) { return v }
        guard let v = disk.get(key) else { return nil }
        memory.put(key, v)
        return v
    }

    func put(_ key: M.Key, _ value: M.Value) {
        memory.put(key, value)
        disk.put(key, value)
    }

    func trimMemory(_ level: TrimLevel) {
        switch level {
        case .mild: memory.trimToHalf()
        case .critical: memory.clear()
        }
    }
}
