// Runs after every prompt is answered, before files are written to their final
// location. It deletes the parts of the template the chosen archetype and
// capabilities don't need, so the generated project contains only what it uses.
//
// Capability toggles (coverage, benchmarks, ...) are always-set bools, so they
// can be read directly. Prompts that only appear for one archetype (publish,
// no_std, bench_gating) are guarded with `variable::is_set` first.

let kind = variable::get("kind");
let is_lib = kind == "library";
let publish = variable::is_set("publish") && variable::get("publish");

// --- Archetype ------------------------------------------------------------
// A binary keeps both src/lib.rs (the logic, so it stays unit-/doc-testable and
// benchmarkable) and src/main.rs (a thin entry point). A library drops main.rs.
if is_lib {
    file::delete("src/main.rs");
}

// Cross-platform release artifacts only make sense for binaries.
if is_lib {
    file::delete(".github/workflows/release-dist.yml");
}

// --- Publishing -----------------------------------------------------------
// release-plz drives crates.io publishing + changelog; semver checks guard a
// published library's public API. Neither applies to unpublished crates, and
// semver checks are library-only. The PR-title lint only matters because
// release-plz reads squash-merged PR titles, so it's gated the same way.
if !publish {
    file::delete(".github/workflows/release-plz.yml");
    file::delete(".github/workflows/pr-title.yml");
}
if !(is_lib && publish) {
    file::delete(".github/workflows/semver.yml");
}

// --- no_std ---------------------------------------------------------------
let is_no_std = variable::is_set("no_std") && variable::get("no_std");
if !is_no_std {
    file::delete(".github/workflows/no-std.yml");
}

// --- Capabilities ---------------------------------------------------------
if !variable::get("benchmarks") {
    file::delete("benches");
}
// bench_gating only exists when benchmarks were enabled; remove its workflow
// whenever gating is off (or benchmarks were never included at all).
let bench_gating = variable::is_set("bench_gating") && variable::get("bench_gating");
if !bench_gating {
    file::delete(".github/workflows/bench-gating.yml");
}

if !variable::get("fuzzing") {
    file::delete("fuzz");
    file::delete(".github/workflows/fuzz.yml");
}
if !variable::get("coverage") {
    file::delete(".github/workflows/coverage.yml");
}
if !variable::get("msrv") {
    file::delete(".github/workflows/msrv.yml");
}
if !variable::get("miri") {
    file::delete(".github/workflows/miri.yml");
}
if !variable::get("sanitizers") {
    file::delete(".github/workflows/sanitizers.yml");
}
// careful is a 3-way cadence: "off" (no workflow), "weekly" (scheduled sweep on
// main, the default under unsafe_code = forbid) or "pr" (gate every PR, the
// default under deny). The two cadences ship as separate whole files because
// .github isn't Liquid-templated; keep the chosen one and drop the rest.
let careful = variable::get("careful");
if careful == "off" {
    file::delete(".github/workflows/careful.yml");
    file::delete(".github/workflows/careful-pr.yml");
} else if careful == "pr" {
    file::delete(".github/workflows/careful.yml");
    file::rename(".github/workflows/careful-pr.yml", ".github/workflows/careful.yml");
} else {
    // "weekly": careful.yml already holds the scheduled variant.
    file::delete(".github/workflows/careful-pr.yml");
}
if !variable::get("feature_powerset") {
    file::delete(".github/workflows/feature-powerset.yml");
}
if !variable::get("scorecard") {
    file::delete(".github/workflows/scorecard.yml");
}
