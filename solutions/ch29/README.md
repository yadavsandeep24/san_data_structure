# Chapter 29 — Behavioral & Product Critique Rubrics

Rubrics and exemplars for practice in [`book/part-viii/29-behavioral-product-fintech.md`](../../book/part-viii/29-behavioral-product-fintech.md). Grade your drafts harshly; fintech panels will.

---

## Rubric A — STAR stories (each story, 10 points)

| Criterion | Pts | Full marks |
|-----------|-----|------------|
| Clear Situation + your Task | 2 | One breath of context; *your* job stated |
| Actions are concrete and yours | 3 | Verbs: shipped, mitigated, measured, decided — not “we somehow” |
| Money / trust impact named | 2 | Users, funds, data exposure, or abuse vector |
| Result + prevention | 2 | Outcome + durable control (test, flag, audit, runbook) |
| Honest scope | 1 | No legal bluff; no invented heroics |

**8–10** reusable in onsite · **5–7** tighten Actions/Result · **&lt;5** rebuild from a real incident.

### Mapping check

Your three stories should cover **trust**, **incident**, and **disagreement or ownership** without triple-counting the same anecdote unless you clearly reframe the lens.

---

## Rubric B — Product answers (each, 10 points)

| Criterion | Pts | Full marks |
|-----------|-----|------------|
| User harm | 2 | Who hurt, how severe |
| Money movement | 2 | Display vs commit; pending vs settled |
| Failure modes | 2 | ≥2 realistic failures with handling |
| Metrics | 2 | At least one leading indicator + one safety metric |
| Rollout | 2 | Flag / % / kill switch / support note |

**Missing server authority or idempotency on a Pay question → cap at 6.**

---

## Exemplar STAR (trust / money risk)

Use as a **shape**, not a script to memorize verbatim. Replace with your facts.

> **Situation:** On our wallet app, a release made the home balance call race with an older cached ledger endpoint after refunds.  
> **Task:** I owned the Android wallet home; support flagged ~1.5k tickets of “refund succeeded but balance low.”  
> **Action:** I treated it as sev-2 money display. We shipped a kill switch that forced network refresh and hid the optimistic cache path. I added single-flight + `updated_at` monotonic commits so stale responses could not overwrite newer balances. I paired with backend to confirm refunds were settled in ledger (they were) — so we did not re-credit client-side. I wrote a short support macro with `txn_id` + last sync time.  
> **Result:** Ticket volume dropped within a day of the flag; we kept the monotonic watermark in the permanent client. Postmortem added a screenshot test for “refund settled → balance refresh” and a metric on `balance_cache_rollback_count`.

**Why it scores:** impact sized, mitigation ≠ fake money, prevention named, no statute cosplay.

---

## Exemplar product answer (Pay tapped twice)

> **Harm:** Double charge destroys trust faster than almost any UI polish.  
> **Money movement:** `POST /payments` can commit a hold/charge — this is not a display-only tap.  
> **Failures:** (1) Double tap → disable button + ignore re-entry while in-flight. (2) Retry after timeout → same Idempotency-Key; never mint a new key unless user explicitly retries after *terminal* failure. (3) Process death mid-flight → persist `payment_id` / key; resume with GET. (4) 3DS return → re-fetch status; do not trust URL flags.  
> **Metrics:** duplicate `payment_id` per order ≈ 0; rate of idempotent replays; payment success rate; time-in-`processing`. Alert on multi-success per `order_id`.  
> **Rollout:** Ship client guards + verify server idempotency in staging with chaos double-POST; feature-flag any new PSP path; kill switch to force “check status” CTA if create error spikes; support playbook keyed by `order_id`.

**Why it scores:** full framework, server+client, metrics, rollout.

---

## Weak patterns to edit out

- “I’d check with legal” as the *entire* answer (escalate, then list controls).
- Success animation before terminal status.
- Optimistic balance without reconciliation.
- Debounce-only double-charge defense.
- LWW on amounts.
- Blaming QA / PM with no ownership move.

---

## Self-Check answer key

**29.1** Mitigation (stop bleeding), fix/root cause, prevention (guardrail / process).

**29.2** Debounce is same-process UX only; duplicates still happen via retries, timeouts, and process death — need idempotency and status resume.

**29.3** Examples: no PAN/CVV storage; scrub PII from logs; short-lived tokens; mask account numbers; minimize analytics properties.

**29.4** Hint → trigger fetch/upsert. Source of truth → authoritative money/state (should be server). Pushes can drop, delay, or duplicate.

**29.5** Decline to assert law; say you’d implement compliance/risk guidance with engineering controls (minimize data, audit, least privilege, PSP tokenization) and escalate policy questions.

---

## Practice submission checklist

- [ ] 3 STARs, each ≤200 words, each scored with Rubric A  
- [ ] 2 product answers using harm → money → failures → metrics → rollout  
- [ ] Each product answer names at least one kill switch or flag  
- [ ] Zero PAN-at-rest proposals  
- [ ] Recorded once aloud under 90 seconds per product answer  

---

Back: [Chapter 29](../../book/part-viii/29-behavioral-product-fintech.md)
