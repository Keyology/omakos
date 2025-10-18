#!/bin/bash


echo ">> Python toolchain"
uv tool install ruff 
uv tool install black 
uv tool install pre-commit