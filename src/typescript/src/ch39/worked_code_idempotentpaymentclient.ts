// Worked code (b) — IdempotentPaymentClient
// Source: book/part-ix/39-money-idempotency-reliability.md

type Poster = (
  path: string,
  headers: Record<string, string>,
  body: string,
) => Promise<string>;

export class IdempotentPaymentClient {
  private inFlight = new Map<string, Promise<string>>();
  constructor(private post: Poster) {}

  createPayment(args: {
    intentId: string;
    amountMinor: number;
    currencyCode: string;
    idempotencyKey: string;
  }): Promise<string> {
    const { intentId, amountMinor, currencyCode, idempotencyKey } = args;
    const existing = this.inFlight.get(idempotencyKey);
    if (existing) return existing;

    const body = JSON.stringify({ intentId, amountMinor, currency: currencyCode });
    const p = this.post("/v1/payments", { "Idempotency-Key": idempotencyKey }, body).finally(
      () => this.inFlight.delete(idempotencyKey),
    );
    this.inFlight.set(idempotencyKey, p);
    return p;
  }
}

export {};
