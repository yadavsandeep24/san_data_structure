// Worked example 1: dedupe a sorted array in place (read/write)
// Source: book/part-iv/13-two-pointers.md

function dedupeSortedInPlace(a: number[]): number {
  if (a.length === 0) return 0;
  let write = 1;
  for (let read = 1; read < a.length; read++) {
    if (a[read] !== a[write - 1]) {
      a[write] = a[read];
      write++;
    }
  }
  return write; // caller may do a.length = write
}

export {};
