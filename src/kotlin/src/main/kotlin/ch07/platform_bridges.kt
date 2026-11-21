// Platform bridges
// Source: book/part-iii/07-hash-tables.md
package ch07.platform_bridges

data class Post(val id: String, val title: String)   // minimal model for this example

// Normalize API list once
fun indexById(posts: List<Post>): Map<String, Post> =
    posts.associateBy { it.id }
