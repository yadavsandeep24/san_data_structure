// P3: Detect if a race explanation is correct
// Source: solutions/ch28/README.md

type Verdict = "correct" | "incorrect";

function grade(explanationId: string): Verdict {
  switch (explanationId) {
    case "A": return "incorrect"; // stack myth
    case "B": return "correct";   // if confinement holds
    case "C": return "incorrect"; // await interleaving
    case "D": return "correct";   // backpressure
    case "E": return "incorrect"; // check-then-act
    default: throw new Error("unknown");
  }
}

export {};
