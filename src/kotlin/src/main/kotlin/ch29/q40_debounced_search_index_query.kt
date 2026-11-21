// Q40. Debounced Search Index Query
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q40_debounced_search_index_query
import kotlinx.coroutines.*

class DebouncedSearch(
    private val delayMs: Long,
    private val scope: kotlinx.coroutines.CoroutineScope,
    private val search: suspend (String) -> List<String>,
    private val publish: (List<String>) -> Unit,
) {
    private var gen = 0
    private var job: kotlinx.coroutines.Job? = null
    fun onQuery(text: String) {
        val my = ++gen
        job?.cancel()
        job = scope.launch {
            kotlinx.coroutines.delay(delayMs)
            if (my != gen) return@launch
            val result = search(text)
            if (my == gen) publish(result)
        }
    }
}
