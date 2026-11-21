// Worked code: append vs insert front
// Source: book/part-ii/03-arrays-dynamic-arrays.md

final end = <int>[];
void example() {
  end.add(1);                   // O(1) amortized
  end.insert(0, 99);            // O(n)
}

final fixed = List<int>.filled(3, 0); // fixed length
// fixed.add(1); → throws
