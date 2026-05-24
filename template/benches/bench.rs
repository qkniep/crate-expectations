use std::hint::black_box;

use criterion::{Criterion, criterion_group, criterion_main};

fn bench_add(c: &mut Criterion) {
    // `black_box` hides the inputs from the optimizer so it can't const-fold
    // `add(1, 2)` to a literal and measure nothing. Wrap real bench inputs the same way.
    c.bench_function("add", |b| {
        b.iter(|| {{ crate_name }}::add(black_box(1), black_box(2)))
    });
}

criterion_group!(benches, bench_add);
criterion_main!(benches);
