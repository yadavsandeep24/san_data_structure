// Q4. Find the Bugs in This Function (Recent Completed Envelopes)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

struct Envelope { let id: String; let status: String; let completedAt: Int64? }

func recentCompleted(_ all: [Envelope], _ n: Int) -> [Envelope] {
    precondition(n >= 0, "n must be non-negative, was \(n)")
    return all.enumerated()
        .compactMap { (i, e) -> (Int, Int64, Envelope)? in
            guard e.status.lowercased() == "completed", let t = e.completedAt else { return nil }
            return (i, t, e)
        }
        .sorted { $0.1 != $1.1 ? $0.1 > $1.1 : $0.0 < $1.0 }   // newest first; ties keep input order
        .prefix(n)
        .map { $0.2 }
}
