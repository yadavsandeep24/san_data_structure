// Kotlin, Dart and TypeScript string notes
// Source: book/part-vii/26-strings.md

const flag = "🇺🇸";
flag.length;           // 4
[...flag].length;      // 2  (two code points)
// grapheme: Intl.Segmenter when available
const seg = new Intl.Segmenter("en", { granularity: "grapheme" });
[...seg.segment(flag)].length; // 1

export {};
