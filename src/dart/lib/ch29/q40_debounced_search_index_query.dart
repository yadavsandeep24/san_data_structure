// Q40. Debounced Search Index Query
// Source: book/part-viii/29-interview-questions-q31-q40.md
import 'dart:async';

class DebouncedSearch {
  DebouncedSearch(this.delayMs, this.search, this.publish);
  final int delayMs;
  final Future<List<String>> Function(String) search;
  final void Function(List<String>) publish;
  var _gen = 0;
  Timer? _timer;
  void onQuery(String text) {
    final my = ++_gen;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delayMs), () async {
      final result = await search(text);
      if (my == _gen) publish(result);
    });
  }
}
