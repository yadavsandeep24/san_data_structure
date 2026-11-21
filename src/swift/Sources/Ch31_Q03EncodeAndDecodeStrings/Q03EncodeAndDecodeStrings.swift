// Q3. Encode and Decode Strings (Offline Queue Serialization)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func encode(_ strs: [String]) -> String {
    strs.map { "\($0.utf8.count)#\($0)" }.joined()
}

func decode(_ s: String) -> [String] {
    let bytes = Array(s.utf8)
    var out: [String] = []
    var i = 0
    while i < bytes.count {
        var hash = i
        while bytes[hash] != UInt8(ascii: "#") { hash += 1 }
        let len = bytes[i..<hash].reduce(0) { $0 * 10 + Int($1 - UInt8(ascii: "0")) }
        out.append(String(decoding: bytes[(hash + 1)..<(hash + 1 + len)], as: UTF8.self))
        i = hash + 1 + len
    }
    return out
}
