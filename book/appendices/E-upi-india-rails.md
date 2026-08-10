# Appendix E — UPI & India Payment Rails (Mobile Engineer)

Quick reference for **Indian fintech mobile interviews** — vocabulary, client flows, and failure modes. This is not legal or NPCI compliance documentation; it is engineering fluency at the altitude mobile hires are expected to show.

Related chapters: [26 — Money & Idempotency](../part-viii/26-money-idempotency-reliability.md), [28 — System Design](../part-viii/28-mobile-fintech-system-design.md), [practice outline](../../solutions/ch28/README.md#practice-1--upi-collect--intent-return).

---

## Rails at a glance

| Rail | User experience | Mobile pattern | Latency / finality |
|------|-----------------|----------------|--------------------|
| **UPI (P2P/P2M)** | Pay via UPI app or in-app PSP | Intent / collect / SDK | Often seconds; **pending** until PSP/NPCI confirms |
| **UPI Intent** | Your app opens PhonePe/GPay/etc. | Android `Intent` URI; iOS URL / PSP SDK | User may not return; debit can still succeed |
| **UPI Collect** | Request sent to user’s VPA; approve in any UPI app | Server-initiated; client polls | Async approval |
| **IMPS / NEFT / RTGS** | Bank transfer (often B2B / payouts) | Usually not in consumer Pay sheet | Batch / bank hours — **not** instant UX |
| **Cards (domestic)** | 3DS + RuPay/Visa/MC | WebView / SDK redirect | Auth → capture; disputes possible |

**Interview line:** “UPI is push/pull over NPCI infrastructure; the **TPAP** (third-party app) or **merchant PSP** handles the rail — my app talks to **our** payment service, not NPCI directly.”

---

## UPI vocabulary (say correctly)

| Term | Meaning for mobile |
|------|-------------------|
| **VPA** | Virtual Payment Address (`user@bank`) — display + validate format; never invent |
| **UPI ID / handle** | Colloquial for VPA |
| **Intent flow** | App launches payer’s UPI app with pre-filled amount/payee |
| **Collect request** | Payee asks payer to approve a pull |
| **TPAP** | Third Party Application Provider (PhonePe, GPay, Paytm, …) |
| **PSP / merchant acquirer** | Your backend’s payment partner — source of truth for status |
| **Mandate** | Recurring / autopay authorization — separate state machine |
| **UTR / RRN** | Bank reference — show in receipt when API provides; support lookup |

---

## Client flow — UPI Intent (Android-heavy)

```text
User taps Pay (amount locked, idempotency key minted)
  → POST /payments → status=requires_action, client_action=upi_intent
  → App starts Intent with PSP-provided URI
  → User completes / cancels in UPI app
  → Return: deep link / intent callback with payment_id (NOT success=true)
  → GET /payments/{id} until terminal
```

### Android

- Use explicit intent resolution; handle **no UPI app installed** (Play Store / chooser).
- **Do not** assume `onActivityResult` always fires — user can kill either app.
- Persist `payment_id` + idempotency key before starting intent.

### iOS

- Often PSP SDK or universal link handoff — same rules: **server status** after return.
- Do not hard-code one TPAP; PSP abstracts package names.

---

## Status model (align with Chapter 28)

| Status | UI copy (example) | Client action |
|--------|-------------------|---------------|
| `requires_action` | “Complete payment in your UPI app” | Launch intent; disable duplicate Pay |
| `processing` | “Payment processing” | Poll with backoff; offer refresh |
| `succeeded` | “Paid” | Receipt; refresh wallet feed |
| `failed` | “Payment failed” | Retry = **new** idempotency key only if new attempt |
| `expired` | “Payment timed out” | Check bank SMS / history; reconcile before retry |

**Late webhook case:** User’s bank debited, your API still `processing` → show honest processing + support path with `payment_id`; never second POST with new key until server confirms non-existence.

---

## Double-open and duplicate intent

| Bug | Mitigation |
|-----|------------|
| User taps Pay twice | UI disable + in-flight coalescing (Ch 26) + server idempotency |
| User opens two UPI apps | Same `payment_id`; second intent should no-op or show “already in progress” |
| Return deep link opened twice | Idempotent navigation to same receipt screen |
| Collect + Intent confusion | One active payment per `order_id` on server |

---

## IMPS / NEFT / RTGS (when interview mentions “bank transfer”)

- **IMPS:** 24×7, often used for instant bank payouts — still **not** the same UX as in-app UPI intent.
- **NEFT:** 24×7 since Dec 2019 in India — settlement is not UPI-instant; show **expected by** / **processing**, not “money arrived now.”
- **RTGS:** 24×7 since Dec 2020 for high-value transfers — consumer apps rarely expose directly; still server-authoritative status on the client.

Mobile app: show **transfer initiated** vs **credited**; poll payout status API; do not mark wallet credited until server says so.

---

## Compliance altitude (engineer, not lawyer)

- Do not store full account numbers on device; use masked display from server.
- UPI PIN entry happens **inside the TPAP / bank app**, not your WebView — say this in interviews.
- Log `payment_id`, status transitions, PSP refs — not VPA + amount in cleartext analytics if policy forbids.
- Feature flags for new rails (UPI Lite, credit line on UPI) — server-driven kill switch.

---

## Self-Check

**E.1** Why is the UPI app switch not proof of payment success?

**E.2** Intent vs Collect — who initiates the pull?

**E.3** What should the client do if the user’s bank debited but GET status is still `processing`?

**E.4** Why is IMPS not interchangeable with UPI intent in UX copy?

*(Answers: [Appendix D](D-self-check-answer-key.md).)*

---

Back: [Appendix D](D-self-check-answer-key.md) · [Chapter 28](../part-viii/28-mobile-fintech-system-design.md) · [Book map](../../README.md)
