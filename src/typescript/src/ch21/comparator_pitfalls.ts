// Comparator pitfalls
// Source: book/part-vi/21-searching-sorting.md

interface Message { id: string; sentAt: number }   // minimal model for this example

const byTimeThenId = (a: Message, b: Message): number =>
  a.sentAt !== b.sentAt
    ? (a.sentAt < b.sentAt ? -1 : 1)
    : (a.id < b.id ? -1 : a.id > b.id ? 1 : 0);
function sortMessages(messages: Message[]): void {
  messages.sort(byTimeThenId);
}

export {};
