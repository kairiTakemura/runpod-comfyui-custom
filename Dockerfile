FROM --platform=linux/amd64 runpod/worker-comfyui:5.5.1-flux1-dev-fp8

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

ARG HF_TOKEN
RUN echo "Token starts with: $(echo $HF_TOKEN | cut -c1-4)" && \
    curl -v \
    -H "Authorization: Bearer ${HF_TOKEN}" \
    "https://huggingface.co/enhanceaiteam/Flux-Uncensored-V2/resolve/main/Flux-Uncensored-V2.safetensors" \
    -o /dev/null 2>&1 | head -50

LABEL version="debug"
