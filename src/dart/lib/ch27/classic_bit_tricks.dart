// Classic bit tricks
// Source: book/part-vii/27-bits-matrix.md

int singleNumber(List<int> nums) => nums.fold(0, (acc, x) => acc ^ x);

bool isPowerOfTwo(int n) => n > 0 && (n & (n - 1)) == 0;

int hammingWeight(int n) {
  var c = 0;
  var x = n & 0xFFFFFFFF; // count as 32-bit, like Kotlin Int (-1 -> 32)
  while (x != 0) {
    x &= x - 1;
    c++;
  }
  return c;
}
