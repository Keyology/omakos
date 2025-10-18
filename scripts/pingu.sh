#!/bin/bash

# Apple Silicon (M1/M2/M3/M4)
curl -L https://github.com/ali-master/pingu/releases/latest/download/pingu-macos-arm64 -o pingu
chmod +x pingu && sudo mv pingu /opt/homebrew/bin