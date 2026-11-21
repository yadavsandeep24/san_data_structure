// P3: Phone letter combinations
// Source: solutions/ch22/README.md
package ch22.p03_phone_letter_combinations

fun letterCombinations(digits: String): List<String> {
    if (digits.isEmpty()) return emptyList()
    val map = arrayOf("", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz")
    val out = mutableListOf<String>()
    val path = StringBuilder()
    fun dfs(i: Int) {
        if (i == digits.length) {
            out += path.toString()
            return
        }
        for (c in map[digits[i] - '0']) {
            path.append(c)
            dfs(i + 1)
            path.deleteCharAt(path.lastIndex)
        }
    }
    dfs(0)
    return out
}
