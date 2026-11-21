// Q10. PDF Points to Screen Pixels (Signature Field Overlay)
// Source: book/part-viii/37-math-and-number-drills.md

// PDF: points (1/72 inch), origin bottom-left, y grows up. Screen: pixels, origin top-left, y grows down.

class PageMapping {
  final double pageWidthPt, pageHeightPt, viewWidthPx;
  const PageMapping(this.pageWidthPt, this.pageHeightPt, this.viewWidthPx);

  double get scale => viewWidthPx / pageWidthPt;     // pixels per point; fit the page to the view's width

  (double, double) pdfToScreen(double xPt, double yPt) =>
      (xPt * scale, (pageHeightPt - yPt) * scale);   // flip y, then scale

  (double, double) screenToPdf(double xPx, double yPx) =>
      (xPx / scale, pageHeightPt - yPx / scale);     // undo: unscale, then flip
}
