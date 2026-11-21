// Serial queues
// Source: book/part-vii/28-concurrency.md

export class SerialQueue {
  private chain: Promise<void> = Promise.resolve();
  enqueue<T>(fn: () => Promise<T> | T): Promise<T> {
    const run = this.chain.then(() => fn());
    this.chain = run.then(() => {}, () => {});
    return run;
  }
}

export {};
