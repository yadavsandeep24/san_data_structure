// Worked: letter combinations (sketch)
// Source: book/part-vi/22-recursion-backtracking.md
package ch22.worked_letter_combinations

fun letterCombinations(digits: String): List<String> {
    if (digits.isEmpty()) return emptyList()
    val map = arrayOf("", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz")
    val out = mutableListOf<String>()
    val path = StringBuilder()
    fun dfs(i: Int) {
        if (i == digits.length) { out += path.toString(); return }
        for (c in map[digits[i] - '0']) {
            path.append(c)
            dfs(i + 1)
            path.deleteCharAt(path.lastIndex)
        }
    }
    dfs(0)
    return out
}
