// Comparator pitfalls
// Source: book/part-vi/21-searching-sorting.md

class Message {   // minimal model for this example
  final String id;
  final int sentAt;
  Message(this.id, this.sentAt);
}

int byTimeThenId(Message a, Message b) {
  final t = a.sentAt.compareTo(b.sentAt);
  return t != 0 ? t : a.id.compareTo(b.id);
}

void sortMessages(List<Message> messages) {
  messages.sort(byTimeThenId);
}
