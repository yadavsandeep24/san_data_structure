// P3: Offline intent queue flush without double-charge
// Source: solutions/ch39/README.md
import { IdempotentPaymentClient, IntentStore, PaymentIntent } from './p02_idempotent_client_with_coalescing_and_persis';

type PendingListStore = { loadAll(): Promise<string[]>; saveAll(ids: string[]): Promise<void> };
type StatusGet = (intentId: string) => Promise<"succeeded" | "failed" | "unknown" | null>;

export class OfflinePaymentQueue {
  private store: IntentStore;
  private listStore: PendingListStore;
  private client: IdempotentPaymentClient;
  private statusGet: StatusGet;

  constructor(
    store: IntentStore,
    listStore: PendingListStore,
    client: IdempotentPaymentClient,
    statusGet: StatusGet,
  ) {
    this.store = store;
    this.listStore = listStore;
    this.client = client;
    this.statusGet = statusGet;
  }

  async enqueue(intent: PaymentIntent): Promise<void> {
    await this.store.save(intent);
    const ids = await this.listStore.loadAll();
    if (!ids.includes(intent.intentId)) {
      await this.listStore.saveAll([...ids, intent.intentId]);
    }
  }

  async flush(): Promise<void> {
    const ids = await this.listStore.loadAll();
    for (const id of ids) {
      const intent = await this.store.load(id);
      if (!intent || intent.status !== "pending") continue;

      const remote = await this.statusGet(id);
      if (remote === "succeeded" || remote === "failed") {
        intent.status = remote;
        await this.store.save(intent);
        continue;
      }

      try {
        await this.client.createPayment(id);
      } catch (e) {
        if ((e as { permanent?: boolean }).permanent) {
          intent.status = "failed";
          await this.store.save(intent);
        }
        // transient → keep pending
      }
    }
  }
}

export {};
