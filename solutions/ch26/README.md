# Chapter 26 — Model Solutions

Model solutions for Chapter 26 practice problems. Problems are defined in [`book/part-viii/26-money-idempotency-reliability.md`](../../book/part-viii/26-money-idempotency-reliability.md).

---

## P1: Money value object + safe parse/format

### Approach

Represent money as `(amountMinor: integer, currencyCode: ISO 4217)`. All arithmetic in integers. Parse major-unit strings by splitting on `.` and scaling — never `parseFloat` / `toDouble` for the stored value. Format only at the UI boundary via locale currency formatters (division by `10^scale` is display-only).

### Complexity

- Parse / add / compare: O(1) for fixed scale
- Format: O(1) plus formatter overhead

### Edge cases

- Empty / malformed strings
- Trailing or missing fractional digits (`"10"`, `"10.5"`, `"10.999"` → policy: truncate or reject; teaching code truncates to scale)
- Currency mismatch on `+`
- Negative amounts (refunds)
- JS `number` safe-integer limit — use `bigint` for huge ledgers

### Mobile note

Never put `Double` in Room/Core Data/SharedPreferences as the source of truth for balances. Persist minor units + currency code.

### Kotlin

```kotlin
data class Money(val amountMinor: Long, val currencyCode: String) {
    init { require(currencyCode.length == 3) }

    operator fun plus(o: Money): Money {
        require(currencyCode == o.currencyCode)
        return Money(amountMinor + o.amountMinor, currencyCode)
    }

    fun format(locale: java.util.Locale = java.util.Locale.US): String {
        val nf = java.text.NumberFormat.getCurrencyInstance(locale)
        nf.currency = java.util.Currency.getInstance(currencyCode)
        return nf.format(amountMinor.toDouble() / 100.0)
    }
}

fun parseMajorToMinor(text: String, scale: Int = 2): Long {
    val t = text.trim()
    require(t.isNotEmpty())
    val neg = t.startsWith("-")
    val raw = if (neg) t.drop(1) else t
    require(raw.matches(Regex("""\d+(\.\d+)?""")))
    val parts = raw.split('.')
    val whole = parts[0].toLong()
    var pow = 1L
    repeat(scale) { pow *= 10 }
    val frac = if (parts.size == 1) 0L else parts[1].padEnd(scale, '0').take(scale).toLong()
    val minor = whole * pow + frac
    return if (neg) -minor else minor
}
```

### Swift

```swift
struct Money: Equatable {
    let amountMinor: Int64
    let currencyCode: String

    static func + (a: Money, b: Money) -> Money {
        precondition(a.currencyCode == b.currencyCode)
        return Money(amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode)
    }

    func formatted(locale: Locale = .current) -> String {
        let n = NSDecimalNumber(
            mantissa: UInt64(abs(amountMinor)),
            exponent: -2,
            isNegative: amountMinor < 0
        )
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currencyCode
        f.locale = locale
        return f.string(from: n) ?? "\(amountMinor)"
    }
}

func parseMajorToMinor(_ text: String, scale: Int = 2) -> Int64 {
    let t = text.trimmingCharacters(in: .whitespaces)
    let neg = t.hasPrefix("-")
    let raw = neg ? String(t.dropFirst()) : t
    let parts = raw.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
    let whole = Int64(parts[0]) ?? 0
    var pow: Int64 = 1
    for _ in 0..<scale { pow *= 10 }
    let frac: Int64
    if parts.count == 1 { frac = 0 }
    else {
        let padded = parts[1].padding(toLength: scale, withPad: "0", startingAt: 0)
        frac = Int64(padded.prefix(scale)) ?? 0
    }
    let minor = whole * pow + frac
    return neg ? -minor : minor
}
```

### Dart

```dart
class Money {
  final int amountMinor;
  final String currencyCode;
  Money(this.amountMinor, this.currencyCode);

  Money operator +(Money o) {
    if (currencyCode != o.currencyCode) throw ArgumentError('currency mismatch');
    return Money(amountMinor + o.amountMinor, currencyCode);
  }
}

int parseMajorToMinor(String text, {int scale = 2}) {
  var t = text.trim();
  final neg = t.startsWith('-');
  if (neg) t = t.substring(1);
  final parts = t.split('.');
  final whole = int.parse(parts[0]);
  var pow = 1;
  for (var i = 0; i < scale; i++) pow *= 10;
  final frac = parts.length == 1
      ? 0
      : int.parse(parts[1].padRight(scale, '0').substring(0, scale));
  final minor = whole * pow + frac;
  return neg ? -minor : minor;
}
```

### TypeScript

```typescript
export type Money = { amountMinor: number; currencyCode: string };

export function addMoney(a: Money, b: Money): Money {
  if (a.currencyCode !== b.currencyCode) throw new Error("currency mismatch");
  return { amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode };
}

export function parseMajorToMinor(text: string, scale = 2): number {
  const t = text.trim();
  const neg = t.startsWith("-");
  const raw = neg ? t.slice(1) : t;
  const [w, f = ""] = raw.split(".");
  const frac = (f + "0".repeat(scale)).slice(0, scale);
  const minor = Number(w) * 10 ** scale + Number(frac || 0);
  return neg ? -minor : minor;
}

export function formatMoney(m: Money, locale = "en-IN"): string {
  return new Intl.NumberFormat(locale, {
    style: "currency",
    currency: m.currencyCode,
  }).format(m.amountMinor / 100);
}
```

---

## P2: Idempotent client with coalescing + persisted key

### Approach

1. On first user commit, mint UUID → persist with intent `{intentId, amountMinor, currency, idempotencyKey, status}`.
2. `pay()` looks up in-flight map by key; if present, await same promise.
3. Else POST with `Idempotency-Key` header; remove from map in `finally`.
4. Retries and process-death recovery **reload the same key** from disk — never mint again for that intent.

### Complexity

- Coalesce map ops: O(1) average
- Persistence: O(1) per intent (plus storage I/O)

### Edge cases

- Double-tap before map insert completes → use atomic put-if-absent / actor
- Failure of in-flight call → remove key from map so a deliberate retry can run (same idempotency key)
- Do not coalesce different bodies under one key

### Mobile note

Tie to Chapter 23 single-flight. UI disable is insufficient alone.

### Kotlin (sketch)

```kotlin
data class PaymentIntent(
    val intentId: String,
    val amountMinor: Long,
    val currencyCode: String,
    val idempotencyKey: String,
    var status: String = "pending", // pending | succeeded | failed
)

interface IntentStore {
    suspend fun load(intentId: String): PaymentIntent?
    suspend fun save(intent: PaymentIntent)
}

class IdempotentPaymentClient(
    private val store: IntentStore,
    private val post: suspend (headers: Map<String, String>, body: String) -> String,
) {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private val inFlight = mutableMapOf<String, kotlinx.coroutines.CompletableDeferred<String>>()

    /** Call once when user confirms Pay. */
    suspend fun beginIntent(intentId: String, amountMinor: Long, currencyCode: String): PaymentIntent {
        store.load(intentId)?.let { return it }
        val intent = PaymentIntent(
            intentId = intentId,
            amountMinor = amountMinor,
            currencyCode = currencyCode,
            idempotencyKey = java.util.UUID.randomUUID().toString(),
        )
        store.save(intent)
        return intent
    }

    suspend fun createPayment(intentId: String): String {
        val intent = store.load(intentId) ?: error("missing intent")
        val body =
            """{"intentId":"$intentId","amountMinor":${intent.amountMinor},"currency":"${intent.currencyCode}"}"""
        val key = intent.idempotencyKey

        val existing = mutex.withLock { inFlight[key] }
        if (existing != null) return existing.await()

        val mine = kotlinx.coroutines.CompletableDeferred<String>()
        val winner = mutex.withLock { inFlight.putIfAbsent(key, mine) ?: mine }
        if (winner !== mine) return winner.await()

        return try {
            val result = post(mapOf("Idempotency-Key" to key), body)
            intent.status = "succeeded"
            store.save(intent)
            mine.complete(result)
            result
        } catch (t: Throwable) {
            mine.completeExceptionally(t)
            throw t
        } finally {
            mutex.withLock { inFlight.remove(key) }
        }
    }
}
```

### TypeScript

```typescript
export type PaymentIntent = {
  intentId: string;
  amountMinor: number;
  currencyCode: string;
  idempotencyKey: string;
  status: "pending" | "succeeded" | "failed";
};

export interface IntentStore {
  load(intentId: string): Promise<PaymentIntent | null>;
  save(intent: PaymentIntent): Promise<void>;
}

type Poster = (headers: Record<string, string>, body: string) => Promise<string>;

export class IdempotentPaymentClient {
  private inFlight = new Map<string, Promise<string>>();
  constructor(private store: IntentStore, private post: Poster) {}

  async beginIntent(
    intentId: string,
    amountMinor: number,
    currencyCode: string,
  ): Promise<PaymentIntent> {
    const existing = await this.store.load(intentId);
    if (existing) return existing;
    const intent: PaymentIntent = {
      intentId,
      amountMinor,
      currencyCode,
      idempotencyKey: crypto.randomUUID(),
      status: "pending",
    };
    await this.store.save(intent);
    return intent;
  }

  async createPayment(intentId: string): Promise<string> {
    const intent = await this.store.load(intentId);
    if (!intent) throw new Error("missing intent");
    const key = intent.idempotencyKey;
    const hit = this.inFlight.get(key);
    if (hit) return hit;

    const body = JSON.stringify({
      intentId,
      amountMinor: intent.amountMinor,
      currency: intent.currencyCode,
    });
    const p = (async () => {
      try {
        const result = await this.post({ "Idempotency-Key": key }, body);
        intent.status = "succeeded";
        await this.store.save(intent);
        return result;
      } finally {
        this.inFlight.delete(key);
      }
    })();
    this.inFlight.set(key, p);
    return p;
  }
}
```

### Swift / Dart

Same structure: actor/`Map` of in-flight `Task`/`Future`, key loaded from persisted intent. Ports mirror Chapter 26 worked code (b).

---

## P3: Offline intent queue flush without double-charge

### Approach

Persist a FIFO (or ordered by `createdAt`) list of **pending** intents. On connectivity:

1. For each pending intent, call `createPayment` with the **stored** idempotency key (via coalescing client).
2. Success → mark succeeded.
3. Definite client/business error → mark failed (stop retrying that intent).
4. Timeout / 5xx / unknown → leave pending; retry later with same key; optionally GET status by `intentId` if the backend exposes it.

Never: dequeue → mint new UUID → POST.

### Complexity

- Flush n intents: O(n) network calls worst case (coalescing may collapse duplicates)
- Storage: O(n) pending intents — bound the queue

### Edge cases

- App killed mid-flush — intents still pending with same keys; safe to resume
- Two devices, same user — server idempotency is per key; don’t invent cross-device keys without account-level design
- Empty queue / already succeeded

### Mobile note

UI shows **Pending** until reconciled. Optimistic “Paid” is a product bug for real money.

### Kotlin

```kotlin
class OfflinePaymentQueue(
    private val store: IntentStore,
    private val listStore: PendingListStore, // loadAll / saveAll of intentIds
    private val client: IdempotentPaymentClient,
    private val statusGet: suspend (intentId: String) -> String?, // nullable if unsupported
) {
    suspend fun enqueue(intent: PaymentIntent) {
        store.save(intent)
        val ids = listStore.loadAll().toMutableList()
        if (intent.intentId !in ids) {
            ids += intent.intentId
            listStore.saveAll(ids)
        }
    }

    suspend fun flush() {
        val ids = listStore.loadAll()
        for (id in ids) {
            val intent = store.load(id) ?: continue
            if (intent.status != "pending") continue

            statusGet(id)?.let { remote ->
                when (remote) {
                    "succeeded" -> {
                        intent.status = "succeeded"
                        store.save(intent)
                        continue
                    }
                    "failed" -> {
                        intent.status = "failed"
                        store.save(intent)
                        continue
                    }
                }
            }

            try {
                client.createPayment(id)
            } catch (e: PermanentPaymentException) {
                intent.status = "failed"
                store.save(intent)
            } catch (_: TransientPaymentException) {
                // leave pending — same key next flush
            }
        }
    }
}

class PermanentPaymentException(message: String) : Exception(message)
class TransientPaymentException(message: String) : Exception(message)

interface PendingListStore {
    suspend fun loadAll(): List<String>
    suspend fun saveAll(ids: List<String>)
}
```

### TypeScript

```typescript
export class OfflinePaymentQueue {
  constructor(
    private store: IntentStore,
    private listStore: { loadAll(): Promise<string[]>; saveAll(ids: string[]): Promise<void> },
    private client: IdempotentPaymentClient,
    private statusGet: (intentId: string) => Promise<"succeeded" | "failed" | "unknown" | null>,
  ) {}

  async enqueue(intent: PaymentIntent): Promise<void> {
    await this.store.save(intent);
    const ids = await this.listStore.loadAll();
    if (!ids.includes(intent.intentId)) {
      await this.listStore.saveAll([...ids, intent.intentId]);
    }
  }

  async flush(): Promise<void> {
    const ids = await this.listStore.loadAll();
    for (const id of ids) {
      const intent = await this.store.load(id);
      if (!intent || intent.status !== "pending") continue;

      const remote = await this.statusGet(id);
      if (remote === "succeeded" || remote === "failed") {
        intent.status = remote;
        await this.store.save(intent);
        continue;
      }

      try {
        await this.client.createPayment(id);
      } catch (e) {
        if ((e as { permanent?: boolean }).permanent) {
          intent.status = "failed";
          await this.store.save(intent);
        }
        // transient → keep pending
      }
    }
  }
}
```

### Flash answers

| Risk | Mitigation |
|------|------------|
| Double-tap | One key + in-flight map |
| Process death | Persist key with intent |
| Offline flush | Replay same key; optional status GET |
| Float JSON body | Integer `amountMinor` only |

Back: [Chapter 26](../../book/part-viii/26-money-idempotency-reliability.md) · Next drill: [Chapter 27](../../book/part-viii/27-hard-drill-bank.md)
