// Q10. PDF Points to Screen Pixels (Signature Field Overlay)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q10_pdf_points_to_screen_pixels

// PDF: points (1/72 inch), origin bottom-left, y grows up. Screen: pixels, origin top-left, y grows down.
data class PageMapping(val pageWidthPt: Double, val pageHeightPt: Double, val viewWidthPx: Double) {
    val scale = viewWidthPx / pageWidthPt               // pixels per point; fit the page to the view's width

    fun pdfToScreen(xPt: Double, yPt: Double): Pair<Double, Double> =
        xPt * scale to (pageHeightPt - yPt) * scale     // flip y, then scale

    fun screenToPdf(xPx: Double, yPx: Double): Pair<Double, Double> =
        xPx / scale to pageHeightPt - yPx / scale       // undo: unscale, then flip
}
