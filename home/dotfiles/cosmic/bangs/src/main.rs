use std::io;

mod input;

fn main() {
    let stdin = io::stdin();
    let requests = input::read_input(stdin.lock());

    for request in requests {}
}
