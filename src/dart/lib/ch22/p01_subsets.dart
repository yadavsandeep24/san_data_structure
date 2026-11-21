// P1: Subsets
// Source: solutions/ch22/README.md

List<List<int>> subsets(List<int> nums) {
  final out = <List<int>>[];
  final path = <int>[];
  void dfs(int i) {
    if (i == nums.length) {
      out.add(List<int>.from(path));
      return;
    }
    dfs(i + 1);
    path.add(nums[i]);
    dfs(i + 1);
    path.removeLast();
  }
  dfs(0);
  return out;
}
