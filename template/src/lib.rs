// SPDX-FileCopyrightText: {{ authors }}
// SPDX-License-Identifier: MIT OR Apache-2.0

{% if no_std -%}
// Build without the standard library unless the `std` feature is on. `core` is
// always available; uncomment the `alloc` line if you need heap types (Vec,
// Box, String) without `std`.
#![cfg_attr(not(feature = "std"), no_std)]
// extern crate alloc;
{% endif -%}
{% if publish -%}
// Enable `#[doc(cfg(...))]` feature badges when docs.rs builds with `--cfg docsrs`
// (set in `[package.metadata.docs.rs]`). Gated on `docsrs` so the nightly-only
// `feature(doc_cfg)` attribute never reaches stable builds, where it's inert.
#![cfg_attr(docsrs, feature(doc_cfg))]
{% endif -%}
{% if kind == "library" -%}
#![warn(missing_docs)]
{% endif -%}
#![doc = include_str!("../README.md")]

/// Adds two numbers together.
///
/// # Examples
///
/// ```
/// use {{ crate_name }}::add;
///
/// assert_eq!(add(2, 3), 5);
/// ```
#[must_use]
pub fn add(left: u64, right: u64) -> u64 {
    left + right
}
{%- if publish %}

// Example of an item behind an optional feature. `#[cfg(feature = "foo")]` gates
// compilation; the `doc(cfg(...))` line renders an "Available on crate feature
// `foo` only" badge on docs.rs. Uncomment alongside a `foo` feature in Cargo.toml.
//
// /// Does something that's only available with the `foo` feature enabled.
// #[cfg(feature = "foo")]
// #[cfg_attr(docsrs, doc(cfg(feature = "foo")))]
// pub fn foo() {}
{%- endif %}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(add(2, 2), 4);
    }
}
