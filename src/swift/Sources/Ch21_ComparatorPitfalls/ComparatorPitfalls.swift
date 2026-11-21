// Comparator pitfalls
// Source: book/part-vi/21-searching-sorting.md

struct Message { let id: String; let sentAt: Int }   // minimal model for this example

func sortMessages(_ messages: inout [Message]) {
    messages.sort { a, b in
        a.sentAt != b.sentAt ? a.sentAt < b.sentAt : a.id < b.id
    }
}
