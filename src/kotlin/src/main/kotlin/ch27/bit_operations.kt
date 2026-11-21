// Bit operations
// Source: book/part-vii/27-bits-matrix.md
package ch27.bit_operations

object Perm {
    const val READ = 1 shl 0
    const val WRITE = 1 shl 1
    const val EXEC = 1 shl 2
}
fun canWrite(flags: Int) = flags and Perm.WRITE != 0
fun grantWrite(flags: Int) = flags or Perm.WRITE
