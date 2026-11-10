# Chapter 26 — Money, Idempotency & Client Reliability

## Mobile motivation

A Pay button is not “another network call.” Retries, process death, and double-taps turn **at-least-once delivery** into **double charges** unless the client and server share a contract: **integer money**, **idempotency keys**, and **single-flight coalescing**. Fintech interviewers hire mobile engineers who can explain that contract before writing a recursive function.

This chapter is interview talk tracks plus working client patterns. No fake payment processor APIs — only the structures and reliability rules you own on device.

Companion solutions: [`solutions/ch26/README.md`](../../solutions/ch26/README.md)

---

## Why floating point is wrong for money

IEEE-754 `Double` / `Float` cannot represent most decimal fractions exactly. Classic failure:

```text
0.1 + 0.2  →  0.30000000000000004   (binary float)
```

Scale that to rupees or dollars across fees, tax, and FX, and you get off-by-one **minor units** (paise / cents) that fail reconciliation.

### Rules that pass interviews

| Do | Don’t |
|----|--------|
| Store amounts as **integer minor units** (`Long` / `Int64`) | Store money in `Double` / `Float` |
| Carry an **ISO 4217 currency code** (`INR`, `USD`, …) with every amount | Assume “numbers are always rupees” |
| Format for display with a locale-aware formatter | Multiply floats then `round()` “at the end” |
| Compare money with integer equality | Compare floats with `==` |

**Minor units:** for INR and USD, multiply major units by 100 → paise / cents. Some currencies use 0 or 3 decimal places; still use an integer scaled by that currency’s exponent, never a float.

**Interview line:** “Money is a value object: `(amountMinor: Long, currency: String)`. Arithmetic stays in integers; formatting is a pure function of those fields.”

---

## Worked code (a) — Money as Long minor units + format

### Kotlin

```kotlin
data class Money(val amountMinor: Long, val currencyCode: String) {
    init { require(currencyCode.length == 3) { "ISO 4217 code required" } }

    operator fun plus(o: Money): Money {
        require(currencyCode == o.currencyCode) { "currency mismatch" }
        return Money(amountMinor + o.amountMinor, currencyCode)
    }

    fun format(locale: java.util.Locale = java.util.Locale.US): String {
        val nf = java.text.NumberFormat.getCurrencyInstance(locale)
        nf.currency = java.util.Currency.getInstance(currencyCode)
        // Divide only for display; never persist the Double.
        return nf.format(amountMinor.toDouble() / 100.0)
    }
}

/** Parse "199.99" → 19999 without floating intermediate for 2-decimal currencies. */
fun parseMajorToMinor(majorText: String, scale: Int = 2): Long {
    val cleaned = majorText.trim()
    val neg = cleaned.startsWith("-")
    val raw = if (neg) cleaned.drop(1) else cleaned
    val parts = raw.split('.')
    val whole = parts[0].toLong()
    val frac = if (parts.size == 1) 0L else parts[1].padEnd(scale, '0').take(scale).toLong()
    var pow = 1L
    repeat(scale) { pow *= 10 }
    val minor = whole * pow + frac
    return if (neg) -minor else minor
}
```

### Swift

```swift
struct Money: Equatable {
    let amountMinor: Int64
    let currencyCode: String // ISO 4217

    init(amountMinor: Int64, currencyCode: String) {
        precondition(currencyCode.count == 3)
        self.amountMinor = amountMinor
        self.currencyCode = currencyCode
    }

    static func + (a: Money, b: Money) -> Money {
        precondition(a.currencyCode == b.currencyCode)
        return Money(amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode)
    }

    func formatted(locale: Locale = .current) -> String {
        let n = NSDecimalNumber(mantissa: UInt64(abs(amountMinor)), exponent: -2, isNegative: amountMinor < 0)
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currencyCode
        f.locale = locale
        return f.string(from: n) ?? "\(amountMinor)"
    }
}
```

`NSDecimalNumber` / `Decimal` is acceptable **for display and decimal parsing**; the **source of truth** for APIs and ledgers remains integer minor units (or a decimal type that never goes through binary float).

### Dart

```dart
class Money {
  final int amountMinor; // fit in 64-bit; use package:fixnum if you need explicit Int64
  final String currencyCode;

  Money(this.amountMinor, this.currencyCode) {
    assert(currencyCode.length == 3);
  }

  Money operator +(Money o) {
    assert(currencyCode == o.currencyCode);
    return Money(amountMinor + o.amountMinor, currencyCode);
  }

  String format({String locale = 'en_US'}) {
    final major = amountMinor / 100;
    // Prefer intl NumberFormat.simpleCurrency in apps:
    // NumberFormat.simpleCurrency(name: currencyCode, locale: locale).format(major);
    return '$currencyCode ${major.toStringAsFixed(2)}';
  }
}
```

### TypeScript

```typescript
export type Money = { amountMinor: number; currencyCode: string }; // use bigint in strict ledgers

export function addMoney(a: Money, b: Money): Money {
  if (a.currencyCode !== b.currencyCode) throw new Error("currency mismatch");
  return { amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode };
}

export function formatMoney(m: Money, locale = "en-IN"): string {
  return new Intl.NumberFormat(locale, {
    style: "currency",
    currency: m.currencyCode,
  }).format(m.amountMinor / 100);
}

/** Parse "199.99" → 19999 minor units; avoids parseFloat drift for 2-decimal currencies. */
export function parseMajorToMinor(text: string, scale = 2): number {
  const t = text.trim();
  const neg = t.startsWith("-");
  const raw = neg ? t.slice(1) : t;
  const [w, f = ""] = raw.split(".");
  const frac = (f + "0".repeat(scale)).slice(0, scale);
  const minor = Number(w) * 10 ** scale + Number(frac || 0);
  return neg ? -minor : minor;
}
```

**JS note:** `number` is still IEEE-754. For amounts that fit in a safe integer (`|x| ≤ 2^53−1`), integer minor units are fine. For very large ledgers, use `bigint`.

---

## Idempotency keys on create / capture / refund

**Idempotency** means: sending the same logical operation twice has the same effect as sending it once.

Payment APIs (create payment, capture, refund) almost always accept a client-generated **idempotency key** — a UUID or stable hash — stored server-side with the request fingerprint. Replay with the same key returns the **original result**, not a second charge.

### Client responsibilities

1. **Generate the key once** when the user commits intent (first tap that means “pay”), not on every retry.
2. **Persist the key** with the local payment intent (disk / encrypted prefs) so process death mid-flight does not mint a new key.
3. **Reuse the key** on retry, offline flush, and app relaunch until terminal success or a deliberate new intent.
4. **Never reuse** a key for a different amount, currency, order id, or operation type.

**Interview line:** “Retries are safe *because* the key is stable; the network is at-least-once, the business effect is exactly-once *at the server* if it enforces the key.”

---

## Auth → capture → settlement (and what the mobile app shows)

Card and wallet flows split **authorization** (hold funds), **capture** (take funds), and **settlement** (money actually moves between banks/merchants — often T+1 or batch). Mobile engineers confuse these in interviews; naming them correctly scores trust points.

| Phase | Meaning | Typical client-visible state |
|-------|---------|------------------------------|
| **Authorize** | Funds held / intent confirmed with rail | `requires_action`, `authorized`, `processing` |
| **Capture** | Merchant/platform collects the held amount | `processing` → `succeeded` (or partial capture in B2B) |
| **Settle** | Inter-bank / merchant payout (batch) | Often invisible; ledger `posted` later |
| **Refund / reversal** | Return funds (full or partial) | `refunded`, `partially_refunded`; balance lags |
| **Dispute / chargeback** | Cardholder contests charge (card rails) | `disputed` → `won` / `lost`; **never** hide from support tools |

### Idempotency per operation type

Use a **different idempotency key namespace** (or key prefix) per operation — never reuse a “create payment” key on “capture” or “refund”:

```text
create:  idem_create_{intent_uuid}
capture: idem_capture_{payment_id}_{amount_minor}
refund:  idem_refund_{payment_id}_{refund_request_uuid}
```

**Mobile rule:** UI states map to **payment status**, not to settlement file arrival. Show **“Payment successful”** when the API says `succeeded`; show **“Refund processing”** until refund status is terminal — do not pretend settlement instant.

### Auth-only vs auth+capture

| Model | When | Client note |
|-------|------|-------------|
| **Auth + capture later** | Hotels, marketplaces, delayed fulfillment | Show authorized amount; capture may differ — poll status |
| **Immediate capture** | Most consumer checkout | Single user journey; still poll after redirect |

### Disputes (chargebacks) — engineer altitude

You do not adjudicate disputes on device. You:

- Surface **disputed** rows in transaction history when the API marks them.
- Never delete a succeeded row locally when a dispute opens.
- Log `payment_id` / `dispute_id` for support; scrub PII in analytics.
- Do not let “optimistic success” block dispute banners from server truth.

**Interview line:** “Settlement and disputes are server-ledgers; the app renders status from GET + webhooks and never invents finality from a redirect or push alone.”

---

## At-least-once vs exactly-once; retries with jitter; safe replay

| Delivery | Meaning | Mobile reality |
|----------|---------|----------------|
| **At-most-once** | Send once; may lose | Risky for pay — user taps again |
| **At-least-once** | Retry until ack; may duplicate | Default for HTTP clients |
| **Exactly-once** | Effect once | Achieved with **idempotent server + stable client key**, not by “hoping TCP is enough” |

### Retry policy (client)

- Retry **transient** failures: timeouts, 408/429/5xx, connection resets.
- Do **not** blindly retry non-idempotent calls without a key.
- Use **exponential backoff + full jitter** to avoid thundering herds:

```text
sleep = random_between(0, min(cap, base * 2^attempt))
```

- Cap attempts; then surface “pending — check status” rather than inventing a new charge.

**Safe replay:** same URL + same body fingerprint + same idempotency key. If the user changes the amount, that is a **new** intent → new key.

---

## Client request coalescing / in-flight map (tie to Ch23)

Chapter 23’s single-flight / coalescer pattern applies directly to Pay:

> Map `idempotencyKey → shared Future/Deferred`. Concurrent callers await the same in-flight request; only one HTTP call leaves the device.

Without coalescing, a double-tap can fire **two** POSTs with the **same** key (usually OK if the server is correct) *or* two POSTs with **different** keys (disaster if you regenerate on each tap). Coalescing + “key minted once per intent” closes both bugs.

---

## Worked code (b) — IdempotentPaymentClient

Abstract transport: you inject `post(path, headers, body)`. No vendor SDK.

### Kotlin

```kotlin
class IdempotentPaymentClient(
    private val post: suspend (path: String, headers: Map<String, String>, body: String) -> String,
) {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private val inFlight = mutableMapOf<String, kotlinx.coroutines.CompletableDeferred<String>>()

    suspend fun createPayment(
        intentId: String,
        amountMinor: Long,
        currencyCode: String,
        idempotencyKey: String,
    ): String {
        val body =
            """{"intentId":"$intentId","amountMinor":$amountMinor,"currency":"$currencyCode"}"""
        val existing = mutex.withLock { inFlight[idempotencyKey] }
        if (existing != null) return existing.await()

        val mine = kotlinx.coroutines.CompletableDeferred<String>()
        val winner = mutex.withLock {
            inFlight.putIfAbsent(idempotencyKey, mine) ?: mine
        }
        if (winner !== mine) return winner.await()

        return try {
            val result = post(
                "/v1/payments",
                mapOf("Idempotency-Key" to idempotencyKey),
                body,
            )
            mine.complete(result)
            result
        } catch (t: Throwable) {
            mine.completeExceptionally(t)
            throw t
        } finally {
            mutex.withLock { inFlight.remove(idempotencyKey) }
        }
    }
}
```

### Swift

```swift
actor IdempotentPaymentClient {
    private var inFlight: [String: Task<String, Error>] = [:]
    private let post: (String, [String: String], String) async throws -> String

    init(post: @escaping (String, [String: String], String) async throws -> String) {
        self.post = post
    }

    func createPayment(
        intentId: String,
        amountMinor: Int64,
        currencyCode: String,
        idempotencyKey: String
    ) async throws -> String {
        if let existing = inFlight[idempotencyKey] {
            return try await existing.value
        }
        let task = Task<String, Error> {
            defer { Task { await self.clear(idempotencyKey) } }
            let body =
                "{\"intentId\":\"\(intentId)\",\"amountMinor\":\(amountMinor),\"currency\":\"\(currencyCode)\"}"
            return try await post("/v1/payments", ["Idempotency-Key": idempotencyKey], body)
        }
        inFlight[idempotencyKey] = task
        return try await task.value
    }

    private func clear(_ key: String) {
        inFlight[key] = nil
    }
}
```

### Dart

```dart
typedef Poster = Future<String> Function(
  String path,
  Map<String, String> headers,
  String body,
);

class IdempotentPaymentClient {
  IdempotentPaymentClient(this.post);
  final Poster post;
  final _inFlight = <String, Future<String>>{};

  Future<String> createPayment({
    required String intentId,
    required int amountMinor,
    required String currencyCode,
    required String idempotencyKey,
  }) {
    return _inFlight.putIfAbsent(idempotencyKey, () async {
      try {
        final body =
            '{"intentId":"$intentId","amountMinor":$amountMinor,"currency":"$currencyCode"}';
        return await post('/v1/payments', {'Idempotency-Key': idempotencyKey}, body);
      } finally {
        _inFlight.remove(idempotencyKey);
      }
    });
  }
}
```

### TypeScript

```typescript
type Poster = (
  path: string,
  headers: Record<string, string>,
  body: string,
) => Promise<string>;

export class IdempotentPaymentClient {
  private inFlight = new Map<string, Promise<string>>();
  constructor(private post: Poster) {}

  createPayment(args: {
    intentId: string;
    amountMinor: number;
    currencyCode: string;
    idempotencyKey: string;
  }): Promise<string> {
    const { intentId, amountMinor, currencyCode, idempotencyKey } = args;
    const existing = this.inFlight.get(idempotencyKey);
    if (existing) return existing;

    const body = JSON.stringify({ intentId, amountMinor, currency: currencyCode });
    const p = this.post("/v1/payments", { "Idempotency-Key": idempotencyKey }, body).finally(
      () => this.inFlight.delete(idempotencyKey),
    );
    this.inFlight.set(idempotencyKey, p);
    return p;
  }
}
```

---

## Offline queue of payment intents vs never double-charging

**Allowed offline:** enqueue a **payment intent** record `{ intentId, amountMinor, currency, idempotencyKey, status: pending }` and flush when online.

**Not allowed:** enqueue “create payment” jobs that each mint a **new** idempotency key on flush.

### Flush algorithm (interview sketch)

1. Load pending intents ordered by `createdAt`.
2. For each: call create/capture with the **stored** key (coalesced).
3. On success → `status = succeeded`, store server payment id.
4. On definite business failure (4xx non-429 with stable body) → `status = failed` (do not retry forever).
5. On unknown / timeout → leave `pending`, retry later with **same** key; optionally poll **status-by-intent** if the API offers it.

**UI:** show **Pending** until the server acknowledges a terminal state. Never show “Paid” from local optimism alone for real money.

---

## Ledger intuition (double-entry talk track)

You will not implement a bank ledger on device, but interviewers expect vocabulary:

- Every movement is an **immutable entry** (append-only). Corrections are **new** reversing entries, not edits.
- **Double-entry:** each transfer is at least two legs — **debit** one account, **credit** another — so the books balance (`Σ debits = Σ credits` in the same currency unit).
- Client “balance” is a **projection**. Source of truth is the ledger / payment service.
- Mobile wallet screens usually show: available, pending, and ledger-settled — three different queries.

**One-liner:** “Immutable journal + balanced legs; the app is a cache of projections with pending overlays.”

---

## Reconciliation: client pending vs server settled

| Client UI | Server truth | Action |
|-----------|--------------|--------|
| Pending + local intent | Payment succeeded | Poll/reconcile → mark succeeded, clear pending |
| Pending | No payment / failed | Keep pending or fail after policy; do not create new key |
| Shows Paid | Refunded / charged back | Refresh from server; never trust stale cache alone |
| Offline succeeded (optimistic) | Never created | Dangerous — avoid for money |

**Pattern:** after every app foreground / connectivity regain, reconcile open `intentId`s against a **GET status** (or webhook-synced local store), not by POSTing create again with a new key.

---

## Common mobile bugs

### 1. Double-tap Pay

Debounce UI **and** mint one key per intent **and** coalesce in-flight. UI disable alone is not enough (accessibility double-activate, overlapping screens).

### 2. Process death mid-request

Request left the device; response never arrived. On cold start, **reload intent + same idempotency key**, retry or status-check. Regenerating UUID ⇒ second charge risk.

### 3. Clock skew

Do not use device clock as the source of truth for settlement time or idempotency TTL. Prefer server timestamps. Token expiry: refresh on 401, don’t invent “local expiry + 5 min” for money ops without server confirmation.

### 4. Related footguns

- Formatting floats into the JSON body (`"amount": 10.2` that becomes `10.199999`).
- Retry interceptor that clones the request but swaps a new UUID header.
- Logging PII + full PANs; never needed for DSA — mention tokenization if asked.

---

## Common mistakes

1. `Double` for balances and fee math.
2. New idempotency key on every retry.
3. Optimistic “Paid” UI without reconciliation.
4. Offline queue that duplicates intents without keys.
5. Coalescing by URL only while body/amount differs.
6. Claiming the client can provide exactly-once without server support.

---

## Self-Check

**26.1** Why is `0.1 + 0.2` a dangerous foundation for money, and what do you store instead?

**26.2** What must stay constant across retries of the same payment intent, and what must change for a new intent?

**26.3** How do at-least-once delivery and idempotency keys combine to approach exactly-once effects?

**26.4** How does an in-flight map (Ch23 single-flight) prevent double-tap duplicate POSTs?

**26.5** After process death with a pending local intent, what are the safe next steps vs the unsafe ones?

**26.6** What is the difference between **authorize**, **capture**, and **settlement** — and which should drive the Pay success screen?

**26.7** Why should capture/refund use a **different** idempotency key than create payment?

*(Answers: [Appendix D](../appendices/D-self-check-answer-key.md).)*

## Practice

1. **Money value object + safe parse/format** — [solutions/ch26](../../solutions/ch26/README.md#p1-money-value-object-safe-parseformat)
2. **Idempotent client with coalescing + persisted key** — [solutions/ch26](../../solutions/ch26/README.md#p2-idempotent-client-with-coalescing-persisted-key)
3. **Offline intent queue flush without double-charge** — [solutions/ch26](../../solutions/ch26/README.md#p3-offline-intent-queue-flush-without-double-charge)

Next: [Chapter 27 — Hard Drill Bank](27-hard-drill-bank.md) — top-company pace after the medium bank in Chapter 24. India UPI rails: [Appendix E](../appendices/E-upi-india-rails.md).
