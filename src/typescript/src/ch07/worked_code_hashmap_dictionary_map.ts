// Worked code: HashMap / Dictionary / Map
// Source: book/part-iii/07-hash-tables.md

const ages = new Map<string, number>();
ages.set('ada', 36);
ages.set('linus', 54);
console.log(ages.get('ada'));     // 36
console.log(ages.has('ada'));     // true
ages.delete('linus');

// Map iterates in insertion order
const sections = new Map<string, string[]>();
sections.set('Account', ['Profile', 'Security']);
sections.set('Device', ['Notifications']);
for (const [title, rows] of sections) {
  // render…
}

interface Post { id: string; title: string }   // minimal model for this example

// Plain object: fine for string/symbol keys; prefer Map for frequent add/delete
const byId: Record<string, Post> = Object.create(null);

export {};
