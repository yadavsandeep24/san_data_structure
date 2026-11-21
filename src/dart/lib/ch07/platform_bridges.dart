// Platform bridges
// Source: book/part-iii/07-hash-tables.md

class Post {   // minimal model for this example
  final String id;
  final String title;
  Post(this.id, this.title);
}

// Normalize API list once

Map<String, Post> indexById(List<Post> posts) =>
    {for (final p in posts) p.id: p};
