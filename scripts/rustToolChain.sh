#!/bin/bash


echo ">> Rust toolchain"
rustup-init -y
source "$HOME/.cargo/env"
rustup default stable
