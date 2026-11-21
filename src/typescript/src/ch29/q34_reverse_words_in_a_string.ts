// Q34. Reverse Words in a String
// Source: book/part-viii/29-interview-questions-q31-q40.md

function reverseWords(s: string): string {
  return s.trim().split(/\s+/).reverse().join(" ");
}

export {};
