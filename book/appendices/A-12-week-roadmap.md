# Appendix A — Your 12-Week Preparation Roadmap

A focused plan for mobile engineers preparing for product-company interviews and stronger day-to-day architecture instincts. Assume **5–8 focused hours per week**. Adjust intensity, not order: later weeks assume earlier foundations.

Each week lists **chapter reading**, a **problem budget**, and a **mobile deliverable** (a tiny artifact you can discuss in interviews).

| Week | Focus | Chapters | Problem budget | Mobile deliverable |
|------|--------|----------|----------------|--------------------|
| 1 | Mindset + Big-O | 1–2 | 6 warm-ups (membership, budget math) | One-pager: “UI-thread vs bg” for a feed screen |
| 2 | Arrays | 3 | 8 (dedupe, rotate, two-pointer) | Profile prepend-vs-append on a 10k list |
| 3 | Linked lists + stacks | 4–5 | 10 (reverse, cycle, parens, min-stack) | Sketch nav back-stack + undo |
| 4 | Queues + hashing | 6–7 | 12 (sliding window, two-sum, group, unique char) | Bounded recent-search ring |
| 5 | Sets + trees basics | 8–9 | 10 (intersection, consecutive, depth, invert) | Selected-IDs set in a multi-select list |
| 6 | Trees practical + graphs intro | 10–11 | 10 (BST validate, Trie, BFS provinces) | Autocomplete Trie on a static word list |
| 7 | Caching + list rendering | 12–13 | 8 design + 6 code (LRU/TTL, diff keys) | LRU image cache stub + stable IDs |
| 8 | Decision guide + search/sort | 14–15 | 10 (binary search variants, merge) | Decision write-up for cart + feed |
| 9 | Recursion, greedy, heaps | 16–18 | 12 (backtrack lite, intervals, kth, merge-k) | Priority task scheduler sketch |
| 10 | DP lite + strings | 19, 21 | 12 (stairs, robber, coin, substring) | Offline scoring / coin-like config DP |
| 11 | Graphs advanced + bits + concurrency | 20, 22, 23 | 10 (topo, islands, bits, coalescer) | Thread-safe request coalescer |
| 12 | Interview bank + mini projects | 24–25 | **40 timed drills** from Ch 24; finish **2 mini projects** | Mock interview + portfolio demos |

---

## Optional weeks 13–16 — Top fintech track

Add these after the core 12 weeks when the loop includes payments domain, harder coding, system design, or behavioral rounds.

| Week | Focus | Chapters | Problem budget | Deliverable |
|------|--------|----------|----------------|-------------|
| 13 | Money & client reliability | 26, [E](E-upi-india-rails.md) (India) | 3 practices + Self-Check | Idempotent Pay client + integer `Money`; UPI intent vocabulary |
| 14 | Hard drills | 27 | **10 timed** (45–55 min each) | Miss log + re-solve after 48h |
| 15 | Hard drills + design | 27–28 | **10 more** Ch 27; 2 design outlines | Checkout sequence + wallet freshness one-pager |
| 16 | Behavioral & product | 29 | 3 STAR + 2 product answers aloud | Recorded mock; rubric in `solutions/ch29` |

Fintech compression (if you only have **+2 weeks** after core): Week F1 = Ch 26 + 8× Ch 27; Week F2 = Ch 28–29 + 2 designs + STAR pack.

---

## Weekly rhythm (recommended)

| Day | Activity |
|-----|----------|
| Mon | Read chapter(s); take Self-Check closed-book |
| Tue–Wed | Solve problem budget; write complexity before coding |
| Thu | Port one solution to a second language |
| Fri | Mobile deliverable + flash Big-O (Appendix B) |
| Sat | Timed 45–60 min set (2–3 problems) |
| Sun | Light review / Appendix C internals |

---

## Problem-count summary

| Block | Weeks | Approx. problems |
|-------|-------|------------------|
| Foundation + linear | 1–4 | ~36 |
| Associative + mobile systems | 5–7 | ~34 |
| Algorithms + advanced | 8–11 | ~44 |
| Interview + projects | 12 | ~40 drills + 2 projects |
| Fintech track (optional) | 13–16 | ~20 hard drills + 2 designs + STAR/product pack |
| **Total** | **12 (+4)** | **~150+** core; **~180+** with fintech track |

Chapter practice lists (3 problems each across Parts II–VI) plus Chapter 24’s ~40 interview questions are the core set. Re-solve misses after 48 hours. Part VIII is the top-fintech gap-closer (money, hard pace, design lite, behavioral).

---

## Interview-week compression (if you only have 4 weeks)

1. **Week A:** Ch 2, 3, 5, 7, 8 + Two Sum / hashing / stacks  
2. **Week B:** Ch 9–11, 15 + trees / BFS / binary search  
3. **Week C:** Ch 12–14, 18, 19 + LRU, heaps, DP lite  
4. **Week D:** Ch 24 timed bank + one mini project from Ch 25  
5. *(Fintech)* **Week E:** Ch 26 + 8× Ch 27 timed; **Week F:** Ch 28–29 + designs + STARs  

---

## Tracking checklist

- [ ] Self-Checks 1.x–23.x and 26.x–29.x, E.x (Appendix D)  
- [ ] At least **20** Ch 24 questions timed at 25–35 min each  
- [ ] At least **two** Ch 25 projects with acceptance criteria met  
- [ ] Can explain LRU, Trie, BFS shortest path, and request coalescing aloud without notes  
- [ ] *(Fintech)* Idempotency + integer money talk track fluent  
- [ ] *(Fintech)* At least **15** Ch 27 hard drills timed  
- [ ] *(Fintech)* One checkout design + three STAR stories rehearsed aloud  
- [ ] Full readiness gate: [Appendix F](F-execution-and-optional-polish.md) — execution + optional polish

Next: [Appendix B — Big-O Cheat Sheet](B-big-o-cheat-sheet.md) · Also: [Appendix F — Execution & Optional Polish](F-execution-and-optional-polish.md)
