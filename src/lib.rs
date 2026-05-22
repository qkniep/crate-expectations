// Copyright (c) Quentin Kniep
// SPDX-License-Identifier: MIT OR Apache-2.0

// Enable `#[doc(cfg(...))]` feature badges when docs.rs builds with `--cfg docsrs`
// (set in `[package.metadata.docs.rs]`). Gated on `docsrs` so the nightly-only
// `feature(doc_cfg)` attribute never reaches stable builds, where it's inert.
#![cfg_attr(docsrs, feature(doc_cfg))]
#![warn(missing_docs)]
#![doc = include_str!("../README.md")]

/// Adds two numbers together.
///
/// # Examples
///
/// ```
/// use my_crate::add;
///
/// assert_eq!(add(2, 3), 5);
/// ```
#[must_use]
pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

// Example of an item behind an optional feature. `#[cfg(feature = "foo")]` gates
// compilation; the `doc(cfg(...))` line renders an "Available on crate feature
// `foo` only" badge on docs.rs. Uncomment alongside a `foo` feature in Cargo.toml.
//
// /// Does something that's only available with the `foo` feature enabled.
// #[cfg(feature = "foo")]
// #[cfg_attr(docsrs, doc(cfg(feature = "foo")))]
// pub fn foo() {}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
