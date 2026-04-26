#!/usr/bin/env bash
set -euo pipefail

JOBS="${JOBS:-16}"

cargo +nightly fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings

cargo build --release --all-targets

cargo nextest run --all-targets --all-features --test-threads="$JOBS"
cargo test --doc

cargo doc --no-deps --all-features --document-private-items

cargo audit
cargo license
cargo machete

cargo bench
