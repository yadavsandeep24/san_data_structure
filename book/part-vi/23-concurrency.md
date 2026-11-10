# Chapter 23 — Concurrency & Thread-Safe Structures

## Mobile motivation

Tap “Pay,” fire a network call, update a badge, write to a cache — **multiple threads or async tasks** touch shared state. A race that corrupts a counter in a demo becomes a lost payment callback or double-charged analytics in production. This chapter starts from **race conditions**, then covers **confinement**, **serial queues**, **Swift actors**, **atomics**, concurrent collections, and **producer-consumer / backpressure** for network pipelines.

## Race conditions from zero

A **race** exists when the correctness of a result depends on uncontrolled timing between concurrent accesses to shared mutable state.

Classic lost update:

```text
// Thread A and B both do: count = count + 1
// Expected +2, sometimes get +1
read count → 0
read count → 0
write 1
write 1
```

Even “one-liners” like `count++` are typically **read-modify-write**, not atomic.

### Broken counter (do not ship)

**Kotlin**

```kotlin
// Shared without synchronization
var count = 0
fun inc() { count++ } // race if called from many threads
```

**Swift**

```swift
// Shared without synchronization
final class UnsafeCounter {
    var count = 0
    func inc() { count += 1 } // race if called from many threads
}
```

**Dart** — single-threaded like JS; `await` is the interleaving point

```dart
// One isolate, no threads — yet an await between read and write loses updates.
var count = 0;
Future<void> inc() async {
  final c = count;
  await Future<void>.value(); // yield — another task can interleave
  count = c + 1;
}
```

**TypeScript**

```typescript
// JS is single-threaded for JS heap — races still appear with
// shared buffers, native modules, or incorrect assumptions about await.
let count = 0;
async function inc() {
  const c = count;
  await Promise.resolve(); // yield — another task can interleave
  count = c + 1;
}
```

JavaScript’s main thread avoids true parallel mutation of ordinary objects, but **`await` interleaving**, Worker threads, and native modules reintroduce concurrency bugs. Treat shared mutable state carefully on every platform.

## Confinement

**Confinement** means only one context ever touches the data — no locks required.

| Style | Idea | Mobile example |
|-------|------|----------------|
| **Thread confinement** | Object lives on one thread | UIKit/MainActor UI; Android main-thread Views |
| **Instance confinement** | Object encapsulated; all access via synchronized owner | Private map behind a serial queue |
| **Stack confinement** | Locals only; never published | Pure function temps |

**Rule:** UI widgets stay on the main/UI isolate/thread. Move heavy work off-main; publish results back via a safe hop.

## Serial queues

A **serial queue** executes blocks one-at-a-time FIFO. Shared state mutated only from that queue is safe without fine-grained locks.

**Swift (GCD)** — prefer **`actor`** for new code (see below). GCD remains common in legacy modules:

```swift
final class Counter {
    private let queue = DispatchQueue(label: "counter.serial")
    private var value = 0
    func increment() {
        queue.sync { value += 1 }
    }
    func get() -> Int {
        queue.sync { value }
    }
}
```

**GCD footgun:** never call `queue.sync` from a block already running on that queue (deadlock on main). Prefer `actor SafeCounter` or `@MainActor` for UI-adjacent state.

**Kotlin** — single-thread dispatcher or mutex:

```kotlin
class Counter {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private var value = 0
    suspend fun increment() = mutex.withLock { value++ }
    suspend fun get() = mutex.withLock { value }
}
```

**Dart** — prefer isolate message passing for true parallelism; within one isolate, async interleaving still needs care for shared mutable fields (similar to JS). Use a lock/`synchronized` package or serialize through a single `Stream`/`Queue` of commands. Dependency-free, the same future-chain idea as the TypeScript version below:

```dart
import 'dart:async';

class SerialQueue {
  Future<void> _chain = Future.value();

  Future<T> enqueue<T>(FutureOr<T> Function() fn) {
    final run = _chain.then((_) => fn());
    _chain = run.then((_) {}, onError: (_) {});
    return run;
  }
}
```

**TypeScript** — serialize with a promise chain mutex:

```typescript
class SerialQueue {
  private chain: Promise<void> = Promise.resolve();
  enqueue<T>(fn: () => Promise<T> | T): Promise<T> {
    const run = this.chain.then(() => fn());
    this.chain = run.then(() => {}, () => {});
    return run;
  }
}
```

## Swift actors

An **actor** isolates its mutable state. Calls from outside are **async** and automatically serialized.

```swift
actor SafeCounter {
    private var value = 0
    func increment() { value += 1 }
    func get() -> Int { value }
}

// usage
let c = SafeCounter()
await c.increment()
print(await c.get())
```

Actors prevent data races at compile time for actor-isolated properties. Prefer actors over ad-hoc locks for new Swift concurrency code. UI types often use `@MainActor`.

The other three have no `actor` keyword; these are the closest equivalents of the same idea (one owner, serialized access):

**Kotlin** — a single-parallelism dispatcher confines the state

```kotlin
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

// No `actor` keyword: confine the state to a one-at-a-time dispatcher.
class SafeCounter {
    private val confined = Dispatchers.Default.limitedParallelism(1)
    private var value = 0
    suspend fun increment() = withContext(confined) { value++ }
    suspend fun get() = withContext(confined) { value }
}
```

**Dart** — an isolate is a real actor: separate heap, message passing only

```dart
import 'dart:isolate';

// An isolate is Dart's actor: it owns its heap and is reached only by messages.
Future<SendPort> spawnCounter() async {
  final ready = ReceivePort();
  await Isolate.spawn(_counterMain, ready.sendPort);
  return await ready.first as SendPort;
}

void _counterMain(SendPort ready) {
  var value = 0; // only this isolate can touch it
  final inbox = ReceivePort();
  ready.send(inbox.sendPort);
  inbox.listen((msg) {
    final (cmd, reply) = msg as (String, SendPort);
    if (cmd == 'inc') value++;
    reply.send(value);
  });
}

Future<int> ask(SendPort counter, String cmd) async {
  final reply = ReceivePort();
  counter.send((cmd, reply.sendPort));
  return await reply.first as int;
}
```

**TypeScript** — an actor-like wrapper; matters once methods `await` inside

```typescript
// No `actor` keyword: route every method through the SerialQueue above.
class SafeCounter {
  private q = new SerialQueue();
  private value = 0;
  increment(): Promise<void> {
    return this.q.enqueue(() => { this.value++; });
  }
  get(): Promise<number> {
    return this.q.enqueue(() => this.value);
  }
}
```

## Atomics

**Atomic** operations update a value with hardware/OS guarantees (e.g. compare-and-swap). Good for counters and flags; not a substitute for multi-field invariants (use locks/actors for “check then act” across fields).

| Platform | Tool |
|----------|------|
| Kotlin/JVM | `AtomicInteger`, `AtomicReference` |
| Swift | `OSAllocatedUnfairLock`, atomics package / `ManagedAtomic` (evolution varies by SDK) |
| Dart | Limited; prefer isolates or locks for shared memory |
| TypeScript | `Atomics` on `SharedArrayBuffer` (Workers) |

**Kotlin**

```kotlin
val count = java.util.concurrent.atomic.AtomicInteger(0)
count.incrementAndGet()
```

**Swift** — the `Synchronization` module

```swift
import Synchronization

let count = Atomic<Int>(0) // iOS 18+ / macOS 15+; older SDKs: OSAllocatedUnfairLock
count.add(1, ordering: .relaxed)
```

**Dart** — no shared-memory atomics. Inside one isolate, synchronous code between `await`s runs without preemption, so a plain `count++` is already safe there; across isolates, send messages instead.

**TypeScript** — only meaningful with Workers sharing the buffer

```typescript
const count = new Int32Array(new SharedArrayBuffer(4)); // shareable with Workers
Atomics.add(count, 0, 1);
```

## Concurrent collections — notes

| Structure | Caution |
|-----------|---------|
| `ConcurrentHashMap` (JVM) | Thread-safe map ops; compound “check then put” may still need external sync |
| `CopyOnWriteArrayList` | Great for rare writes / many reads; writes copy whole array |
| Swift `Dictionary` / `Array` | **Not** thread-safe; confine or protect |
| Dart collections | Not safe across isolates; send messages / immutable copies |
| JS objects / `Map` | Safe from parallel JS threads only if single-threaded; Workers need structured clone / SAB |

**Never** assume “collection looks concurrent-friendly” means compound operations are atomic.

## Producer-consumer and backpressure (network)

Network layers **produce** chunks faster than UI or disk **consumes** them. Without bounds, queues grow until OOM.

```text
Producer (socket) → bounded buffer → Consumer (parser / UI)
                     ↑
              backpressure: block / suspend producer when full
```

| Strategy | Behavior |
|----------|----------|
| **Bounded blocking queue** | `put` waits if full; `take` waits if empty |
| **Drop / sample** | Real-time telemetry: drop oldest or newest |
| **Async channel** | Suspending send/receive (Kotlin channels, Swift AsyncStream with buffering policy) |
| **Reactive demand** | Consumer requests n items (Rx / Flowable) |

**Kotlin**

```kotlin
// Sketch: capacity 16
val channel = kotlinx.coroutines.channels.Channel<ByteArray>(16)
// producer
channel.send(chunk) // suspends when full
// consumer
for (chunk in channel) parse(chunk)
```

**Swift**

```swift
actor BoundedBuffer<T> {
    private var q: [T] = []
    private let capacity: Int
    private var putWaiters: [CheckedContinuation<Void, Never>] = []
    private var takeWaiters: [CheckedContinuation<T, Never>] = []

    init(capacity: Int) {
        precondition(capacity > 0)
        self.capacity = capacity
    }

    func put(_ x: T) async {
        while q.count >= capacity {
            await withCheckedContinuation { putWaiters.append($0) }
        }
        if !takeWaiters.isEmpty {
            takeWaiters.removeFirst().resume(returning: x)
        } else {
            q.append(x)
        }
        resumePutWaiters()
    }

    func take() async -> T {
        if !q.isEmpty {
            let x = q.removeFirst()
            resumePutWaiters()
            return x
        }
        return await withCheckedContinuation { takeWaiters.append($0) }
    }

    private func resumePutWaiters() {
        while q.count < capacity, !putWaiters.isEmpty {
            putWaiters.removeFirst().resume()
        }
    }
}
```

**Dart** — same waiter queues with `Completer`s on one isolate

```dart
import 'dart:async';
import 'dart:collection';

class BoundedBuffer<T> {
  BoundedBuffer(this.capacity) : assert(capacity > 0);
  final int capacity;
  final _q = Queue<T>();
  final _putWaiters = Queue<Completer<void>>();
  final _takeWaiters = Queue<Completer<T>>();

  Future<void> put(T x) async {
    while (_q.length >= capacity) {
      final c = Completer<void>();
      _putWaiters.add(c);
      await c.future;
    }
    if (_takeWaiters.isNotEmpty) {
      _takeWaiters.removeFirst().complete(x);
    } else {
      _q.add(x);
    }
    _resumePutWaiters();
  }

  Future<T> take() {
    if (_q.isNotEmpty) {
      final x = _q.removeFirst();
      _resumePutWaiters();
      return Future.value(x);
    }
    final c = Completer<T>();
    _takeWaiters.add(c);
    return c.future;
  }

  void _resumePutWaiters() {
    while (_q.length < capacity && _putWaiters.isNotEmpty) {
      _putWaiters.removeFirst().complete();
    }
  }
}
```

**TypeScript** — same shape with promise resolvers

```typescript
class BoundedBuffer<T> {
  private q: T[] = [];
  private putWaiters: Array<() => void> = [];
  private takeWaiters: Array<(x: T) => void> = [];
  private capacity: number;

  constructor(capacity: number) {
    if (capacity <= 0) throw new Error("capacity must be > 0");
    this.capacity = capacity;
  }

  async put(x: T): Promise<void> {
    while (this.q.length >= this.capacity) {
      await new Promise<void>((resolve) => this.putWaiters.push(resolve));
    }
    const taker = this.takeWaiters.shift();
    if (taker) taker(x);
    else this.q.push(x);
    this.resumePutWaiters();
  }

  take(): Promise<T> {
    if (this.q.length) {
      const x = this.q.shift() as T;
      this.resumePutWaiters();
      return Promise.resolve(x);
    }
    return new Promise<T>((resolve) => this.takeWaiters.push(resolve));
  }

  private resumePutWaiters(): void {
    while (this.q.length < this.capacity && this.putWaiters.length) {
      this.putWaiters.shift()?.();
    }
  }
}
```

Full four-language versions: [solutions/ch23](../../solutions/ch23/README.md#p2-bounded-blocking-queue-async-channel).

Apply backpressure to image download pipelines, log shippers, and WebSocket fan-in — not only interview queues.

## Detecting a wrong race explanation

Interview-style: someone claims “this is fine because each thread has its own stack.” **Stacks do not protect heap objects.** If two threads mutate the same `Counter` instance, stacks are irrelevant.

Someone claims “JS has no races.” **False** for `await` interleaving on shared variables, SharedArrayBuffer, and native bridges.

## Common mistakes

1. Synchronizing only writes, not reads (stale / torn reads).
2. Locking on `this` / publicly accessible objects (deadlock risk).
3. Performing network or disk I/O **inside** a lock/actor call that UI waits on.
4. Unbounded queues “for simplicity.”
5. Assuming `ConcurrentHashMap.get` + `put` is atomic as a pair.

## Self-Check

**23.1** Define a race condition in one sentence.

**23.2** What is confinement, and why can it need no locks?

**23.3** How does a serial queue make a counter safe?

**23.4** What problem does backpressure solve in a download pipeline?

**23.5** Why is “JS is single-threaded ⇒ no races” incomplete?

*(Answers: Appendix D.)*

## Practice

1. **Thread-safe counter** — [solutions/ch23](../../solutions/ch23/README.md#p1-thread-safe-counter)
2. **Bounded blocking queue / async channel sketch** — [solutions/ch23](../../solutions/ch23/README.md#p2-bounded-blocking-queue-async-channel)
3. **Detect if a race explanation is correct** — [solutions/ch23](../../solutions/ch23/README.md#p3-detect-if-a-race-explanation-is-correct)

Next: [Chapter 24 — Interview Questions](../part-vii/24-interview-questions.md) — synthesizing patterns under time pressure.
