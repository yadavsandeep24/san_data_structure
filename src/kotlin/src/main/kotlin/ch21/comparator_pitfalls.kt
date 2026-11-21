// Comparator pitfalls
// Source: book/part-vi/21-searching-sorting.md
package ch21.comparator_pitfalls

data class Message(val id: String, val sentAt: Long)   // minimal model for this example

val byTimeThenId = compareBy<Message>({ it.sentAt }, { it.id })
fun sortMessages(messages: MutableList<Message>) {
    messages.sortWith(byTimeThenId)
}
