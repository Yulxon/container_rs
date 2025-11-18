#!/usr/bin/env bash

mkdir -p mountdir
cargo build && clear && ./target/debug/crabcan --debug -u 0 -m ./mountdir/ -c "/usr/bin/env bash"