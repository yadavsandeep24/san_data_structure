// Bit operations
// Source: book/part-vii/27-bits-matrix.md

abstract final class Perm {
  static const read = 1 << 0;
  static const write = 1 << 1;
  static const exec = 1 << 2;
}

bool canWrite(int flags) => (flags & Perm.write) != 0;
int grantWrite(int flags) => flags | Perm.write;
