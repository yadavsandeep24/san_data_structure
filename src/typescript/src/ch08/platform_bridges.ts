// Platform bridges
// Source: book/part-iii/08-sets.md

class SelectionTracker {
  private selected = new Set<string>(); // insertion order = tap order

  toggle(id: string): void {
    if (this.selected.has(id)) this.selected.delete(id);
    else this.selected.add(id);
  }

  isSelected(id: string): boolean { return this.selected.has(id); }
  snapshot(): string[] { return [...this.selected]; }
}

export {};
