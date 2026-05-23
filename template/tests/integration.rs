use {{ crate_name }}::add;

#[test]
fn integration_test() {
    assert_eq!(add(40, 2), 42);
}
