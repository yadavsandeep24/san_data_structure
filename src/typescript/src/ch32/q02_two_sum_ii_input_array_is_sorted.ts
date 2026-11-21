// Q2. Two Sum II: Input Array Is Sorted (Sorted Price Pair)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function twoSumSorted(numbers: number[], target: number): number[] {
  let i = 0;
  let j = numbers.length - 1;
  while (i < j) {
    const sum = numbers[i] + numbers[j];
    if (sum === target) return [i + 1, j + 1];
    if (sum < target) i++;
    else j--;
  }
  return [];
}

export {};
