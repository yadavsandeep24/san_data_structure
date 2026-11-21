// Q10. PDF Points to Screen Pixels (Signature Field Overlay)
// Source: book/part-viii/37-math-and-number-drills.md

// PDF: points, origin bottom-left, y up. Screen: pixels, origin top-left, y down.
class PageMapping {
  readonly pageWidthPt: number;
  readonly pageHeightPt: number;
  readonly scale: number;                           // pixels per point

  constructor(pageWidthPt: number, pageHeightPt: number, viewWidthPx: number) {
    this.pageWidthPt = pageWidthPt;
    this.pageHeightPt = pageHeightPt;
    this.scale = viewWidthPx / pageWidthPt;         // fit the page to the view's width
  }

  pdfToScreen(xPt: number, yPt: number): [number, number] {
    return [xPt * this.scale, (this.pageHeightPt - yPt) * this.scale];   // flip y, then scale
  }

  screenToPdf(xPx: number, yPx: number): [number, number] {
    return [xPx / this.scale, this.pageHeightPt - yPx / this.scale];     // unscale, then flip
  }
}

export {};
