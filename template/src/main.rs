// SPDX-FileCopyrightText: {{ authors }}
// SPDX-License-Identifier: MIT OR Apache-2.0

//! Thin binary entry point. Keep logic in the library (`src/lib.rs`) so it stays
//! unit-testable, doc-testable, and benchmarkable; `main` just wires it up.

use {{ crate_name }}::add;

fn main() {
    println!("2 + 3 = {}", add(2, 3));
}
