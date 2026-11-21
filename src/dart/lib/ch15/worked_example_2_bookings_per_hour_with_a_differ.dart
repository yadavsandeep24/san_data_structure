// Worked example 2: bookings per hour with a difference array
// Source: book/part-iv/15-prefix-sums.md

List<int> bookingsPerHour(int hours, List<List<int>> bookings) {
  final diff = List<int>.filled(hours + 1, 0);
  for (final b in bookings) {
    diff[b[0]] += 1;
    diff[b[1] + 1] -= 1;
  }
  final out = List<int>.filled(hours, 0);
  var running = 0;
  for (var h = 0; h < hours; h++) {
    running += diff[h];
    out[h] = running;
  }
  return out;
}
