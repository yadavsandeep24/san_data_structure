// P1: Subsets
// Source: solutions/ch22/README.md

function subsets(nums: number[]): number[][] {
  const out: number[][] = [];
  const path: number[] = [];
  const dfs = (i: number) => {
    if (i === nums.length) {
      out.push([...path]);
      return;
    }
    dfs(i + 1);
    path.push(nums[i]);
    dfs(i + 1);
    path.pop();
  };
  dfs(0);
  return out;
}

export {};
