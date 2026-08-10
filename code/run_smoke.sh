#!/usr/bin/env bash
# Smoke-check sample sketches. Skips languages whose toolchain is missing.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
pass=0
skip=0

ok() { echo "OK  $1"; pass=$((pass + 1)); }
skip_msg() { echo "SKIP $1 ($2)"; skip=$((skip + 1)); }
fail() { echo "FAIL $1"; exit 1; }

if command -v node >/dev/null 2>&1; then
  node "$ROOT/typescript/smoke.mjs" >/dev/null && ok "typescript" || fail "typescript"
else
  skip_msg "typescript" "no node"
fi

if command -v dart >/dev/null 2>&1; then
  dart "$ROOT/dart/smoke.dart" >/dev/null && ok "dart" || fail "dart"
else
  skip_msg "dart" "no dart"
fi

if command -v swift >/dev/null 2>&1; then
  swift "$ROOT/swift/smoke.swift" >/dev/null && ok "swift" || fail "swift"
else
  skip_msg "swift" "no swift"
fi

if command -v kotlinc >/dev/null 2>&1 && command -v java >/dev/null 2>&1; then
  tmp="$(mktemp -d)"
  kotlinc "$ROOT/kotlin/UniquePreserveOrder.kt" "$ROOT/kotlin/TopK.kt" "$ROOT/kotlin/Smoke.kt" -include-runtime -d "$tmp/smoke.jar"
  java -jar "$tmp/smoke.jar" >/dev/null && ok "kotlin" || fail "kotlin"
  rm -rf "$tmp"
else
  skip_msg "kotlin" "no kotlinc/java"
fi

echo "Done: $pass passed, $skip skipped"
