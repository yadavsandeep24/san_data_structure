// Q4. String Compression (Run-Length Log Packing)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func compress(_ chars: inout [Character]) -> Int {
    var write = 0
    var read = 0
    while read < chars.count {
        let ch = chars[read]
        var run = 0
        while read < chars.count && chars[read] == ch {
            read += 1
            run += 1
        }
        chars[write] = ch
        write += 1
        if run > 1 {
            for d in String(run) {
                chars[write] = d
                write += 1
            }
        }
    }
    return write
}
