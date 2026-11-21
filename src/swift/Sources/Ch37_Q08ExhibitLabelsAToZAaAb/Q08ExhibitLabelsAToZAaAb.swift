// Q8. Exhibit Labels A to Z, AA, AB (Legal Exhibits)
// Source: book/part-viii/37-math-and-number-drills.md

func columnTitle(_ number: Int) -> String {
    precondition(number > 0 && number <= Int(Int32.max))   // same range as Kotlin's Int
    var letters: [Character] = []
    var n = number
    while n > 0 {
        n -= 1                                          // shift to 0-based: A..Z is 0..25 in each position
        letters.append(Character(Unicode.Scalar(UInt8(65 + n % 26))))
        n /= 26
    }
    return String(letters.reversed())
}

func columnNumber(_ title: String) -> Int? {
    guard !title.isEmpty else { return nil }
    var value = 0
    for c in title.utf8 {
        guard c >= 65 && c <= 90 else { return nil }    // only A..Z
        let digit = Int(c) - 64
        if value > (Int(Int32.max) - digit) / 26 { return nil }   // past Int32.max, like Kotlin's Int
        value = value * 26 + digit
    }
    return value
}
