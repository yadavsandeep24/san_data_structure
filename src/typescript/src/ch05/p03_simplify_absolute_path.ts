// P3: Simplify absolute path
// Source: solutions/ch05/README.md

function simplifyPath(path: string): string {
  const st: string[] = [];
  for (const part of path.split('/')) {
    if (part === '' || part === '.') continue;
    if (part === '..') {
      if (st.length) st.pop();
    } else {
      st.push(part);
    }
  }
  return '/' + st.join('/');
}

export {};
