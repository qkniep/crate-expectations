# {{ project-name }}

[![CI](https://github.com/{{ gh_username }}/{{ project-name }}/actions/workflows/rust.yml/badge.svg)](https://github.com/{{ gh_username }}/{{ project-name }}/actions/workflows/rust.yml)
{%- if publish %}
[![crates.io](https://img.shields.io/crates/v/{{ project-name }}.svg)](https://crates.io/crates/{{ project-name }})
[![docs.rs](https://img.shields.io/docsrs/{{ project-name }})](https://docs.rs/{{ project-name }})
{%- endif %}
{%- if coverage %}
[![codecov](https://codecov.io/gh/{{ gh_username }}/{{ project-name }}/branch/main/graph/badge.svg)](https://codecov.io/gh/{{ gh_username }}/{{ project-name }})
{%- endif %}
{%- if publish %}
[![license](https://img.shields.io/crates/l/{{ project-name }}.svg)](#license)
{%- else %}
[![license](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue.svg)](#license)
{%- endif %}

{% if description != "" %}{{ description }}{% else %}TODO: Write a description.{% endif %}

## Usage
{% if kind == "binary" %}
{%- if publish %}
```sh
cargo install {{ project-name }}
{{ project-name }}
```
{%- else %}
```sh
cargo build --release
./target/release/{{ project-name }}
```
{%- endif %}
{%- else %}
```rust
use {{ crate_name }}::add;

assert_eq!(add(2, 3), 5);
```
{%- endif %}

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHE) or [MIT license](LICENSE-MIT) at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.
