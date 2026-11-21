// P2: Combination sum
// Source: solutions/ch22/README.md

List<List<int>> combinationSum(List<int> candidates, int target) {
  final nums = [...candidates]..sort();
  final out = <List<int>>[];
  final path = <int>[];
  void dfs(int start, int remain) {
    if (remain == 0) {
      out.add(List<int>.from(path));
      return;
    }
    for (var j = start; j < nums.length; j++) {
      final c = nums[j];
      if (c > remain) break;
      path.add(c);
      dfs(j, remain - c);
      path.removeLast();
    }
  }
  dfs(0, target);
  return out;
}
