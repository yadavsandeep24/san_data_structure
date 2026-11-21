// P3: Detect if a race explanation is correct
// Source: solutions/ch28/README.md

enum Verdict { correct, incorrect }

Verdict grade(String explanationId) => switch (explanationId) {
      'A' => Verdict.incorrect, // stack myth
      'B' => Verdict.correct, // if confinement holds
      'C' => Verdict.incorrect, // await interleaving
      'D' => Verdict.correct, // backpressure
      'E' => Verdict.incorrect, // check-then-act
      _ => throw ArgumentError('unknown'),
    };
