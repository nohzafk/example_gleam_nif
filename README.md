# example_gleam_nif

Example project of Gleam calling Rust code via Rustler, on Apple Silicon MacOS.

Adjust from code example from https://www.jonashietala.se/blog/2024/01/11/exploring_the_gleam_ffi/

## Create Rust project
```sh
mkdir native
cd native
cargo new rslib --lib
cd rslib/
cargo add ruslter
```

Update `Cargo.toml`

```toml
[lib]
crate-type = ["dylib"]
```

`lib.rs`

```rust
#[rustler::nif]
pub fn truly_random() -> i64 {
    4 // Chosen by fair dice roll. Guaranteed to be random.
}

rustler::init!("librs", [truly_random]);
```

# Erlang Code
`src/librs.erl`

```erlang
-module(librs).
-export([truly_random/0, init/0]).
-nifs([truly_random/0]).
-on_load(init/0).

init() ->
    ok = erlang:load_nif("priv/librslib", 0).

truly_random() ->
    erlang:nif_error("NIF library not loaded").
```

`src/example_gleam_nif.gleam`

```Gleam
import gleam/io

@external(erlang, "librs", "truly_random")
pub fn truly_random() -> String

pub fn main() {
  io.println("Hello from example_gleam_nif!")
  io.debug(truly_random())
}
```

# Build

`build.sh`

```shell
#!/bin/bash
(cd native/rslib && cargo rustc --release -- -C link-arg=-undefined -C link-arg=dynamic_lookup)
mkdir -p priv
cp ./native/rslib/target/release/librslib.dylib priv/librslib.so

gleam build
```

# Test
```sh
./build.sh && gleam run
```
