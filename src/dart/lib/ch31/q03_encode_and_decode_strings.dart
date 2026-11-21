// Q3. Encode and Decode Strings (Offline Queue Serialization)
// Source: book/part-viii/31-arrays-hashing-matrix.md
import 'dart:convert';

String encode(List<String> strs) => strs.map((s) => '${utf8.encode(s).length}#$s').join();

List<String> decode(String s) {
  final bytes = utf8.encode(s);
  final out = <String>[];
  var i = 0;
  while (i < bytes.length) {
    var hash = i;
    var len = 0;
    while (bytes[hash] != 0x23) {
      len = len * 10 + (bytes[hash++] - 0x30);
    }
    out.add(utf8.decode(bytes.sublist(hash + 1, hash + 1 + len)));
    i = hash + 1 + len;
  }
  return out;
}
