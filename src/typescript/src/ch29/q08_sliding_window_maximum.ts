// Q8. Sliding Window Maximum (Scroll Velocity)
// Source: book/part-viii/29-interview-questions-q01-q10.md

function maxSlidingWindow(nums: number[], k: number): number[] {
  const dq: number[] = [];
  let head = 0;
  const out: number[] = [];
  for (let i = 0; i < nums.length; i++) {
    while (head < dq.length && dq[head] <= i - k) head++;
    while (head < dq.length && nums[dq[dq.length - 1]] <= nums[i]) dq.pop();
    dq.push(i);
    if (i >= k - 1) out.push(nums[dq[head]]);
  }
  return out;
}

export {};
