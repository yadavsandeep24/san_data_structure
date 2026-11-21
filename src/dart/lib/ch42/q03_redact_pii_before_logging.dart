// Q3. Redact PII Before Logging (Crash Reports)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

final _email = RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}');
final _phone = RegExp(r'\+?\d[\d\s-]{8,}\d');

String redact(String text) => text
    .replaceAllMapped(_email, (m) {
      final v = m[0]!;
      return '${v[0]}***${v.substring(v.indexOf('@'))}';
    })
    .replaceAllMapped(_phone, (m) {
      final digits = m[0]!.replaceAll(RegExp(r'\D'), '');
      final n = digits.length;
      return '•' * (n - 4 < 0 ? 0 : n - 4) + digits.substring(n < 4 ? 0 : n - 4);
    });
