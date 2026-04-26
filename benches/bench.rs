use criterion::{Criterion, criterion_group, criterion_main};
use my_crate::add;

fn bench_add(c: &mut Criterion) {
    c.bench_function("add", |b| b.iter(|| add(1, 2)));
}

criterion_group!(benches, bench_add);
criterion_main!(benches);
