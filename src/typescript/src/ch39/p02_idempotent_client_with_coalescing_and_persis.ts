// P2: Idempotent client with coalescing and persisted key
// Source: solutions/ch39/README.md

export type PaymentIntent = {
  intentId: string;
  amountMinor: number;
  currencyCode: string;
  idempotencyKey: string;
  status: "pending" | "succeeded" | "failed";
};

export interface IntentStore {
  load(intentId: string): Promise<PaymentIntent | null>;
  save(intent: PaymentIntent): Promise<void>;
}

type Poster = (headers: Record<string, string>, body: string) => Promise<string>;

export class IdempotentPaymentClient {
  private inFlight = new Map<string, Promise<string>>();
  private store: IntentStore;
  private post: Poster;

  constructor(store: IntentStore, post: Poster) {
    this.store = store;
    this.post = post;
  }

  async beginIntent(
    intentId: string,
    amountMinor: number,
    currencyCode: string,
  ): Promise<PaymentIntent> {
    const existing = await this.store.load(intentId);
    if (existing) return existing;
    const intent: PaymentIntent = {
      intentId,
      amountMinor,
      currencyCode,
      idempotencyKey: crypto.randomUUID(),
      status: "pending",
    };
    await this.store.save(intent);
    return intent;
  }

  async createPayment(intentId: string): Promise<string> {
    const intent = await this.store.load(intentId);
    if (!intent) throw new Error("missing intent");
    const key = intent.idempotencyKey;
    const hit = this.inFlight.get(key);
    if (hit) return hit;

    const body = JSON.stringify({
      intentId,
      amountMinor: intent.amountMinor,
      currency: intent.currencyCode,
    });
    // Start inside .then so a synchronous throw from `post` becomes a rejection
    // *after* the insert below — cleanup can never run before the map holds `p`.
    const p = Promise.resolve()
      .then(() => this.post({ "Idempotency-Key": key }, body))
      .then(async (result) => {
        intent.status = "succeeded";
        await this.store.save(intent);
        return result;
      });
    this.inFlight.set(key, p);
    p.finally(() => {
      if (this.inFlight.get(key) === p) this.inFlight.delete(key);
    }).catch(() => {}); // the caller handles the rejection via `p`
    return p;
  }
}

export {};
