use std::io::BufRead;

use pop_launcher::Request;

pub fn read_input(buf: impl BufRead) -> impl Iterator<Item = Request> {
    buf.lines()
        .filter_map(Result::ok)
        .filter_map(|line| serde_json::from_str::<Request>(&line).ok())
}
