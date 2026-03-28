FROM --platform=linux/amd64 runpod/worker-comfyui:5.5.1-flux1-dev-fp8

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /comfyui/models/loras

ARG HF_TOKEN
RUN curl -L --fail \
    -H "Authorization: Bearer ${HF_TOKEN}" \
    https://huggingface.co/enhanceaiteam/Flux-Uncensored-V2/resolve/main/lora.safetensors \
    -o /comfyui/models/loras/Flux-Uncensored-V2.safetensors

RUN ls -lh /comfyui/models/loras/Flux-Uncensored-V2.safetensors

LABEL version="1.0.38"
