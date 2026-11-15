# Appendix A — Your 12-Week Preparation Roadmap

A focused plan for mobile engineers preparing for product-company interviews while building stronger day-to-day architecture instincts. Assume **6–8 focused hours per week**. Adjust the intensity, not the order: later weeks assume the earlier ones.

Each week lists **chapter reading**, a **problem budget** (chapter practice plus "More practice" drills), and a **mobile deliverable**: a small artifact you can talk about in interviews.

| Week | Focus | Chapters | Problem budget | Mobile deliverable |
|------|-------|----------|----------------|--------------------|
| 1 | Mindset + Big-O | 1–2 | 6 warm-ups (membership, cost reading, budget math) | One-pager: "UI thread vs background" for a feed screen |
| 2 | Arrays + linked lists | 3–4 | 8 (dedupe, rotate, reverse, cycle, LRU sketch) | Profile prepend vs append on a 10k list |
| 3 | Stacks + queues | 5–6 | 8 (parens, min stack, two-stack queue, bounded queue) | Sketch a nav back stack + undo |
| 4 | Hashing + sets | 7–8 | 10 (two sum, frequency, group anagrams, consecutive) | Selected-IDs set in a multi-select list |
| 5 | Trees | 9–10 | 10 (depth, invert, validate BST, LCA, Trie) | Autocomplete Trie over a static word list |
| 6 | Graphs intro + heaps | 11–12 | 10 (provinces, BFS shortest path, kth largest, top-k, merge-k) | Top-K trending list with a size-k heap |
| 7 | **Core Patterns I** | 13–15 | 12 (chapter practice + Ch 31–32 drills: 3Sum, container, windows, product-except-self) | Worst-k-frame jank finder over a frame-time trace |
| 8 | **Core Patterns II** | 16–17 | 10 (next greater, span, histogram, merge/insert intervals, meeting rooms) | Calendar day view: merge busy blocks + conflict check |
| 9 | Mobile systems + search | 18–21 | 8 design + 6 code (LRU/TTL, diff keys, binary search + on-the-answer) | LRU image cache stub + stable IDs in a list |
| 10 | Recursion, greedy, DP | 22–24 | 12 (subsets, combination sum, jump game, intervals greedy, stairs, robber, coin change) | Write-up: one place DP *would* help your app, and one where it wouldn't |
| 11 | Advanced topics | 25–28 | 10 (topological sort, Dijkstra, union-find, strings, bits/grid, coalescer) | Thread-safe request coalescer |
| 12 | Interview bank + projects | 29, 31–36, 38 | **20 timed** from Ch 29 + **10** pattern drills; finish **2 mini projects** | Mock interview + portfolio demos |

---

## Optional weeks 13–16 — choose a domain track

### Top fintech track

Add this after the core 12 weeks when the loop includes payments domain, harder coding, system design or behavioral rounds.

| Week | Focus | Chapters | Problem budget | Deliverable |
|------|-------|----------|----------------|-------------|
| 13 | Money & client reliability | 39, [E](E-upi-india-rails.md) (India) | 3 practices + Self-Check | Idempotent Pay client + integer `Money`; UPI intent vocabulary |
| 14 | Hard drills | 30 (Q1–Q10) | **10 timed** (45–55 min each) | Miss log + re-solve after 48h |
| 15 | Hard drills + design | 30 (Q11–Q20), 40 | **10 more** hard; 2 design outlines | Checkout sequence + wallet freshness one-pager |
| 16 | Behavioral & product | 41 | 3 STAR + 2 product answers aloud | Recorded mock; rubric in `solutions/ch41` |

Fintech compression (only **+2 weeks** after the core): Week F1 = Ch 39 + 8× Ch 30. Week F2 = Ch 40–41 + 2 designs + STAR pack.

### Document / e-signature track (Docusign-style loops)

| Week | Focus | Chapters | Problem budget |
|------|-------|----------|----------------|
| 13 | Signing-app drills | 42 (Q1–Q7) | 7 timed |
| 14 | Signing-app drills + math | 42 (Q8–Q13), 37 | 6 timed + 6 math |
| 15–16 | Hard drills + behavioral | 30, 41 | 10 hard + 3 STAR |

---

## Weekly rhythm (recommended)

| Day | Activity |
|-----|----------|
| Mon | Read the chapter(s); take the Self-Check closed-book |
| Tue–Wed | Solve the problem budget; write the complexity before coding |
| Thu | Port one solution to a second language |
| Fri | Mobile deliverable + Big-O flash review (Appendix B) |
| Sat | Timed 45–60 min set (2–3 problems from "More practice") |
| Sun | Light review / Appendix C internals |

---

## Problem-count summary

| Block | Weeks | Approx. problems |
|-------|-------|------------------|
| Foundation + linear + associative | 1–6 | ~52 |
| Core Patterns | 7–8 | ~22 |
| Mobile systems + algorithms + advanced | 9–11 | ~36 |
| Interview bank + projects | 12 | ~30 timed + 2 projects |
| Domain track (optional) | 13–16 | ~20 hard drills + designs / signing drills + STAR pack |
| **Total** | **12 (+4)** | **~140** core; **~170+** with a domain track |

Each teaching chapter has 3 practice problems with full solutions plus a **More practice** list pointing to drills in Chapters 29–37 and 42. Re-solve your misses after 48 hours. [Appendix G](G-12-day-dsa-plan-map.md) maps a popular 120-problem list onto the book if you prefer to drill by day.

---

## Interview-week compression (if you only have 4 weeks)

1. **Week A:** Ch 2, 3, 5, 7, 8, 13, 14 — hashing, stacks, two pointers, sliding window
2. **Week B:** Ch 9–12, 15–17, 21 — trees, BFS, heaps, prefix sums, monotonic stack, intervals, binary search
3. **Week C:** Ch 18–19, 22–24 — LRU, list diffing, backtracking, greedy, DP basics
4. **Week D:** Ch 29 timed bank + Ch 31–33 pattern drills + one mini project from Ch 38
5. *(Fintech)* **Week E:** Ch 39 + 8× Ch 30 timed. **Week F:** Ch 40–41 + designs + STARs

---

## Tracking checklist

- [ ] Self-Checks 1.x–28.x (and 39.x–41.x, E.x for fintech) — Appendix D
- [ ] Can name the pattern (two pointers / window / prefix / monotonic stack / sweep) for a new array problem within 2 minutes
- [ ] At least **20** Ch 29 questions timed at 25–35 min each
- [ ] At least **two** Ch 38 projects with acceptance criteria met
- [ ] Can explain LRU, Trie, BFS shortest path and request coalescing aloud without notes
- [ ] *(Fintech)* Idempotency + integer money talk track fluent
- [ ] *(Fintech)* At least **15** Ch 30 hard drills timed
- [ ] *(Fintech)* One checkout design + three STAR stories rehearsed aloud
- [ ] Full readiness gate: [Appendix F](F-execution-and-optional-polish.md) — execution + optional polish

Next: [Appendix B — Big-O Cheat Sheet](B-big-o-cheat-sheet.md) · Also: [Appendix F — Execution & Optional Polish](F-execution-and-optional-polish.md)
