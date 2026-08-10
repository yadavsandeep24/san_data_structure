# Chapter 23 — Model Solutions

Model solutions for Chapter 23 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-vi/23-concurrency.md`](../../book/part-vi/23-concurrency.md).

---

## P1: Thread-safe counter

### Approach

Protect a mutable `Int` so concurrent increments cannot lose updates. Options: **mutex / lock**, **serial queue**, **atomic integer**, or **Swift actor**. All serialize the read-modify-write. Prefer the idiomatic tool per platform (actor on modern Swift; `AtomicInteger` or `Mutex` on Kotlin; promise-chain or Worker+Atomics on TS; isolate/lock on Dart).

### Complexity

- Time: O(1) per increment/get (plus lock/schedule overhead)
- Space: O(1)

### Edge cases

- High contention — prefer atomics for a lone counter
- Reading without the same protection as writes → torn/stale values
- Deadlock if `get` called while already holding a non-reentrant lock from the same thread (depends on API)

### Mobile note

Badge counts, analytics event tallies, in-flight request counters. Keep critical sections tiny — never do I/O under the lock. UI reads should hop to the main thread *after* reading a snapshot.

### Kotlin

```kotlin
import java.util.concurrent.atomic.AtomicInteger
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

class AtomicCounter {
    private val value = AtomicInteger(0)
    fun increment(): Int = value.incrementAndGet()
    fun get(): Int = value.get()
}

class MutexCounter {
    private val mutex = Mutex()
    private var value = 0
    suspend fun increment(): Int = mutex.withLock { ++value }
    suspend fun get(): Int = mutex.withLock { value }
}
```

### Swift

```swift
actor SafeCounter {
    private var value = 0
    func increment() -> Int {
        value += 1
        return value
    }
    func get() -> Int { value }
}

final class QueueCounter {
    private let queue = DispatchQueue(label: "counter.serial")
    private var value = 0
    @discardableResult
    func increment() -> Int {
        queue.sync {
            value += 1
            return value
        }
    }
    func get() -> Int { queue.sync { value } }
}
```

### Dart

```dart
import 'dart:async';

/// Command-serialized counter (single isolate).
class SerialCounter {
  int _value = 0;
  Future<void> _chain = Future.value();

  Future<int> increment() {
    final completer = Completer<int>();
    _chain = _chain.then((_) async {
      _value++;
      completer.complete(_value);
    });
    return completer.future;
  }

  Future<int> get() {
    final completer = Completer<int>();
    _chain = _chain.then((_) async {
      completer.complete(_value);
    });
    return completer.future;
  }
}
```

### TypeScript

```typescript
class SerialCounter {
  private value = 0;
  private chain: Promise<void> = Promise.resolve();

  increment(): Promise<number> {
    const run = this.chain.then(() => ++this.value);
    this.chain = run.then(() => {}, () => {});
    return run;
  }

  get(): Promise<number> {
    const run = this.chain.then(() => this.value);
    this.chain = run.then(() => {}, () => {});
    return run;
  }
}
```

---

## P2: Bounded blocking queue / async channel

### Approach

Maintain a FIFO buffer with capacity `C`. **Put/send** waits (blocks or suspends) while `size == C`; **take/receive** waits while empty. On success, wake the opposite waiters. This applies **backpressure**: a fast network producer cannot unbounded-grow memory.

### Complexity

- Time: O(1) amortized per op excluding wait time
- Space: O(C)

### Edge cases

- Capacity `1` (rendezvous-like handoff)
- Multiple producers / consumers — need proper condition signaling
- Shutdown / cancellation — avoid forever-blocked waiters
- Never use capacity `Integer.MAX_VALUE` “to be safe”

### Mobile note

Image decode pipelines, WebSocket fan-in, log shippers. Bound buffers to tens or hundreds of chunks; drop or sample telemetry if losing data is acceptable. Prefer structured concurrency cancellation so suspended senders do not leak.

### Kotlin

```kotlin
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock
import kotlinx.coroutines.channels.Channel

/** Classic blocking bounded queue. */
class BoundedBlockingQueue<T>(private val capacity: Int) {
    private val q = ArrayDeque<T>()
    private val lock = ReentrantLock()
    private val notEmpty = lock.newCondition()
    private val notFull = lock.newCondition()

    fun put(item: T) {
        lock.withLock {
            while (q.size == capacity) notFull.await()
            q.addLast(item)
            notEmpty.signal()
        }
    }

    fun take(): T = lock.withLock {
        while (q.isEmpty()) notEmpty.await()
        val item = q.removeFirst()
        notFull.signal()
        item
    }
}

/** Async channel sketch (preferred in coroutines). */
fun <T> boundedChannel(capacity: Int) = Channel<T>(capacity)
// producer: channel.send(x)  // suspends when full
// consumer: channel.receive() / for (x in channel)
```
### Swift

```swift
actor BoundedAsyncQueue<T> {
    private var storage: [T] = []
    private let capacity: Int
    private var putWaiters: [CheckedContinuation<Void, Never>] = []
    private var takeWaiters: [CheckedContinuation<T, Never>] = []

    init(capacity: Int) {
        precondition(capacity > 0)
        self.capacity = capacity
    }

    func put(_ value: T) async {
        while storage.count >= capacity {
            await withCheckedContinuation { putWaiters.append($0) }
        }
        if !takeWaiters.isEmpty {
            let waiter = takeWaiters.removeFirst()
            waiter.resume(returning: value)
        } else {
            storage.append(value)
            if !putWaiters.isEmpty {
                // space unchanged for put waiters unless we drained — n/a
            }
        }
        resumePutWaitersIfNeeded()
    }

    func take() async -> T {
        if !storage.isEmpty {
            let v = storage.removeFirst()
            resumePutWaitersIfNeeded()
            return v
        }
        return await withCheckedContinuation { takeWaiters.append($0) }
    }

    private func resumePutWaitersIfNeeded() {
        while storage.count < capacity, !putWaiters.isEmpty {
            putWaiters.removeFirst().resume()
        }
    }
}
```

### Dart

```dart
import 'dart:async';
import 'dart:collection';

class BoundedAsyncQueue<T> {
  BoundedAsyncQueue(this.capacity) : assert(capacity > 0);
  final int capacity;
  final Queue<T> _q = Queue();
  final Queue<Completer<void>> _putWaiters = Queue();
  final Queue<Completer<T>> _takeWaiters = Queue();

  Future<void> put(T value) async {
    while (_q.length >= capacity && _takeWaiters.isEmpty) {
      final c = Completer<void>();
      _putWaiters.add(c);
      await c.future;
    }
    if (_takeWaiters.isNotEmpty) {
      _takeWaiters.removeFirst().complete(value);
    } else {
      _q.add(value);
    }
    _drainPutWaiters();
  }

  Future<T> take() async {
    if (_q.isNotEmpty) {
      final v = _q.removeFirst();
      _drainPutWaiters();
      return v;
    }
    final c = Completer<T>();
    _takeWaiters.add(c);
    return c.future;
  }

  void _drainPutWaiters() {
    while (_q.length < capacity && _putWaiters.isNotEmpty) {
      _putWaiters.removeFirst().complete();
    }
  }
}
```

### TypeScript

```typescript
class BoundedAsyncQueue<T> {
  private q: T[] = [];
  private putWaiters: Array<() => void> = [];
  private takeWaiters: Array<(v: T) => void> = [];

  constructor(private capacity: number) {
    if (capacity <= 0) throw new Error("capacity");
  }

  async put(value: T): Promise<void> {
    while (this.q.length >= this.capacity && this.takeWaiters.length === 0) {
      await new Promise<void>((r) => this.putWaiters.push(r));
    }
    const taker = this.takeWaiters.shift();
    if (taker) taker(value);
    else this.q.push(value);
    this.drainPutWaiters();
  }

  async take(): Promise<T> {
    if (this.q.length) {
      const v = this.q.shift()!;
      this.drainPutWaiters();
      return v;
    }
    return new Promise<T>((r) => this.takeWaiters.push(r));
  }

  private drainPutWaiters() {
    while (this.q.length < this.capacity && this.putWaiters.length) {
      this.putWaiters.shift()!();
    }
  }
}
```

---

## P3: Detect if a race explanation is correct

Short design answers. No full apps required; counter/queue code above is the coding half of this chapter.

### Prompts and model judgments

**A.** “Two threads call `count++` on a shared `Int`. There is no race because each thread has its own stack.”

- **Incorrect.** Stack frames hold locals; `count` lives on the **heap** (or shared static storage). Both threads read-modify-write the same location → lost updates.

**B.** “We only write the map from a background queue and only read it from the main thread, never concurrently. No lock is required.”

- **Correct if truly exclusive** (confinement + published happens-before when hopping threads — e.g. dispatch async to main after the write completes). **Incorrect** if background may still write while main reads.

**C.** “In JavaScript, `let n = 0; async function inc(){ const x = n; await fetch(...); n = x+1 }` cannot race because JS is single-threaded.”

- **Incorrect / incomplete.** One JS thread still **interleaves** at `await`; another task can run `inc` and lose updates. Also Workers / native modules introduce real parallelism.

**D.** “A `Channel(16)` between socket reader and parser is better than an unbounded list for downloads.”

- **Correct.** Bounded capacity **backpressures** the producer and caps memory.

**E.** “`ConcurrentHashMap` makes this safe: `if (!map.containsKey(k)) map.put(k, v)`.”

- **Incorrect** as a compound action. Another thread can interleave between contains and put. Use `putIfAbsent` / compute APIs or external synchronization.

### Mobile note

Interviewers care that you spot **shared mutable state** and **compound actions**, not that you recite lock bitmasks. Prefer confinement and structured concurrency on iOS/Android over sprinkling locks everywhere.

### Optional tiny “quiz harness” (TypeScript)

```typescript
type Verdict = "correct" | "incorrect";

function grade(explanationId: string): Verdict {
  switch (explanationId) {
    case "A": return "incorrect"; // stack myth
    case "B": return "correct";   // if confinement holds
    case "C": return "incorrect"; // await interleaving
    case "D": return "correct";   // backpressure
    case "E": return "incorrect"; // check-then-act
    default: throw new Error("unknown");
  }
}
```

Same judgments apply in Kotlin/Swift/Dart interviews — the concurrency model differs; the fallacies (stack myth, check-then-act, unbounded queues) do not.
