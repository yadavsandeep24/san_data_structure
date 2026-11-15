# Appendix F — Execution Checklist & Optional Polish

The **curriculum content is complete**: Parts I–IX (42 chapters), Appendices A–G, per-chapter solutions, and a snippet-verification harness in `code/`. This appendix separates what the **book cannot do for you** from **optional future additions** to the repo.

Use this as an honest readiness gate before applying to top fintech mobile loops.

---

## Part 1 — Not done (you must execute)

Reading cover-to-cover does not pass interviews. These items require **your** timed practice, stories, and mocks.

### Coding under time pressure

| Task | Target | Where in book |
|------|--------|---------------|
| Medium timed drills | **≥ 20** at 25–35 min each | [Ch 29](../part-viii/29-interview-questions.md) |
| Hard timed drills | **≥ 15** at 45–55 min each | [Ch 30](../part-viii/30-hard-drill-bank.md) |
| Re-solve misses | After **48 hours**, no notes | Ch 29 + Ch 30 miss log |
| Extra hard reps (external) | **+40–60** beyond Ch 30 | LeetCode / similar — tags: DP, graphs, intervals, design |

**Pass bar:** One hard problem in 45 min with complexity stated first, clean code, edge cases handled.

### Mini projects (portfolio / depth)

| Task | Target | Where |
|------|--------|--------|
| Build + document | **≥ 2** projects | [Ch 38](../part-viii/38-mini-projects.md) + [`solutions/ch38`](../../solutions/ch38/README.md) |
| Stretch | Second language port or coalescer stress test | Ch 38 grading rubric |

### Fintech domain (talk + code)

| Task | Target | Where |
|------|--------|--------|
| Integer money + idempotency | Explain in **90s** without notes | [Ch 39](../part-ix/39-money-idempotency-reliability.md) |
| Ch 39 practices | **3/3** attempted closed-book first | [`solutions/ch39`](../../solutions/ch39/README.md) |
| Auth vs capture vs settlement | One-sentence distinction each | Ch 39 + [Appendix D](D-self-check-answer-key.md) |
| UPI intent flow (India) | Whiteboard return + late webhook | [Appendix E](E-upi-india-rails.md) |

### System design (mobile fintech)

| Task | Target | Where |
|------|--------|--------|
| Timed design outlines | **≥ 2** at 35 min (checkout + UPI or request-money) | [Ch 40](../part-ix/40-mobile-fintech-system-design.md) + [`solutions/ch40`](../../solutions/ch40/README.md) |
| Score yourself | **≥ 15/20** on rubric | `solutions/ch40` |

### Behavioral & product

| Task | Target | Where |
|------|--------|--------|
| STAR stories written | **3** (trust, incident, disagreement) | [Ch 41](../part-ix/41-behavioral-product-fintech.md) |
| Product answers | **2** (double Pay, wrong balance, or flags) | Ch 41 framework |
| Recorded aloud | **≤ 90s** each; name metric + kill switch | [`solutions/ch41`](../../solutions/ch41/README.md) rubric |

### Full mock loops

| Task | Target |
|------|--------|
| Half-day mock | 2 coding + 1 design + 1 behavioral |
| Peer or coach feedback | At least **2** mocks before onsite |
| Weak-area loop | Extra mock on your worst bucket (hard DP, design, STAR) |

### External reading (not in this repo)

| Topic | Why |
|-------|-----|
| **PSP / SDK docs** (Stripe, Adyen, Razorpay, etc.) | Tokenization, 3DS, mobile SDK return paths — book stays vendor-neutral |
| **Backend / distributed systems** (if loop includes it) | DDIA-style depth for staff or full-stack loops — Ch 40 is **mobile-scoped** |
| **Company-specific values / principles** | Stripe “users first,” etc. — research per employer |

---

## Part 2 — Optional polish (not in repo yet)

Low-priority **future curriculum** items. The book is interview-ready without these; add them if you maintain a fork or a second edition.

### Curriculum gaps (content)

| Item | Value | Effort |
|------|-------|--------|
| **PSP SDK integration chapter** (Stripe Mobile, Razorpay, Adyen) | High for on-the-job; medium for interviews | Large — vendor churn |
| **Full 4-language ports for all Ch 30 problems** | Medium — Kotlin/TS already in chapter | Medium |
| **Dedicated accessibility chapter** (TalkBack/VoiceOver on money UI) | Medium for inclusive product teams | Small |
| **Fraud / velocity limits** (client signals, rate limit UX) | Medium at some fintechs | Small |
| **Multi-currency wallet + FX rounding** | Medium for cross-border apps | Medium |
| **Staff / L6 track** (RFCs, migrations, org influence) | High for staff loops only | Large |
| **Mock interview scripts** (full 4h day with rubrics) | High for self-study | Medium |
| **Video walkthroughs** | Medium | Out of scope for markdown repo |

### Tooling gaps

| Item | Notes |
|------|--------|
| **Snippet tests for every chapter** | `code/verify_snippets.py` runs the Core Patterns chapters (13–17) and Ch 21's binary-search-on-answer in Kotlin, Dart and TypeScript. Extending it to the older chapters is open work. Swift isn't run automatically. |
| **Automated timed drill timer / tracker** | Spreadsheet or Notion is enough for now |
| **CI for markdown link check** | Nice for contributors |

### Role mismatches (wrong book — use something else)

| Target | This book | Use instead |
|--------|-----------|-------------|
| Backend fintech engineer | Partial (money concepts only) | Classic DSA + DDIA + SQL |
| SRE / platform | Minimal | SRE prep, K8s, observability |
| Quant / ML | None | Separate track |

---

## Readiness checklist (copy into your tracker)

### Core mobile DSA

- [ ] Self-Checks 1.x–28.x complete ([Appendix D](D-self-check-answer-key.md))
- [ ] Core Patterns (Ch 13–17): can name the pattern for any Ch 31–33 drill within 2 minutes
- [ ] ≥ 20× Ch 29 timed
- [ ] ≥ 2× Ch 38 projects shipped
- [ ] Can explain LRU, Trie, BFS, coalescing aloud

### Top fintech mobile

- [ ] Self-Checks 39.x–41.x + E.x complete
- [ ] ≥ 15× Ch 30 timed
- [ ] Ch 39 practices + idempotency/money talk track
- [ ] ≥ 2× Ch 40 designs scored ≥ 15/20
- [ ] 3 STAR + 2 product answers recorded
- [ ] ≥ 2 full mock loops completed
- [ ] *(Optional)* +40 external hard problems

### “Apply when”

You are **onsite-ready for mobile IC fintech** when the fintech section above is checked **and** you can pass a cold hard problem from Ch 30 without looking at solutions.

---

## How this relates to Appendix A

- **Weeks 1–12:** Parts I–VII plus the Part VIII practice banks and mini projects ([Appendix A](A-12-week-roadmap.md))
- **Weeks 13–16:** Fintech track (Ch 39–41, Appendix E, Ch 30 hard drills); Ch 42 for document/e-signature loops
- **This appendix:** Everything **after** the book — execution and optional future content

---

Back: [Appendix E](E-upi-india-rails.md) · [Appendix A](A-12-week-roadmap.md) · [Book map](../../README.md)
