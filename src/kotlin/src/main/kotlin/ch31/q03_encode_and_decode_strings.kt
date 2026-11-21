// Q3. Encode and Decode Strings (Offline Queue Serialization)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q03_encode_and_decode_strings

fun encode(strs: List<String>): String {
    val sb = StringBuilder()
    for (s in strs) sb.append(s.toByteArray(Charsets.UTF_8).size).append('#').append(s)
    return sb.toString()
}

fun decode(s: String): List<String> {
    val bytes = s.toByteArray(Charsets.UTF_8)
    val out = mutableListOf<String>()
    var i = 0
    while (i < bytes.size) {
        var hash = i
        var len = 0
        while (bytes[hash] != '#'.code.toByte()) len = len * 10 + (bytes[hash++] - '0'.code.toByte())
        out.add(String(bytes, hash + 1, len, Charsets.UTF_8))
        i = hash + 1 + len
    }
    return out
}
