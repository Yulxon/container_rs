#!/usr/bin/env bash

set -e

mkdir -p mountdir
RUSTFLAGS="-C prefer-dynamic" cargo build
cp "$(which bash)" ./mountdir/bin/
clear
sudo ./target/debug/crabcan \
    --debug -u 0 -m ./mountdir/ \
    -c "/bin/bash" \
    -a /lib64:/lib64 -a /lib:/lib
