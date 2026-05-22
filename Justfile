# Test threads for nextest. Override with `just jobs=8 test` or JOBS=8.
jobs := env_var_or_default("JOBS", "16")

# List available recipes.
default:
    @just --list

# `just` itself isn't here — bootstrap it with `cargo install just` or `brew install just`.
# Install the dev tools `just check` needs (run once after cloning).
setup:
    rustup toolchain install nightly --component rustfmt
    cargo install --locked cargo-nextest cargo-deny cargo-machete typos-cli

# Full local check suite (mirrors CI).
check: _check-tools fmt clippy build test doc deny machete typos bench-build

# Check formatting (nightly rustfmt).
fmt:
    cargo +nightly fmt --all -- --check

# Lint with clippy, denying warnings.
clippy:
    cargo clippy --all-targets --all-features -- -D warnings

# Build all targets in release mode.
build:
    cargo build --release --all-targets --locked

# Run unit, integration, and doc tests.
test:
    cargo nextest run --all-targets --all-features --locked --test-threads={{jobs}}
    cargo test --doc --all-features --locked

# Build the documentation, denying warnings (mirrors CI and docs.rs).
doc:
    RUSTDOCFLAGS="-D warnings" cargo doc --no-deps --all-features --document-private-items --locked

# Check the dependency tree (advisories, licenses, bans, sources).
deny:
    cargo deny check

# Find unused dependencies.
machete:
    cargo machete

# Check spelling.
typos:
    typos

# Compile-check benchmarks — what `just check` runs (CI never runs benches).
bench-build:
    cargo bench --no-run --locked

# Run benchmarks (criterion). For local profiling only — not part of `just check`.
bench:
    cargo bench

# List unfinished work: todo!/unimplemented! macros and TODO-style comments.
todo:
    -rg 'todo!\(\)|unimplemented!\(\)' --iglob='!Justfile'
    -rg 'TODO|XXX|HACK|PERF|FIXME|BUG' --iglob='!Justfile'

# Report any tools `just check` needs that aren't installed (hidden helper).
_check-tools:
    #!/usr/bin/env bash
    set -euo pipefail
    missing=()
    command -v cargo-nextest >/dev/null 2>&1 || missing+=("cargo-nextest")
    command -v cargo-deny    >/dev/null 2>&1 || missing+=("cargo-deny")
    command -v cargo-machete >/dev/null 2>&1 || missing+=("cargo-machete")
    command -v typos         >/dev/null 2>&1 || missing+=("typos-cli")
    cargo +nightly fmt --version >/dev/null 2>&1 || missing+=("nightly rustfmt")
    if [ ${#missing[@]} -ne 0 ]; then
        echo "Missing tools: ${missing[*]}" >&2
        echo "Run \`just setup\` to install them." >&2
        exit 1
    fi
