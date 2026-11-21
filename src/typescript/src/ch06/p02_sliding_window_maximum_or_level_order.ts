// P2: Sliding window maximum or level-order
// Source: solutions/ch06/README.md
import { Queue } from './implementations';
import { TreeNode } from '../common/nodes';

function maxSlidingWindow(nums: number[], k: number): number[] {
  if (!nums.length || k <= 0) return [];
  const dq: number[] = [];
  let head = 0;
  const res: number[] = [];
  for (let i = 0; i < nums.length; i++) {
    while (head < dq.length && dq[head] <= i - k) head++;
    while (head < dq.length && nums[dq[dq.length - 1]] <= nums[i]) dq.pop();
    dq.push(i);
    if (i >= k - 1) res.push(nums[dq[head]]);
  }
  return res;
}

function levelOrder(root: TreeNode | null): number[][] {
  if (!root) return [];
  const res: number[][] = [];
  const q = new Queue<TreeNode>();
  q.enqueue(root);
  while (q.size) {
    const level: number[] = [];
    const size = q.size;
    for (let i = 0; i < size; i++) {
      const node = q.dequeue()!;
      level.push(node.value);
      if (node.left) q.enqueue(node.left);
      if (node.right) q.enqueue(node.right);
    }
    res.push(level);
  }
  return res;
}

export {};
