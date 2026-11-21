// Q34. Reverse Words in a String
// Source: book/part-viii/29-interview-questions-q31-q40.md

func reverseWords(_ s: String) -> String {
    s.split(whereSeparator: \.isWhitespace).reversed().joined(separator: " ")
}
