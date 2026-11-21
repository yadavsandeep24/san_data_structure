// Set algebra: union, intersection, difference
// Source: book/part-iii/08-sets.md

final a = {1, 2, 3};
final b = {2, 3, 4};
final union = a.union(b);          // 1,2,3,4
final inter = a.intersection(b);   // 2,3
final diff = a.difference(b);      // 1
