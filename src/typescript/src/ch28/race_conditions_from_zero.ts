// Race conditions from zero
// Source: book/part-vii/28-concurrency.md

// JS is single-threaded for JS heap — races still appear with
// shared buffers, native modules, or incorrect assumptions about await.
let count = 0;
async function inc() {
  const c = count;
  await Promise.resolve(); // yield — another task can interleave
  count = c + 1;
}

export {};
