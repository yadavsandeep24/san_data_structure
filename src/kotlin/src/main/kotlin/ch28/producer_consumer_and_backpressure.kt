// Producer-consumer and backpressure (network)
// Source: book/part-vii/28-concurrency.md
package ch28.producer_consumer_and_backpressure
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.*

// Sketch: capacity 16
val channel = kotlinx.coroutines.channels.Channel<ByteArray>(16)
// producer: suspends when the channel is full (backpressure)
suspend fun produce(chunk: ByteArray) {
    channel.send(chunk)
}

// consumer
suspend fun consume(parse: (ByteArray) -> Unit) {
    for (chunk in channel) parse(chunk)
}
