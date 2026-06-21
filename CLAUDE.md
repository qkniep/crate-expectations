# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is **Crate Expectations**, a [cargo-generate](https://cargo-generate.github.io)
template for new Rust projects — *not* a buildable crate. The files under
`template/` contain Liquid placeholders (`{{ ... }}`, `{% ... %}`) and do not
compile on their own. Running `cargo build` at the repo root does nothing useful;
the unit of work is "generate a project, then check that generated project."

One source generates one of two **archetypes** (a `library` or a `binary`), and a
set of **capability toggles** (coverage, fuzzing, Miri, sanitizers, …) that are
*orthogonal* to the archetype — any capability can apply to either archetype.
Preserve that orthogonality when editing: don't couple a capability's behavior to
`kind` unless it genuinely only makes sense for one (e.g. `release-dist` is
binary-only, `semver` is published-library-only).

## Repository layout (two layers)

- **Repo root** — the template's *own* infrastructure: `README.md` (the canonical
  reference for every prompt — keep it in sync when adding/changing prompts),
  `.github/workflows/template-ci.yml` (the self-test, see below), and the dual
  licenses. None of this is emitted into generated projects.
- **`template/`** — the project that gets generated. `cargo-generate.toml` defines
  the prompts; `pre-script.rhai` prunes unused files; everything else is the
  scaffold (`Cargo.toml`, `src/`, `Justfile`, `.github/workflows/`, docs).

## The two templating mechanisms (important)

cargo-generate applies Liquid substitution **only** to the paths listed in
`template/cargo-generate.toml`'s `include` array (`Cargo.toml`, `src/**`,
`Justfile`, docs, …). Everything else — **notably all of `.github/`** — is copied
**verbatim**. This is deliberate: it stops the Liquid engine from mangling GitHub
Actions' own `${{ ... }}` expression syntax.

Consequence: **capability-specific CI behavior is expressed as whole workflow
files, added or removed by `pre-script.rhai`, not as inline `{% if %}` inside
YAML.** When a capability needs a CI change:
- If the file *is* Liquid-templated (e.g. `Justfile`, `Cargo.toml`), use
  `{% if cap %}` blocks inline.
- If it's a workflow under `.github/`, ship a whole `cap.yml` and delete it in
  `pre-script.rhai` when the toggle is off. For mutually-exclusive variants, ship
  multiple files and `file::rename` the chosen one into place. Existing examples:
  - `careful.yml` (weekly) vs `careful-pr.yml` (per-PR) — a 3-way `off|weekly|pr`
    cadence; keep one, rename, or delete both.
  - `release-plz.yml` (built-in `GITHUB_TOKEN`) vs `release-plz-app.yml` (GitHub
    App token — the default token can't trigger downstream workflows). A binary
    always takes the App variant (its release tag must fire `release-dist.yml`); a
    library defaults to `GITHUB_TOKEN` but `release_app_token` opts into the App
    variant so CI can gate the release PR under branch protection.

`pre-script.rhai` reads always-set capability bools directly via
`variable::get(...)`; archetype-conditional prompts (`publish`, `no_std`,
`bench_gating`) must be guarded with `variable::is_set(...)` first because they
don't exist for every archetype.

## Adding or changing a prompt — checklist

1. Add the placeholder to `template/cargo-generate.toml` (use a `[conditional...]`
   block if it's archetype-specific).
2. Wire its effect: Liquid `{% if %}` in `include`d files, and/or file
   add/remove/rename logic in `pre-script.rhai`.
3. Document it in the root `README.md` prompt table.
4. If it introduces a meaningfully new combination, add a matrix entry to
   `template-ci.yml` so it's proven green.

## Development workflow

There is no build/test command at the repo root. The loop is:

```sh
# Generate a scratch project from the local template (no commit needed):
cargo generate --path ./template --name scratch --silent -d kind=binary
cd scratch
just check          # runs the full core suite — must be green
actionlint          # lint the generated workflows (run from the generated project)
```

Pass `-d key=value` for each prompt you want to override; `--silent` takes
defaults for the rest. Useful combinations to exercise (these are the
`template-ci.yml` matrix):

- `-d kind=library -d publish=true` / `-d publish=false`
- `-d kind=binary -d publish=true` / `-d publish=false`
- the "kitchen sink": `-d kind=library -d no_std=true -d unsafe_policy=deny -d miri=true -d sanitizers=true -d careful=pr -d feature_powerset=true -d scorecard=true -d fuzzing=true -d bench_gating=true`

`just check` inside a generated project mirrors core CI: nightly `cargo fmt`,
clippy (`-D warnings`), nextest + doctests, release build, `cargo doc`
(`-D warnings`), `cargo deny`, `cargo machete`, `typos`, and (if benchmarks)
`cargo bench --no-run`. The generated project needs dev tools installed — run
`just setup` in it, or have nextest/deny/machete/typos/nightly-rustfmt on PATH
(`just check`'s `_check-tools` helper reports what's missing).

Note: cargo-generate does **not** emit a `Cargo.lock`. The `Justfile`'s hidden
`_lockfile` recipe runs `cargo generate-lockfile` on first use so the `--locked`
recipes work on a fresh tree; in a real generated project you commit the lock
before the first push.

## CI: how the template proves itself

`template-ci.yml` is the quality gate. Since `template/` can't be compiled in
place, the workflow **generates a representative matrix of archetype/capability
combinations and runs the full `just check` (plus `actionlint`) on each**, with a
separate job that builds a generated `no_std` crate for a bare-metal target. If
any advertised combination stops producing a green project, this job goes red —
so when you change templating logic, mirror it into the matrix.

## Conventions in generated projects

- GitHub Actions are **SHA-pinned** with a **full-version** `# vX.Y.Z` trailing
  comment (the most specific tag the SHA carries, e.g. `# v2.9` when an action
  only tags to minor). This matters: Dependabot only reliably bumps a SHA pin
  whose comment is a *full* version — a bare `# vX` major comment is left frozen,
  because its rewriter rebuilds the comment from the new SHA's most-specific tag
  and only fires when the old comment ends with a real tag. The generated
  `just unpin` recipe reverts each pin to a moving tag (`vN`, or `v0.N` for 0.x),
  falling back to the comment's exact version when the action ships no moving
  tag. Keep new `uses:` entries SHA-pinned with a full-version comment.
- Least-privilege tokens: workflows declare read-only `permissions:` at the top
  and scope up per-job only where a write is needed.
- A binary archetype keeps **both** `src/lib.rs` (the logic — stays unit/doc-
  testable and benchmarkable) and a thin `src/main.rs`; a library drops main.rs.
- `unsafe_code` policy (`forbid`/`deny`) is set in `Cargo.toml`'s `[lints.rust]`
  and drives the default `careful` cadence.
