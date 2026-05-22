# Contributing

Thanks for taking the time to contribute!

## Getting started

```sh
git clone https://github.com/qkniep/my-crate
cd my-crate
cargo install just   # or: brew install just — bootstraps the command runner
just setup           # installs the nightly toolchain + dev tools
just check           # runs the full local check suite (see below)
```

The crate builds on stable Rust, but formatting requires the **nightly**
toolchain because `rustfmt.toml` enables unstable options; `just setup`
installs it, along with cargo-nextest, cargo-deny, cargo-machete, and
typos-cli.

## Before opening a pull request

Run `just check`, which mirrors CI:

- `cargo +nightly fmt --all -- --check` — formatting
- `cargo clippy --all-targets --all-features -- -D warnings` — lints
- `cargo build --release --all-targets`
- `cargo nextest run` and `cargo test --doc` — tests
- `cargo doc` — docs build cleanly
- `cargo deny check`, `cargo machete`, `typos` — supply chain & spelling
- `cargo bench --no-run` — benchmarks compile (CI doesn't run them; use `just bench` to run locally)

If any tool is missing, `just check` says so and points you back to `just setup`.
Run `just` with no arguments to list all available recipes.

## Commit messages

This project releases with [release-plz](https://release-plz.dev), which derives
version bumps and the changelog from [Conventional Commits](https://www.conventionalcommits.org).
Prefix commits with `feat:`, `fix:`, `docs:`, `chore:`, etc.

## Licensing

By contributing you agree that your contributions are dual licensed under the
MIT and Apache-2.0 licenses, as described in the [README](README.md).
