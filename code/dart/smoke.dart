import 'unique_preserve_order.dart';
import 'k_largest.dart';

void main() {
  final u = uniquePreserveOrder(['a', 'b', 'a', 'c']);
  if (u.join(',') != 'a,b,c') {
    throw StateError('unique $u');
  }
  final k = kLargest([3, 1, 5, 2, 4], 3);
  if (k.join(',') != '5,4,3') {
    throw StateError('kLargest $k');
  }
  print('dart');
}
