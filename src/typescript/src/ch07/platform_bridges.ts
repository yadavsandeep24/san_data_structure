// Platform bridges
// Source: book/part-iii/07-hash-tables.md

interface Post { id: string; title: string }   // minimal model for this example

// Normalize API list once
function indexById(posts: Post[]): Map<string, Post> {
  return new Map(posts.map((p) => [p.id, p] as const));
}

export {};
