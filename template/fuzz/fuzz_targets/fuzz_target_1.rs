#![no_main]

use libfuzzer_sys::fuzz_target;
use {{ crate_name }}::add;

// Each input is mapped to a call into the public API. The real value of fuzzing
// comes from feeding *untrusted* input to code that parses or validates it —
// replace this toy example with that. Inputs are widened from u32 so the example
// can't trip the debug-mode overflow check in `add`.
fuzz_target!(|data: (u32, u32)| {
    let (a, b) = data;
    let _ = add(u64::from(a), u64::from(b));
});
