// P2: Remove k digits
// Source: solutions/ch16/README.md

function removeKdigits(num: string, k: number): string {
  let remaining = k;
  const stack: string[] = [];
  for (const c of num) {
    while (remaining > 0 && stack.length > 0 && stack[stack.length - 1] > c) {
      stack.pop();
      remaining--;
    }
    stack.push(c);
  }
  stack.length -= remaining;
  let start = 0;
  while (start < stack.length && stack[start] === '0') start++;
  const result = stack.slice(start).join('');
  return result === '' ? '0' : result;
}

export {};
