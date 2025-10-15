#!/bin/bash


echo ">> Python toolchain"
uv tool install ruff black pre-commit
uv pip install --system pipx
pipx ensurepath