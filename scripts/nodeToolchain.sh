#!/bin/bash


echo ">> Node toolchain"
# prefer fnm if you want versions:
# brew install fnm && eval "$(fnm env)" && fnm install --lts && fnm default lts
npm i -g pnpm yarn eslint prettier zx