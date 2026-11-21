// Q3. Encode and Decode Strings (Offline Queue Serialization)
// Source: book/part-viii/31-arrays-hashing-matrix.md

const utf8 = new TextEncoder();
const fromUtf8 = new TextDecoder();

function encode(strs: string[]): string {
  return strs.map((s) => `${utf8.encode(s).length}#${s}`).join("");
}

function decode(s: string): string[] {
  const bytes = utf8.encode(s);
  const out: string[] = [];
  let i = 0;
  while (i < bytes.length) {
    let hash = i;
    let len = 0;
    while (bytes[hash] !== 35) len = len * 10 + (bytes[hash++] - 48);
    out.push(fromUtf8.decode(bytes.subarray(hash + 1, hash + 1 + len)));
    i = hash + 1 + len;
  }
  return out;
}

export {};
