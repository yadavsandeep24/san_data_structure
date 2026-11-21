#!/usr/bin/env bash
# Compile-check the book's source code in every language whose toolchain is installed.
# Usage: ./src/verify.sh [kotlin|swift|dart|typescript ...]   (default: all four)
set -uo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
if [ "$#" -eq 0 ]; then set -- kotlin swift dart typescript; fi
fail=0
ok()   { echo "OK    $1"; }
skip() { echo "SKIP  $1 ($2)"; }
bad()  { echo "FAIL  $1"; fail=1; }

for lang in "$@"; do
  case "$lang" in
    kotlin)
      if command -v gradle >/dev/null 2>&1; then
        (cd "$ROOT/kotlin" && gradle -q compileKotlin) && ok kotlin || bad kotlin
      elif command -v kotlinc >/dev/null 2>&1 && [ -n "${KOTLINX_COROUTINES_JAR:-}" ]; then
        # kotlinc fallback: needs the kotlinx-coroutines-core-jvm jar on the classpath
        out=$(cd "$ROOT/kotlin" && kotlinc -cp "$KOTLINX_COROUTINES_JAR" $(find src/main/kotlin -name '*.kt') -d build/kotlinc-out 2>&1)
        if echo "$out" | grep -q 'error:'; then echo "$out" | grep 'error:'; bad kotlin; else ok kotlin; fi
      else skip kotlin "install gradle, or kotlinc + set KOTLINX_COROUTINES_JAR"; fi ;;
    swift)
      if command -v swift >/dev/null 2>&1; then
        (cd "$ROOT/swift" && swift build) && ok swift || bad swift
      else skip swift "no swift toolchain"; fi ;;
    dart)
      if command -v dart >/dev/null 2>&1; then
        (cd "$ROOT/dart" && dart pub get >/dev/null && dart analyze --no-fatal-warnings lib) && ok dart || bad dart
      else skip dart "no dart"; fi ;;
    typescript)
      if command -v npm >/dev/null 2>&1; then
        (cd "$ROOT/typescript" && { [ -d node_modules ] || npm install --silent; } && npx tsc -p .) && ok typescript || bad typescript
      else skip typescript "no node/npm"; fi ;;
    *) echo "unknown language: $lang (use kotlin, swift, dart or typescript)"; fail=1 ;;
  esac
done
exit $fail
