/** Shared node types for list and tree problems. Supports both `.value` and `.val`. */
export class ListNode {
  constructor(public value: number, public next: ListNode | null = null) {}
  get val(): number { return this.value; }
  set val(v: number) { this.value = v; }
}

export class TreeNode {
  constructor(public value: number, public left: TreeNode | null = null, public right: TreeNode | null = null) {}
  get val(): number { return this.value; }
  set val(v: number) { this.value = v; }
}
