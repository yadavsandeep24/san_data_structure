// Race conditions from zero
// Source: book/part-vii/28-concurrency.md

// One isolate, no threads — yet an await between read and write loses updates.

var count = 0;
Future<void> inc() async {
  final c = count;
  await Future<void>.value(); // yield — another task can interleave
  count = c + 1;
}
