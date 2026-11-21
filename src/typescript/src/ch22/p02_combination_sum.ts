// P2: Combination sum
// Source: solutions/ch22/README.md

function combinationSum(candidates: number[], target: number): number[][] {
  const nums = [...candidates].sort((a, b) => a - b);
  const out: number[][] = [];
  const path: number[] = [];
  const dfs = (start: number, remain: number) => {
    if (remain === 0) {
      out.push([...path]);
      return;
    }
    for (let j = start; j < nums.length; j++) {
      const c = nums[j];
      if (c > remain) break;
      path.push(c);
      dfs(j, remain - c);
      path.pop();
    }
  };
  dfs(0, target);
  return out;
}

export {};
