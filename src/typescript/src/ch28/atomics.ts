// Atomics
// Source: book/part-vii/28-concurrency.md

const count = new Int32Array(new SharedArrayBuffer(4)); // shareable with Workers
Atomics.add(count, 0, 1);

export {};
