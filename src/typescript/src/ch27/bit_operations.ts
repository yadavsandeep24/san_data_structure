// Bit operations
// Source: book/part-vii/27-bits-matrix.md

const Perm = { READ: 1 << 0, WRITE: 1 << 1, EXEC: 1 << 2 } as const;

const canWrite = (flags: number) => (flags & Perm.WRITE) !== 0;
const grantWrite = (flags: number) => flags | Perm.WRITE;

export {};
