FROM --platform=linux/amd64 runpod/worker-comfyui:5.5.1-flux1-dev-fp8

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

ARG HF_TOKEN
RUN mkdir -p /comfyui/models/loras && \
    curl -L --fail \
    -H "Authorization: Bearer ${HF_TOKEN}" \
    -o /comfyui/models/loras/Flux-Uncensored-V2.safetensors \
    https://huggingface.co/enhanceaiteam/Flux-Uncensored-V2/resolve/main/Flux-Uncensored-V2.safetensors && \
    ls -lh /comfyui/models/loras/Flux-Uncensored-V2.safetensors

RUN ls -lh /comfyui/models/loras/Flux-Uncensored-V2.safetensors || \
    (echo "❌ LoRA file not found!" && exit 1)

LABEL maintainer="eardori"
LABEL description="RunPod ComfyUI Worker with Flux-Uncensored-V2 LoRA for NSFW image generation"
LABEL version="1.0.38"
