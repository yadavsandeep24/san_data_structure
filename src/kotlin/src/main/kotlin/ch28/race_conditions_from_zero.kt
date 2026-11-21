// Race conditions from zero
// Source: book/part-vii/28-concurrency.md
package ch28.race_conditions_from_zero

// Shared without synchronization
var count = 0
fun inc() { count++ } // race if called from many threads
