#!/bin/bash


echo ">> AI: MLX / PyTorch-MPS / Transformers"
# MLX
uv pip install mlx mlx-lm
# pytorch nightly or stable cpu+mps:
pip3 install --upgrade pip
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip3 install transformers datasets peft accelerate bitsandbytes --no-build-isolation || true
