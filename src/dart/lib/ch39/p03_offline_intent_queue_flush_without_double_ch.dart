// P3: Offline intent queue flush without double-charge
// Source: solutions/ch39/README.md
import 'p02_idempotent_client_with_coalescing_and_persis.dart' show IdempotentPaymentClient, IntentStore, PaymentIntent;

class PermanentPaymentException implements Exception {
  PermanentPaymentException(this.message);
  final String message;
}

class TransientPaymentException implements Exception {
  TransientPaymentException(this.message);
  final String message;
}

abstract interface class PendingListStore {
  Future<List<String>> loadAll();
  Future<void> saveAll(List<String> ids);
}

class OfflinePaymentQueue {
  OfflinePaymentQueue(this.store, this.listStore, this.client, this.statusGet);
  final IntentStore store;
  final PendingListStore listStore; // loadAll / saveAll of intentIds
  final IdempotentPaymentClient client;
  final Future<String?> Function(String intentId) statusGet; // null if unsupported

  Future<void> enqueue(PaymentIntent intent) async {
    await store.save(intent);
    final ids = await listStore.loadAll();
    if (!ids.contains(intent.intentId)) {
      await listStore.saveAll([...ids, intent.intentId]);
    }
  }

  Future<void> flush() async {
    for (final id in await listStore.loadAll()) {
      final intent = await store.load(id);
      if (intent == null || intent.status != 'pending') continue;

      final remote = await statusGet(id);
      if (remote != null && (remote == 'succeeded' || remote == 'failed')) {
        intent.status = remote;
        await store.save(intent);
        continue;
      }

      try {
        await client.createPayment(id);
      } on PermanentPaymentException {
        intent.status = 'failed';
        await store.save(intent);
      } on TransientPaymentException {
        // leave pending — same key next flush
      }
    }
  }
}
