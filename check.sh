#!/usr/bin/env bash
set -euo pipefail

# Configuration that can be overridden with environment variables
JOBS="${JOBS:-16}"
MAX_FUZZ_TIME="${MAX_FUZZ_TIME:-60}"

# Lint & formatting
cargo +nightly fmt --all -- --check
cargo clippy --workspace --all-targets --all-features -- -D warnings

# Release build
cargo build --release --all-targets

# Tests
cargo nextest run --workspace --exclude="riptide-fuzz" \
    --all-targets --all-features --test-threads="$JOBS"
cargo test --workspace --doc

# Documentation
cargo doc --workspace --no-deps --all-features --document-private-items

# Additional tooling
cargo audit
cargo license
cargo machete

# Run all fuzz tests if cargo-fuzz is installed
if command -v cargo-fuzz &>/dev/null; then
    echo "Running fuzz tests..."

    # Get all fuzz targets
    fuzz_targets=$(cargo +nightly fuzz list --fuzz-dir="riptide/fuzz")
    
    if [[ -z "$fuzz_targets" ]]; then
        echo "No fuzz targets found, skipping"
    else
        for target in $fuzz_targets; do
            echo "Fuzzing target: $target"
            cargo +nightly fuzz run \
                --fuzz-dir="riptide/fuzz" -j"$JOBS" "$target" -- \
                -max_total_time="$MAX_FUZZ_TIME"
        done
    fi
else
    echo "cargo-fuzz not found, skipping fuzz tests"
fi
