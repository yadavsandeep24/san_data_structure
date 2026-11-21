// P3: Detect if a race explanation is correct
// Source: solutions/ch28/README.md
package ch28.p03_detect_if_a_race_explanation_is_correct
import kotlinx.coroutines.*

enum class Verdict { CORRECT, INCORRECT }

fun grade(explanationId: String): Verdict = when (explanationId) {
    "A" -> Verdict.INCORRECT // stack myth
    "B" -> Verdict.CORRECT   // if confinement holds
    "C" -> Verdict.INCORRECT // await interleaving
    "D" -> Verdict.CORRECT   // backpressure
    "E" -> Verdict.INCORRECT // check-then-act
    else -> throw IllegalArgumentException("unknown")
}
