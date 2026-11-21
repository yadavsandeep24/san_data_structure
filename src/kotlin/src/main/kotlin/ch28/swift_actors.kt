// Swift actors
// Source: book/part-vii/28-concurrency.md
package ch28.swift_actors
import kotlinx.coroutines.*

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

// No `actor` keyword: confine the state to a one-at-a-time dispatcher.
class SafeCounter {
    private val confined = Dispatchers.Default.limitedParallelism(1)
    private var value = 0
    suspend fun increment() = withContext(confined) { value++ }
    suspend fun get() = withContext(confined) { value }
}
