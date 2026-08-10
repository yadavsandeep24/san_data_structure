// Sample: order-preserving unique IDs (Chapter 3)
fun uniquePreserveOrder(ids: List<String>): List<String> {
    val seen = HashSet<String>()
    val out = ArrayList<String>(ids.size)
    for (id in ids) {
        if (seen.add(id)) out.add(id)
    }
    return out
}
