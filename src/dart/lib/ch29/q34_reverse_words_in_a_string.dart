// Q34. Reverse Words in a String
// Source: book/part-viii/29-interview-questions-q31-q40.md

String reverseWords(String s) =>
    s.trim().split(RegExp(r'\s+')).reversed.join(' ');
