#!/bin/bash
(cd native/rslib && cargo rustc --release -- -C link-arg=-undefined -C link-arg=dynamic_lookup)
mkdir -p priv
cp ./native/rslib/target/release/librslib.dylib priv/librslib.so

gleam build
