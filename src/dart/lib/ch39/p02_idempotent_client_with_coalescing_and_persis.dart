// P2: Idempotent client with coalescing and persisted key
// Source: solutions/ch39/README.md
import 'dart:math';

class PaymentIntent {
  PaymentIntent({
    required this.intentId,
    required this.amountMinor,
    required this.currencyCode,
    required this.idempotencyKey,
    this.status = 'pending',
  });
  final String intentId;
  final int amountMinor;
  final String currencyCode;
  final String idempotencyKey;
  String status; // pending | succeeded | failed
}

abstract interface class IntentStore {
  Future<PaymentIntent?> load(String intentId);
  Future<void> save(PaymentIntent intent);
}

typedef Poster = Future<String> Function(Map<String, String> headers, String body);

class IdempotentPaymentClient {
  IdempotentPaymentClient(this.store, this.post);
  final IntentStore store;
  final Poster post;
  final _inFlight = <String, Future<String>>{};

  /// Call once when user confirms Pay.
  Future<PaymentIntent> beginIntent(String intentId, int amountMinor, String currencyCode) async {
    final existing = await store.load(intentId);
    if (existing != null) return existing;
    final intent = PaymentIntent(
      intentId: intentId,
      amountMinor: amountMinor,
      currencyCode: currencyCode,
      idempotencyKey: _uuidV4(),
    );
    await store.save(intent);
    return intent;
  }

  Future<String> createPayment(String intentId) async {
    final intent = await store.load(intentId);
    if (intent == null) throw StateError('missing intent');
    final key = intent.idempotencyKey;
    // Single isolate: no await between lookup and insert, so this is atomic.
    final existing = _inFlight[key];
    if (existing != null) return existing;

    final body =
        '{"intentId":"$intentId","amountMinor":${intent.amountMinor},"currency":"${intent.currencyCode}"}';
    // Future.sync turns a synchronous throw from `post` into a failed future,
    // so the cleanup below always runs *after* the insert, never before it.
    final f = Future.sync(() => post({'Idempotency-Key': key}, body)).then((result) async {
      intent.status = 'succeeded';
      await store.save(intent);
      return result;
    });
    _inFlight[key] = f;
    f.whenComplete(() {
      if (identical(_inFlight[key], f)) _inFlight.remove(key);
    }).ignore();
    return f;
  }
}

/// RFC 4122 v4 UUID from a CSPRNG (dart:core has none; apps usually use `package:uuid`).
String _uuidV4() {
  final rnd = Random.secure();
  final b = List<int>.generate(16, (_) => rnd.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
      '${h.substring(16, 20)}-${h.substring(20)}';
}
