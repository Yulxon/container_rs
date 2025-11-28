#!/usr/bin/env bash

set -e

mkdir -p mountdir
cargo build
clear
sudo ./target/debug/crabcan \
    --debug -u 0 -m ./mountdir/ \
    -c "/bin/testbin"
