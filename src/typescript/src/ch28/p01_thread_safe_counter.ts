// P1: Thread-safe counter
// Source: solutions/ch28/README.md

class SerialCounter {
  private value = 0;
  private chain: Promise<void> = Promise.resolve();

  increment(): Promise<number> {
    const run = this.chain.then(() => ++this.value);
    this.chain = run.then(() => {}, () => {});
    return run;
  }

  get(): Promise<number> {
    const run = this.chain.then(() => this.value);
    this.chain = run.then(() => {}, () => {});
    return run;
  }
}

export {};
