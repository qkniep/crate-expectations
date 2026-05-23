use criterion::{Criterion, criterion_group, criterion_main};

fn bench_add(c: &mut Criterion) {
    // The crate is referenced by full path rather than a `use` so the import
    // block stays a single line regardless of how the crate name sorts against
    // `criterion` under rustfmt's import grouping.
    c.bench_function("add", |b| b.iter(|| {{ crate_name }}::add(1, 2)));
}

criterion_group!(benches, bench_add);
criterion_main!(benches);
