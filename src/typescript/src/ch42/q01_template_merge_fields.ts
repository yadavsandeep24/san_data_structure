// Q1. Template Merge Fields (Envelope Email Body)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

function render(
  t: string,
  values: Record<string, string>,
  onMissing: (key: string) => string = (k) => `{{${k}}}`,
): string {
  let out = "";
  let i = 0;
  while (i < t.length) {
    if (t.startsWith("\\{{", i)) {
      out += "{{";
      i += 3;
    } else if (t.startsWith("{{", i)) {
      const end = t.indexOf("}}", i + 2);
      if (end === -1) throw new Error(`Unclosed field at index ${i}`);
      const key = t.substring(i + 2, end).trim();
      out += Object.hasOwn(values, key) ? values[key] : onMissing(key);
      i = end + 2;
    } else {
      out += t[i];
      i++;
    }
  }
  return out;
}

export {};
