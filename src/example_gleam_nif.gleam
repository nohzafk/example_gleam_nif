import gleam/io

@external(erlang, "librs", "truly_random")
pub fn truly_random() -> String

pub fn main() {
  io.println("Hello from example_gleam_nif!")
  io.debug(truly_random())
}
