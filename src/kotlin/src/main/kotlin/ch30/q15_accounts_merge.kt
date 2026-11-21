// Q15. Accounts Merge (Union-Find Hard)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q15_accounts_merge

fun accountsMerge(accounts: List<List<String>>): List<List<String>> {
    val parent = HashMap<String, String>()
    val emailName = HashMap<String, String>()
    fun find(x: String): String {
        if (parent[x] != x) parent[x] = find(parent[x]!!)
        return parent[x]!!
    }
    fun union(a: String, b: String) {
        parent[find(a)] = find(b)
    }
    for (acc in accounts) {
        val name = acc[0]
        for (i in 1 until acc.size) {
            val e = acc[i]
            parent.putIfAbsent(e, e)
            emailName[e] = name
            union(acc[1], e)
        }
    }
    val groups = HashMap<String, MutableList<String>>()
    for (e in parent.keys) {
        groups.getOrPut(find(e)) { mutableListOf() }.add(e)
    }
    return groups.map { (root, emails) ->
        emails.sort()
        mutableListOf(emailName[root]!!).also { it.addAll(emails) }
    }
}
