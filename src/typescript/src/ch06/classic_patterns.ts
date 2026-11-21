// Classic patterns
// Source: book/part-ii/06-queues-deques.md

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

export {};
