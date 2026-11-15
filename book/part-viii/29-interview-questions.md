# Chapter 29 — Interview Questions, Mobile-Dev Focused

This chapter is a **timed drill bank** for mobile engineers. Every problem is a standard DSA pattern wrapped in a product-shaped story (feeds, caches, navigation, coalescing). Solutions include approach, complexity, and code in **Kotlin / Swift / Dart / TypeScript** for core questions; remaining questions use two languages to keep the chapter usable.

Companion index (anchors + condensed notes): [`solutions/ch29/README.md`](../../solutions/ch29/README.md)

---

## Strategy half — how to interview like a mobile engineer

### 1. Open with constraints, not code

Say aloud: **input size**, **hot path** (UI thread vs background), **memory bound**, and **success metric** (correctness, frame budget, battery). Interviewers hiring for mobile listen for this.

### 2. Name the structure contract

Before typing: “Hash map for O(1) membership,” “deque for sliding window,” “min-heap of size k.” Wrong structure is harder to fix than a typo.

### 3. Complexity before cleverness

State time and space **before** coding. If they ask to optimize, change the structure or move work off the hot path — don’t micro-tune first.

### 4. Mobile tells that score points

- Bound caches; never “HashMap forever.”
- Prefer arrays for UI lists; sets/maps as side indexes.
- Avoid `shift` / `removeAt(0)` in hot loops.
- Mark visited when **enqueuing** in BFS.
- Prefer iterative DFS on untrusted depth.
- Single-flight / coalesce identical network keys.

### 5. Timed protocol (25–35 minutes)

| Minutes | Action |
|---------|--------|
| 0–3 | Restate + examples + edge cases |
| 3–8 | Approach + complexity + structure choice |
| 8–25 | Code happy path |
| 25–30 | Edges, tests, mobile note |
| 30–35 | Complexity recap / follow-ups |

### 6. Edge-case checklist

Empty input · single element · duplicates · negatives · overflow · disconnected graph · capacity 0 cache · concurrent double-call · UTF-16 vs grapheme · already sorted / reverse sorted.

### 7. When stuck

1. Brute force correctly (say the cost).
2. Find the repeated work → hash / sort / window / heap / DP.
3. Draw n≤6 example.
4. Offer a mobile-compromised solution (debounce, background, approximate) if exact is too hard — then return to exact.

### 8. Topic map for this bank

| Topic | Questions |
|-------|-----------|
| Arrays / hashing | Q1–Q5 |
| Stacks / queues | Q6–Q9 |
| Linked lists | Q10–Q12 |
| Trees | Q13–Q17 |
| Binary search | Q18–Q20 |
| Graphs BFS/DFS | Q21–Q24 |
| Heaps | Q25–Q27 |
| DP lite | Q28–Q31 |
| Strings | Q32–Q35 |
| Concurrency / design | Q36–Q40 |

**Language policy:** Q1–Q20 → four languages. Q21–Q40 → Kotlin+Swift *or* Dart+TypeScript (alternating), still with full approach notes.

---

## Question sets

| Set | Questions |
|-----|-----------|
| [Q1–Q10](29-interview-questions-q01-q10.md) | Two Sum (Cart SKU Pair) · Contains Duplicate (Dedupe Guard) · Group Anagrams (Facet Grouping) · Top K Frequent Elements · Subarray Sum Equals K · Valid Parentheses (Schema or Deep Link Path) · Min Stack (Debug Overlay) · Sliding Window Maximum (Scroll Velocity) · Recent Searches Ring Buffer · Reverse Linked List |
| [Q11–Q20](29-interview-questions-q11-q20.md) | Linked List Cycle (Floyd) · Merge Two Sorted Lists · Maximum Depth of Binary Tree · Invert Binary Tree · Validate BST · Binary Tree Level Order · Lowest Common Ancestor of BST · Binary Search · Search Insert Position (Lower Bound) · Find Peak Element |
| [Q21–Q30](29-interview-questions-q21-q30.md) | Number of Provinces (Connected Components) · Clone Graph · Course Schedule (Cycle Detect) · Shortest Path in Unweighted Graph · Kth Largest Element · Merge K Sorted Lists (Feed Merge) · Meeting Rooms or Min Platforms (Heap) · Climbing Stairs · House Robber · Coin Change |
| [Q31–Q40](29-interview-questions-q31-q40.md) | Unique Paths · First Unique Character · Longest Substring Without Repeating Characters · Reverse Words in a String · Implement Trie (Autocomplete Core) · LRU Cache · Thread-Safe Request Coalescer (Single-Flight) · Token Bucket Rate Limiter · Navigation Back Stack · Debounced Search Index Query |

---

## Closing drill advice

- Re-solve any question you needed hints for after **48 hours**.
- Speak the **mobile note** in mocks — it differentiates app engineers from generic grinders.
- Use Appendix A’s Week 12 to time **20+** of these under interview conditions.

---

Previous: [Chapter 28 — Concurrency & Thread-Safe Structures](../part-vii/28-concurrency.md) · Next: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q1–Q10](29-interview-questions-q01-q10.md) · Solutions: [`solutions/ch29`](../../solutions/ch29/README.md)
