use criterion::{Criterion, criterion_group, criterion_main};

fn bench_add(c: &mut Criterion) {
    c.bench_function("add", |b| b.iter(|| {{ crate_name }}::add(1, 2)));
}

criterion_group!(benches, bench_add);
criterion_main!(benches);
