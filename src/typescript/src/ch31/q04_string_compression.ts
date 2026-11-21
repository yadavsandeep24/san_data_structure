// Q4. String Compression (Run-Length Log Packing)
// Source: book/part-viii/31-arrays-hashing-matrix.md

function compress(chars: string[]): number {
  let write = 0;
  let read = 0;
  while (read < chars.length) {
    const ch = chars[read];
    let run = 0;
    while (read < chars.length && chars[read] === ch) {
      read++;
      run++;
    }
    chars[write++] = ch;
    if (run > 1) for (const d of String(run)) chars[write++] = d;
  }
  return write;
}

export {};
