// Q12. Justify Text for a Narrow Screen (Agreement Preview)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

function justify(words: string[], width: number): string[] {
  const lines: string[] = [];
  let i = 0;
  while (i < words.length) {
    let j = i, len = 0;
    while (j < words.length && len + words[j].length + (j - i) <= width) { len += words[j].length; j++; }
    if (j === i) throw new Error(`word longer than width: ${words[i]}`);
    const gaps = j - i - 1;
    if (j === words.length || gaps === 0) {
      lines.push(words.slice(i, j).join(" ").padEnd(width)); // last line or one word: left-aligned
    } else {
      const spaces = width - len;
      const each = Math.floor(spaces / gaps), extra = spaces % gaps;
      let line = "";
      for (let k = i; k < j; k++) {
        line += words[k];
        if (k < j - 1) line += " ".repeat(each + (k - i < extra ? 1 : 0));
      }
      lines.push(line);
    }
    i = j;
  }
  return lines;
}

export {};
