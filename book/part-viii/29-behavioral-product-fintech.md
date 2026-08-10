# Chapter 29 — Behavioral & Product Sense (Fintech)

Coding and design get you into the room. Fintech loops also test whether you **handle trust**, **own incidents**, and **think about money harm** like a product engineer — not like a lawyer or a compliance officer.

This chapter is practical: STAR stories mapped to themes interviewers actually probe, a product framework that stays in engineering scope, risk vocabulary at the right altitude, and drills with strong vs weak sketches.

Critique rubrics and exemplars: [`solutions/ch29/README.md`](../../solutions/ch29/README.md)

---

## What fintech behavioral rounds are really scoring

| Theme | Signal they want | Anti-signal |
|-------|------------------|-------------|
| **Trust** | You treat user money/data as sacred; you escalate early | “It was just a UI bug” |
| **Incident response** | Calm timeline, mitigation, customer impact, follow-up | Blame-only stories; heroics without process |
| **Ownership** | You drove to done across teams | “I pinged them and waited” |
| **Disagreement** | Principle + data + disagree-and-commit | Stubbornness or silent resentment |
| **Product judgment** | User harm → money movement → failure → metrics → rollout | Feature brainstorming with no risk |

Prepare **4–6 reusable stories**. Map each to two themes so you can remix under pressure.

---

## STAR that survives a fintech panel

**Situation** — One sentence of context (product, scale, constraint).  
**Task** — Your responsibility, not the team’s vibe.  
**Action** — 3–5 concrete moves *you* made (debug, decide, communicate, ship).  
**Result** — Measurable or clearly observable outcome + what you changed next time.

**Fintech upgrades to plain STAR:**

- Name **user money or trust impact** early (“balances wrong for ~2k users”).
- Separate **mitigation** (stop the bleeding) from **fix** (root cause) from **prevention** (guardrail).
- Admit **uncertainty** you had in the moment; show how you reduced it.
- End with a **control** you added (test, flag, audit log, runbook) — interviewers love durable ownership.

### Story bank map (fill with your real work)

| Theme | Prompt you should be ready for | Story spine |
|-------|--------------------------------|-------------|
| Trust | “Tell me about a time user data or money was at risk.” | Discover → contain → notify → fix → prevent |
| Incident | “Walk me through a production incident.” | Detect → severity → mitigate → communicate → postmortem |
| Ownership | “Something ambiguous that wasn’t your job.” | Spot gap → volunteer scope → align → deliver |
| Disagreement | “Disagreed with PM/eng on a payment UX.” | Principle → alternative → experiment/flag → commit |

Do not invent regulated outcomes you did not cause. Stretch framing, not facts.

---

## Product sense prompts (mobile fintech)

Use the same skeleton every time:

1. **User harm** — Who gets hurt, how badly, how fast?
2. **Money movement** — Is money in flight, settled, or only displayed?
3. **Failure modes** — Double submit, stale read, webhook lag, offline, kill app.
4. **Metrics** — What proves it works / fails (success rate, pending duration, dispute rate, crash-free)?
5. **Rollout** — Flag, %, kill switch, support playbook, auditability.

### Prompt: “What if Pay is tapped twice?”

**Strong direction:** Client disable + in-flight guard; server Idempotency-Key; same `payment_id` on replay; UI stays on pending until terminal; never create a second charge from a retry with a new key. Metric: duplicate charge rate ≈ 0; monitor 409/replay hits.

**Weak direction:** “We debounce the button for 500ms” (useful but incomplete; process death and retries ignored).

### Prompt: “Balance wrong after refund?”

**Strong direction:** Distinguish available vs pending; SWR with `updated_at`; after refund success navigate with “Refund started — balance updates when settled”; pull-to-refresh; push coalesce; if persistent mismatch, support path with `txn_id` + last sync watermark. Do not invent a client-side balance correction.

**Weak direction:** “Optimistic UI add the money back immediately” with no reconciliation.

### Prompt: “Show pending vs settled?”

**Strong direction:** Explicit status model in UI (Pending / Processing / Posted); copy that sets expectation; pending rows immutable in amount; settled can show final rail reference; filter chips; accessibility labels. Compliance-friendly: no fake “success” confetti on pending.

**Weak direction:** One green checkmark for both states.

### Prompt: “Feature flag a risky payment method?”

**Strong direction:** Flag server-driven (not only local); targeting by app version, geography, KYC tier; kill switch; gradual %; metrics dashboard (auth rate, failure codes, latency); support macros; dark launch config fetch before showing the method on Pay sheet. Rollback = hide method, do not strand open payments — define status handling.

**Weak direction:** “Ship behind a boolean in the app binary.”

---

## Risk & compliance vocabulary (engineer altitude)

You need **fluency**, not a law degree. Definitions you can say in one breath:

| Term | Engineer-useful meaning |
|------|-------------------------|
| **KYC** | Know Your Customer — identity verification before higher limits or certain products |
| **AML** | Anti–Money Laundering — monitoring/patterns; you implement signals & holds, specialists decide cases |
| **PII** | Personally identifiable info — collect least needed; scrub logs; careful analytics |
| **PCI** | Card data rules — keep PAN out of your app/logs; use PSP SDKs / hosted fields |
| **Audit log** | Append-only record of who did what to sensitive actions (login, pay, payout) |
| **Least privilege** | Tokens/roles grant minimum access; mobile app is not an admin |
| **Data retention** | Don’t keep sensitive fields forever “for debugging” |

### How to answer without pretending to be a lawyer

- Use **“our compliance / risk partners decide policy; my job is…”** then name engineering controls (encryption at rest for tokens, no PAN, flags, audit events, access-scoped APIs).
- Prefer **principles**: minimize data, make actions attributable, fail closed on uncertainty for money movement.
- If asked “is this legal?”: “I wouldn’t assert legality in an interview; I’d escalate to compliance and describe how I’d implement their requirement safely.”
- Never bluff statutes or fine amounts.

**Good sentence:** “I’d avoid storing full account numbers on device, tokenize via the bank/PSP, log only last-4 and request ids, and ensure support tools are permissioned and audited.”

**Bad sentence:** “Under RBI circular X section Y we must…”

---

## Framework card (memorize)

```text
User harm
  → Money movement (display vs commit)
    → Failure modes (double, stale, offline, redirect loss)
      → Metrics + alerts
        → Rollout (flag, %, kill switch, support)
```

If stuck, ask one clarifying question: “Is money leaving the user’s account in this step, or are we only showing status?”

---

## Ten drills — strong vs weak sketches

Not full essays. Practice saying the strong sketch aloud in 60–90 seconds.

### 1. App crash after Pay, before receipt

- **Weak:** “Show an error toast.”
- **Strong:** Payment may exist server-side. On relaunch, resume by `order_id` / last `payment_id`; GET status; pending UI; never re-POST with new idempotency key. Metric: orphaned successful payments without receipt screen.

### 2. User screenshots balance and posts online

- **Weak:** “Not our problem.”
- **Strong:** Product/threat model: optional hide-on-recents, `FLAG_SECURE` on sensitive screens where policy requires, education in privacy settings. Tradeoff with legitimate receipt sharing — align with product.

### 3. Push says paid, feed missing txn

- **Weak:** “Trust the push and insert a fake row.”
- **Strong:** Upsert by `txn_id` after fetch; if push-only, show transient banner “Updating activity…”; dedupe; cursor refresh from head.

### 4. PM wants card PAN cached for faster checkout

- **Weak:** “Sure, encrypt in SharedPreferences.”
- **Strong:** Expand PCI scope / risk. Propose PSP tokenization + network tokens; refuse PAN at rest on device; offer UX alternatives (one-tap via PSP SDK).

### 5. Disagreement: designer wants success animation on redirect return

- **Weak:** “Design is wrong, I blocked it.”
- **Strong:** Explain webhook lag → false success harm; propose success only on terminal `succeeded`; use “Processing” animation; disagree-and-commit if flag experiment shows confusion metrics.

### 6. Offline expense edited on two devices

- **Weak:** “LWW everything.”
- **Strong:** Server authority on amount; conflict UI or field-level merge; idempotent mutations; show sync state.

### 7. Rate limit / 429 during sale on Pay

- **Weak:** “Retry in a tight loop.”
- **Strong:** Backoff + jitter; preserve idempotency key; queue user message; avoid stampedes; coordinate with backend capacity notes.

### 8. Support asks for verbose payment logs including card fields

- **Weak:** “Add more logs.”
- **Strong:** Structured logs with `payment_id`, status transitions, PSP refs; scrub PII/PAN; provide support tooling with audit; time-bounded access.

### 9. New crypto payout feature in app

- **Weak:** “Same as bank transfer UI.”
- **Strong:** Harm (irreversibility, address errors); confirm UX; feature flag; limits; clear pending; compliance review gate; metrics on reverse/fail.

### 10. You broke analytics and miss conversion tracking for a day

- **Weak:** “Analytics isn’t money.”
- **Strong:** Still trust/ops impact; fix pipeline; note decisions made without data; add contract tests; separate critical money logs from marketing analytics.

---

## Building your three STAR stories (homework shape)

Write each in ≤200 words:

1. **Trust / data / money risk** — include containment.
2. **Incident** — include severity and customer communication.
3. **Disagreement or ownership** — include principle and commit.

Then write **two product answers** (≤150 words each) using the harm → money → failures → metrics → rollout framework — pick from Pay double-tap, wrong balance after refund, or flagging a risky method.

Self-critique with [`solutions/ch29/README.md`](../../solutions/ch29/README.md).

---

## Self-Check

Answers: [Appendix D](../appendices/D-self-check-answer-key.md) (also in [`solutions/ch29`](../../solutions/ch29/README.md#self-check-answer-key)).

**29.1** In a STAR incident story, what three phases should you separate after detection?

**29.2** Why is “debounce the Pay button” insufficient alone as an answer to double-charge risk?

**29.3** Give one engineering control for PII minimization on a mobile payment client.

**29.4** What is the difference between treating a push notification as a hint vs as source of truth?

**29.5** How do you answer a legality question without bluffing?

---

## Practice

1. Write **3 STAR stories** (trust, incident, disagreement/ownership) using the map above.
2. Write **2 product answers** with the five-step framework.

Rubrics + one exemplar STAR + one exemplar product answer:

→ **[`solutions/ch29/README.md`](../../solutions/ch29/README.md)**

Record yourself once. If you cannot name a metric or a kill switch, the answer is not ready.

---

## What to remember

Fintech behavioral rounds reward **precise ownership of money and trust**, not theatrical heroics. Product sense is a disciplined walk from user harm to rollout. Use compliance words as **interfaces to specialist partners**, and keep your answers inside engineering controls you could actually ship. Together with Chapter 28’s design patterns, you can move from “how the Pay button works” to “how I behave when it fails.” **Execution checklist (mocks, timed reps, STARs):** [Appendix F](../appendices/F-execution-and-optional-polish.md).
