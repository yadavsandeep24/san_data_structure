# Chapter 28 — Practice Design Outlines

Scored outlines for the practice prompts in [`book/part-viii/28-mobile-fintech-system-design.md`](../../book/part-viii/28-mobile-fintech-system-design.md). Use as a self-grade after a timed 35-minute attempt. These are **rubrics + skeleton answers**, not production specs.

**Scoring (each design, 20 points):**

| Area | Points | You earn full marks when… |
|------|--------|----------------------------|
| Clarify / constraints | 3 | Actors, success definition, money vs display, return path named |
| API & statuses | 5 | Endpoints, idempotency, explicit status enum, auth |
| Client data / UI state | 4 | Local models, pending UX, refresh strategy |
| Failure modes | 5 | Double submit, timeout, late webhook, kill app, spoofed return |
| Scale-back / tradeoffs | 3 | Light QPS or client coalescing; honest “out of scope” |

**15–20** interview-ready · **10–14** gaps on money safety · **&lt;10** redo with Case A checklist.

---

## Practice 1 — UPI collect / intent return

### Prompt (restated)

Design the mobile flow when the user pays via **UPI app switch** (Android intent / iOS handoff pattern). Include API, statuses, return to app, pending UI, double-open of the UPI app, and the case where the bank debit succeeded but your webhook is late.

### Clarify (say first) — 3 pts

- Platforms: Android Intent mandatory; iOS may use UPI apps via URL schemes / PSP SDK — call out difference.
- Success: user sees terminal success only when **your** payment service says `succeeded`.
- User may never return; payment can still succeed.
- Amounts/currency immutable after intent creation.

### API & statuses — 5 pts

```text
POST /v1/payments
  Idempotency-Key: uuid
  body: order_id, amount, method=upi, return_url=app_link, vpa? 

→ payment_id, status=requires_action,
  client_action: { type: "upi_intent", intent_uri / psp payload }

GET /v1/payments/{payment_id}  → status, failure_code, rail_ref?
```

Suggested statuses: `created` → `requires_action` → `processing` → `succeeded` | `failed` | `expired`.

Idempotency: same key returns same `payment_id` + same intent payload.

### Client data / UI — 4 pts

- Disable Pay; store `payment_id` durably before leaving the app.
- Screen: **Processing payment** with amount + “Return from your UPI app” + Refresh.
- On resume / deep link: always `GET` status (link is a hint).
- Poll with backoff while `processing` / `requires_action`; stop on terminal; optional push.

### Failure modes — 5 pts

| Failure | Handling |
|---------|----------|
| Double tap Pay | Button guard + idempotency key |
| User opens UPI twice | Same `payment_id`; second intent open is OK if PSP allows; do not create second payment |
| App killed during UPI | On cold start, restore in-flight payment from local store / orders API |
| Return URL spoof / custom scheme | Prefer App Links; never trust query `status=success` |
| Debit ok, webhook late | UI stays **pending/processing**; Refresh; support uses `payment_id`; eventually consistent success |
| User cancels in UPI | `failed`/`cancelled` from GET; enable Retry with **new** key only after terminal failure |
| POST timeout | Do not new-key retry; recover via GET by order/idempotency |

### Scale-back — 3 pts

- Sale spike: coalesce polls per `payment_id`; cap poll rate; rely on push when possible.
- Mention PSP/bank latency dominates; client should not hammer GET.
- Out of scope unless asked: PSP webhook worker internals, settlement files.

### Outline rubric checklist

- [ ] Intent leave/return called out  
- [ ] Idempotency on create  
- [ ] Pending until server terminal  
- [ ] Late webhook scenario explicit  
- [ ] No PAN/UPI secrets in logs  

---

## Practice 2 — In-app “request money” + settle later

### Prompt (restated)

Requester creates a money request; payer may pay days later. Both apps show a timeline. Cover notifications, feed dedupe, and balance freshness on both sides.

### Clarify — 3 pts

- Actors: requester, payer, (optional) intermediaries.
- States of a **request** vs a **payment** (two objects).
- Not offline-critical unless asked; notifications may be delayed.
- Currency, expiry of request, partial pay? Default: full amount, single settle, expiry.

### API & statuses — 5 pts

```text
POST /v1/requests  → request_id, status=open, amount, payee, expiry
GET  /v1/requests/{id}
POST /v1/requests/{id}/pay  + Idempotency-Key → payment_id, status=...
GET  /v1/transactions?cursor=   (fan-in feed)
```

Request statuses: `open` → `paid` | `expired` | `cancelled`.  
Payment statuses: reuse Case A (`processing` → `succeeded`…).  
Notify both parties on transition; payload includes `request_id` + `txn_id` when paid.

### Client data / UI — 4 pts

- Timeline row keyed by `request_id`; when paid, attach `txn_id` and upsert.
- Requester home: open requests; balance SWR — **do not** credit until payment `succeeded`.
- Payer: request detail → Pay → pending → settled; balance debit after success (or pending hold if product has holds — name the assumption).
- Pull-to-refresh + push hint → single-flight fetch.

### Failure modes — 5 pts

| Failure | Handling |
|---------|----------|
| Double pay on same request | Server rejects second pay; idempotency on pay endpoint; UI disables |
| Push “paid” before feed has txn | Banner + fetch by ids; dedupe `txn_id` |
| Stale balance on requester | SWR + `updated_at`; copy “Arrives when payment settles” |
| Cancel race (cancel vs pay) | Server authority; loser gets 409; refresh both UIs |
| Expired request | Pay disabled; clear messaging |
| Notification duplicates | Collapse key = `request_id` or `txn_id` |

### Scale-back — 3 pts

- Fan-in: map by id + cursor pagination (Chapter Case D).
- Light QPS: request create is low; pay spikes follow campaigns — same coalesce rules as checkout.
- Out of scope: ledger sharding, AML case tooling (mention escalate).

### Outline rubric checklist

- [ ] Split request vs payment objects  
- [ ] Both parties’ UX states  
- [ ] Dedupe strategy named  
- [ ] Balance freshness honesty  
- [ ] Race: cancel vs pay  

---

## Self-Check answer key

**28.1** Redirect URLs are forgeable / incomplete; PSP and webhooks may still be in flight. Server status is source of truth.

**28.2** Disabling the button is a UX race guard for one process. Idempotency-Key protects across retries, process death, and duplicate POSTs.

**28.3** LWW OK for non-authoritative fields (memo). Not OK for amount/currency/settlement — use server authority / versioning.

**28.4** Upsert by stable `txn_id`; keep newer `updated_at`; collapse notifications by the same id.

**28.5** Benefit: harder MITM with rogue CAs. Risk: pin rotation / backup-pin failure can brick connectivity until app update.

**28.6** Biometrics prove **local device user** unlocked the Pay action — not that the card network charged successfully. **3DS/SCA** proves issuer/challenge for the card rail — not session login. Neither replaces **GET payment status** or idempotency on writes.

---

Back: [Chapter 28](../../book/part-viii/28-mobile-fintech-system-design.md)
