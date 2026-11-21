// Q4. String Compression (Run-Length Log Packing)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q04_string_compression

fun compress(chars: CharArray): Int {
    var write = 0
    var read = 0
    while (read < chars.size) {
        val ch = chars[read]
        var run = 0
        while (read < chars.size && chars[read] == ch) {
            read++
            run++
        }
        chars[write++] = ch
        if (run > 1) for (d in run.toString()) chars[write++] = d
    }
    return write
}
