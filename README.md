# Data Structures & Algorithms for Mobile Developers

A practical, interview-ready curriculum for Android, iOS, Flutter and React Native engineers. Every concept is framed around mobile constraints (memory, battery, main-thread budget), with worked code in **Kotlin**, **Swift**, **Dart** and **TypeScript**.

This is an original regeneration of the *DSA for Mobile* curriculum (preview TOC), written as a teaching book — not a copy of any commercial PDF.

## How the book is organized

| Parts | What they do |
|-------|--------------|
| **I–III** | Structures: Big-O, arrays, lists, stacks, queues, hashing, sets, trees, graphs, heaps |
| **IV — Core Patterns** | The moves interviews expect: two pointers, sliding window, prefix sums, monotonic stack/deque, intervals & sweep line |
| **V** | Mobile systems: caching, list rendering, choosing the right structure |
| **VI–VII** | Algorithms and advanced topics: searching (incl. binary search on the answer), recursion, greedy, DP, advanced graphs, strings, bits, concurrency |
| **VIII — Practice** | Timed drill banks (medium, hard, pattern-tagged, math) and portfolio mini projects |
| **IX — Domain tracks** | Fintech (money, idempotency, system design, behavioral) and document/e-signature drills |

Every teaching chapter follows the same shape: mobile motivation → concept with complexity tables → platform bridges → four-language worked code → common mistakes → Self-Check (answers in Appendix D) → 3 practice problems with full solutions → **More practice** links into the drill banks → What to remember.

## How to read

1. Start with the [Preface](book/00-preface.md).
2. Work Parts I → VII in order; later chapters assume earlier ones.
3. After each chapter, try the practice problems before opening `solutions/`, then do a few of its **More practice** drills.
4. Use Part VIII as timed practice: Chapter 29 (medium), Chapter 30 (hard), Chapters 31–36 (pattern drills), Chapter 38 (projects).
5. For **top fintech** loops, add the fintech track in Part IX (Chapters 39–41, Appendix E).
6. For **document / e-signature** loops (Docusign-style), add Chapter 42 and Chapter 37's math drills.
7. Follow [Appendix A](book/appendices/A-12-week-roadmap.md) for a week-by-week schedule, and read [Appendix F](book/appendices/F-execution-and-optional-polish.md) before applying.

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

### Part III — Associative Structures, Trees, Graphs & Heaps
- [7. Hash Tables (HashMap / Dictionary / Map)](book/part-iii/07-hash-tables.md)
- [8. Sets](book/part-iii/08-sets.md)
- [9. Trees Basics](book/part-iii/09-trees-basics.md)
- [10. Trees Practical (BST, Trie, JSON)](book/part-iii/10-trees-practical.md)
- [11. Graphs Intro](book/part-iii/11-graphs-intro.md)
- [12. Heaps and Priority Queues](book/part-iii/12-heaps-priority-queues.md)

### Part IV — Core Patterns
- [13. Two Pointers](book/part-iv/13-two-pointers.md)
- [14. Sliding Window](book/part-iv/14-sliding-window.md)
- [15. Prefix Sums & Difference Arrays](book/part-iv/15-prefix-sums.md)
- [16. Monotonic Stack & Deque](book/part-iv/16-monotonic-stack-deque.md)
- [17. Intervals & Sweep Line](book/part-iv/17-intervals-sweep-line.md)

### Part V — Mobile-Specific Topics
- [18. Caching Strategies](book/part-v/18-caching-strategies.md)
- [19. Efficient List Rendering](book/part-v/19-efficient-list-rendering.md)
- [20. Choosing the Right Structure — Decision Guide](book/part-v/20-decision-guide.md)

### Part VI — Essential Algorithm Techniques
- [21. Searching and Sorting You Actually Use](book/part-vi/21-searching-sorting.md)
- [22. Recursion and Backtracking](book/part-vi/22-recursion-backtracking.md)
- [23. Greedy Thinking](book/part-vi/23-greedy-thinking.md)
- [24. Dynamic Programming](book/part-vi/24-dynamic-programming.md)

### Part VII — Advanced Topics
- [25. Graphs — Advanced Patterns](book/part-vii/25-graphs-advanced.md)
- [26. Strings — Patterns & Internals](book/part-vii/26-strings.md)
- [27. Bit Manipulation & Matrix Problems](book/part-vii/27-bits-matrix.md)
- [28. Concurrency & Thread-Safe Structures](book/part-vii/28-concurrency.md)

### Part VIII — Practice: Drill Banks & Projects
- [29. Interview Questions, Mobile-Dev Focused](book/part-viii/29-interview-questions.md) — [Q1–Q10](book/part-viii/29-interview-questions-q01-q10.md) · [Q11–Q20](book/part-viii/29-interview-questions-q11-q20.md) · [Q21–Q30](book/part-viii/29-interview-questions-q21-q30.md) · [Q31–Q40](book/part-viii/29-interview-questions-q31-q40.md)
- [30. Hard Drill Bank (Top-Company Pace)](book/part-viii/30-hard-drill-bank.md) — [Q1–Q10](book/part-viii/30-hard-drill-bank-q01-q10.md) · [Q11–Q20](book/part-viii/30-hard-drill-bank-q11-q20.md)
- [31. Arrays, Hashing & Matrix — Pattern Drills](book/part-viii/31-arrays-hashing-matrix.md)
- [32. Two Pointers, Sliding Window & Intervals — Pattern Drills](book/part-viii/32-two-pointers-windows-intervals.md)
- [33. Stacks & Binary Search — Pattern Drills](book/part-viii/33-stacks-binary-search.md)
- [34. Linked Lists & Trees — Pattern Drills](book/part-viii/34-linked-lists-trees.md)
- [35. Heaps, Tries & Greedy — Pattern Drills](book/part-viii/35-heaps-tries-greedy.md)
- [36. Graphs & Dynamic Programming — Pattern Drills](book/part-viii/36-graphs-dynamic-programming.md)
- [37. Math & Number Drills](book/part-viii/37-math-and-number-drills.md)
- [38. Mini Projects](book/part-viii/38-mini-projects.md)

### Part IX — Domain Tracks: Fintech & Document Signing
- [39. Money, Idempotency & Client Reliability](book/part-ix/39-money-idempotency-reliability.md)
- [40. Mobile Fintech System Design (Lite)](book/part-ix/40-mobile-fintech-system-design.md)
- [41. Behavioral & Product Sense (Fintech)](book/part-ix/41-behavioral-product-fintech.md)
- [42. Document & Signing Drill Bank](book/part-ix/42-document-signing-drill-bank.md) — [Q1–Q7](book/part-ix/42-document-signing-drill-bank-q01-q07.md) · [Q8–Q13](book/part-ix/42-document-signing-drill-bank-q08-q13.md)

### Appendices
- [A. 12-Week Preparation Roadmap](book/appendices/A-12-week-roadmap.md) (plus optional domain-track weeks 13–16)
- [B. Big-O Master Cheat Sheet](book/appendices/B-big-o-cheat-sheet.md)
- [C. Collections Internals (4 Languages)](book/appendices/C-collections-internals.md)
- [D. Quick Self-Check Answer Key](book/appendices/D-self-check-answer-key.md)
- [E. UPI & India Payment Rails](book/appendices/E-upi-india-rails.md)
- [F. Execution Checklist & Optional Polish](book/appendices/F-execution-and-optional-polish.md) — **what you must still do** + future curriculum ideas
- [G. 12-Day DSA Plan Map](book/appendices/G-12-day-dsa-plan-map.md) — a popular 120-problem plan, day by day, linked to where each problem is solved here

## Solutions

Every chapter has a folder under [`solutions/`](solutions/README.md) (`solutions/ch01` … `solutions/ch42`), linked from the chapter's footer.

- Teaching chapters (1–28, 39–41): full model solutions for each practice problem — approach, complexity, edge cases, mobile note, and code in four languages for coding problems (reasoning answers for Chapters 1–2 and the design/behavioral Chapters 40–41).
- Drill banks (29–37, 42): solutions are inline in the chapter; the `solutions/` folder is an index with condensed "remember this" notes.
- Mini projects (38): reference architectures.
- Self-Check answers: [Appendix D](book/appendices/D-self-check-answer-key.md).

## Code and snippet tests

[`code/`](code/) holds a harness that **extracts code blocks from the chapters and runs tests against them** in Kotlin, Dart and TypeScript (`code/verify_snippets.py`), plus a few small reference samples with a smoke script. See [`code/README.md`](code/README.md).

## Read online (GitHub Pages)

Mobile-friendly site with sidebar and search: see [GITHUB_PAGES.md](GITHUB_PAGES.md) for setup. After publishing, open `https://YOUR_USERNAME.github.io/REPO_NAME/` on your phone.
