// Worked code (b) — IdempotentPaymentClient
// Source: book/part-ix/39-money-idempotency-reliability.md

typedef Poster = Future<String> Function(
  String path,
  Map<String, String> headers,
  String body,
);

class IdempotentPaymentClient {
  IdempotentPaymentClient(this.post);
  final Poster post;
  final _inFlight = <String, Future<String>>{};

  Future<String> createPayment({
    required String intentId,
    required int amountMinor,
    required String currencyCode,
    required String idempotencyKey,
  }) {
    return _inFlight.putIfAbsent(idempotencyKey, () async {
      try {
        final body =
            '{"intentId":"$intentId","amountMinor":$amountMinor,"currency":"$currencyCode"}';
        return await post('/v1/payments', {'Idempotency-Key': idempotencyKey}, body);
      } finally {
        _inFlight.remove(idempotencyKey);
      }
    });
  }
}
