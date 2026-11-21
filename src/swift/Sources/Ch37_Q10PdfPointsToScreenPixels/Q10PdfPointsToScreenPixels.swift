// Q10. PDF Points to Screen Pixels (Signature Field Overlay)
// Source: book/part-viii/37-math-and-number-drills.md

// PDF: points (1/72 inch), origin bottom-left, y grows up. Screen: pixels, origin top-left, y grows down.
struct PageMapping {
    let pageWidthPt: Double
    let pageHeightPt: Double
    let viewWidthPx: Double
    var scale: Double { viewWidthPx / pageWidthPt }     // pixels per point; fit the page to the view's width

    func pdfToScreen(_ xPt: Double, _ yPt: Double) -> (x: Double, y: Double) {
        (xPt * scale, (pageHeightPt - yPt) * scale)     // flip y, then scale
    }

    func screenToPdf(_ xPx: Double, _ yPx: Double) -> (x: Double, y: Double) {
        (xPx / scale, pageHeightPt - yPx / scale)       // undo: unscale, then flip
    }
}
