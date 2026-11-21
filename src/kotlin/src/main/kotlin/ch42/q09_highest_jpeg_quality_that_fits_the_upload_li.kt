// Q9. Highest JPEG Quality That Fits the Upload Limit (Binary Search on the Answer)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
package ch42.q09_highest_jpeg_quality_that_fits_the_upload_li

/** size(q) must not decrease as q rises. Largest q in [lo, hi] with size(q) <= limit, or null. */
fun bestQuality(lo: Int, hi: Int, limit: Long, size: (Int) -> Long): Int? {
    var l = lo
    var h = hi
    var best: Int? = null
    while (l <= h) {
        val mid = l + (h - l) / 2
        if (size(mid) <= limit) { best = mid; l = mid + 1 } else h = mid - 1
    }
    return best
}
