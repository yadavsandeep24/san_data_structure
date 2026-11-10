# Data Structures & Algorithms for Mobile Developers

A practical, interview-ready curriculum for Android, iOS, Flutter, and React Native engineers. Every concept is framed around mobile constraints (memory, battery, main-thread budget) with worked code in **Kotlin**, **Swift**, **Dart**, and **TypeScript**. **Part VIII** adds the top-fintech gap-closer: money/idempotency, a hard drill bank, system design lite, and behavioral/product.

This is an original regeneration of the *DSA for Mobile* curriculum (preview TOC), written as a teaching book — not a copy of any commercial PDF.

## How to read

1. Start with [Preface](book/00-preface.md).
2. Work Parts I → VII in order; later chapters assume earlier ones.
3. After each chapter, attempt the practice problems before opening `solutions/`.
4. Use Chapter 24 as a timed interview drill bank; use Appendix A for a 12-week schedule.
5. For **top fintech** loops, continue with Part VIII (money/idempotency, hard drills, system design lite, behavioral).
6. For **document / e-signature** loops (Docusign-style), add Part IX: signing-app drills and math/number problems.
7. Before applying, read [Appendix F — Execution & Optional Polish](book/appendices/F-execution-and-optional-polish.md) for what you still must **do** vs optional future content.

## Language legend

| Label | Platform focus |
|-------|----------------|
| Kotlin | Android / KMP |
| Swift | iOS |
| Dart | Flutter |
| TypeScript | React Native |

## Book map

### Part I — Foundation
- [1. Why Data Structures Matter for Mobile Developers](book/part-i/01-why-data-structures-matter.md)
- [2. Big-O Notation — Understanding It Practically](book/part-i/02-big-o-notation.md)

### Part II — Linear Data Structures
- [3. Arrays and Dynamic Arrays](book/part-ii/03-arrays-dynamic-arrays.md)
- [4. Linked Lists](book/part-ii/04-linked-lists.md)
- [5. Stacks](book/part-ii/05-stacks.md)
- [6. Queues and Deques](book/part-ii/06-queues-deques.md)

### Part III — Non-Linear & Associative Structures
- [7. Hash Tables](book/part-iii/07-hash-tables.md)
- [8. Sets](book/part-iii/08-sets.md)
- [9. Trees, Basics](book/part-iii/09-trees-basics.md)
- [10. Trees — Practical](book/part-iii/10-trees-practical.md)
- [11. Graphs, a Lightweight Introduction](book/part-iii/11-graphs-intro.md)

### Part IV — Mobile-Specific Topics
- [12. Caching Strategies](book/part-iv/12-caching-strategies.md)
- [13. Efficient List Rendering](book/part-iv/13-efficient-list-rendering.md)
- [14. Choosing the Right Structure](book/part-iv/14-decision-guide.md)

### Part V — Essential Algorithm Techniques
- [15. Searching and Sorting](book/part-v/15-searching-sorting.md)
- [16. Recursion and Backtracking](book/part-v/16-recursion-backtracking.md)
- [17. Greedy Thinking](book/part-v/17-greedy-thinking.md)

### Part VI — Advanced Structures & Techniques
- [18. Heaps & Priority Queues](book/part-vi/18-heaps-priority-queues.md)
- [19. Dynamic Programming](book/part-vi/19-dynamic-programming.md)
- [20. Graphs — Advanced Patterns](book/part-vi/20-graphs-advanced.md)
- [21. Strings — Patterns & Internals](book/part-vi/21-strings.md)
- [22. Bit Manipulation & Matrix Problems](book/part-vi/22-bits-matrix.md)
- [23. Concurrency & Thread-Safe Structures](book/part-vi/23-concurrency.md)

### Part VII — Practice
- [24. Interview Questions, Mobile-Dev Focused](book/part-vii/24-interview-questions.md)
- [25. Mini Projects](book/part-vii/25-mini-projects.md)

### Part VIII — Top Fintech Prep
- [26. Money, Idempotency & Client Reliability](book/part-viii/26-money-idempotency-reliability.md)
- [27. Hard Drill Bank (Top-Company Pace)](book/part-viii/27-hard-drill-bank.md)
- [28. Mobile Fintech System Design (Lite)](book/part-viii/28-mobile-fintech-system-design.md)
- [29. Behavioral & Product Sense (Fintech)](book/part-viii/29-behavioral-product-fintech.md)

### Part IX — Document & Signing Apps (Docusign-style loops)
- [30. Document & Signing Drill Bank](book/part-ix/30-document-signing-drill-bank.md)
- [31. Math & Number Drills](book/part-ix/31-math-and-number-drills.md)

### Part X — 12-Day Plan Gap-Closer
The 67 problems from a popular 12-day / 120-problem DSA plan that earlier parts didn't already cover. [Appendix G](book/appendices/G-12-day-dsa-plan-map.md) maps all 120 to where they live in this book.
- [32. Arrays, Hashing & Matrix](book/part-x/32-arrays-hashing-matrix.md)
- [33. Two Pointers, Windows & Intervals](book/part-x/33-two-pointers-windows-intervals.md)
- [34. Stacks & Binary Search](book/part-x/34-stacks-binary-search.md)
- [35. Linked Lists & Trees](book/part-x/35-linked-lists-trees.md)
- [36. Heaps, Tries & Greedy](book/part-x/36-heaps-tries-greedy.md)
- [37. Graphs & Dynamic Programming](book/part-x/37-graphs-dynamic-programming.md)

### Appendices
- [A. 12-Week Preparation Roadmap](book/appendices/A-12-week-roadmap.md) (plus optional weeks 13–16 for fintech)
- [B. Big-O Master Cheat Sheet](book/appendices/B-big-o-cheat-sheet.md)
- [C. Collections Internals (4 Languages)](book/appendices/C-collections-internals.md)
- [D. Quick Self-Check Answer Key](book/appendices/D-self-check-answer-key.md)
- [E. UPI & India Payment Rails](book/appendices/E-upi-india-rails.md)
- [F. Execution Checklist & Optional Polish](book/appendices/F-execution-and-optional-polish.md) — **what you must still do** + future curriculum ideas
- [G. 12-Day DSA Plan Map](book/appendices/G-12-day-dsa-plan-map.md) — all 120 plan problems, day by day, linked to their chapter

## Solutions

Per-chapter model solutions live under [`solutions/`](solutions/).

- Chapter 24: full solutions inline in the interview chapter; index at [`solutions/ch24/`](solutions/ch24/README.md)
- Chapter 25: reference architectures at [`solutions/ch25/`](solutions/ch25/README.md)
- Chapters 26–29: [`solutions/ch26`](solutions/ch26/README.md) · [`ch27`](solutions/ch27/README.md) · [`ch28`](solutions/ch28/README.md) · [`ch29`](solutions/ch29/README.md)
- Chapters 30–31: [`solutions/ch30`](solutions/ch30/README.md) · [`ch31`](solutions/ch31/README.md)
- Chapters 32–37: [`ch32`](solutions/ch32/README.md) · [`ch33`](solutions/ch33/README.md) · [`ch34`](solutions/ch34/README.md) · [`ch35`](solutions/ch35/README.md) · [`ch36`](solutions/ch36/README.md) · [`ch37`](solutions/ch37/README.md)
- Self-Check answers: [`Appendix D`](book/appendices/D-self-check-answer-key.md)

## Code samples

Small reference sketches with a smoke harness: [`code/`](code/) (`UniquePreserveOrder`, `kLargest` in all four languages). Prefer the in-chapter and `solutions/` snippets for interview study. Run `code/run_smoke.sh` to verify local toolchains.

## Read online (GitHub Pages)

Mobile-friendly site with sidebar and search: see [GITHUB_PAGES.md](GITHUB_PAGES.md) for setup. After publishing, open `https://YOUR_USERNAME.github.io/REPO_NAME/` on your phone.
