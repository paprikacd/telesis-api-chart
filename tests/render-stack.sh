#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rendered="$(helm template telesis-api . \
  --set image.tag=ab2d5b3 \
  --set secretEnv.existingSecret=telesis-api-env \
  --set firebaseAdmin.existingSecret=telesis-firebase-admin \
  --set components.scheduler.enabled=true \
  --set components.scheduler.image.repository=example.com/telesis/scheduler \
  --set components.runner.enabled=true \
  --set components.runner.image.repository=example.com/telesis/runner \
  --set components.resultprocessor.enabled=true \
  --set components.resultprocessor.image.repository=example.com/telesis/resultprocessor \
  --set components.rollup.enabled=true \
  --set components.rollup.image.repository=example.com/telesis/rollup)"

assert_contains() {
  local needle="$1"
  if ! grep -Fq "$needle" <<<"$rendered"; then
    printf 'expected rendered chart to contain: %s\n' "$needle" >&2
    exit 1
  fi
}

assert_contains "name: telesis-api-scheduler"
assert_contains "name: telesis-api-runner"
assert_contains "name: telesis-api-resultprocessor"
assert_contains "name: telesis-api-rollup"
assert_contains "app.kubernetes.io/component: scheduler"
assert_contains "app.kubernetes.io/component: runner"
assert_contains "app.kubernetes.io/component: resultprocessor"
assert_contains "app.kubernetes.io/component: rollup"
assert_contains "image: \"example.com/telesis/scheduler:ab2d5b3\""
assert_contains "image: \"example.com/telesis/runner:ab2d5b3\""
assert_contains "image: \"example.com/telesis/resultprocessor:ab2d5b3\""
assert_contains "image: \"example.com/telesis/rollup:ab2d5b3\""
assert_contains "value: \"/etc/telesis/firebase-admin-key.json\""
assert_contains "path: \"/health/live\""
assert_contains "port: 8081"
assert_contains "port: 8082"
assert_contains "port: 8083"
assert_contains "port: 9505"
