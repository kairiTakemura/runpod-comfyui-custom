FROM --platform=linux/amd64 runpod/worker-comfyui:5.5.1-flux1-dev-fp8

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /comfyui/models/loras

ARG HF_TOKEN
RUN curl -L --fail \
    -H "Authorization: Bearer ${HF_TOKEN}" \
    https://huggingface.co/enhanceaiteam/Flux-Uncensored-V2/resolve/main/lora.safetensors \
    -o /comfyui/models/loras/Flux-Uncensored-V2.safetensors

RUN ls -lh /comfyui/models/loras/Flux-Uncensored-V2.safetensors
# ComfyUI-IP-Adapter-Plus カスタムノード
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git \
    /comfyui/custom_nodes/ComfyUI_IPAdapter_plus

# InsightFace（顔認識）
RUN pip install insightface onnxruntime-gpu

# IP-Adapter FaceIDモデル本体
RUN mkdir -p /comfyui/models/ipadapter && \
    wget -q \
      --header="Authorization: Bearer ${HF_TOKEN}" \
      "https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-portrait_sdxl_unnorm.bin" \
      -O /comfyui/models/ipadapter/ip-adapter-faceid-portrait_sdxl_unnorm.bin

# InsightFace antelopev2（顔検出モデル）
RUN mkdir -p /root/.insightface/models && \
    wget -q \
      "https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip" \
      -O /tmp/antelopev2.zip && \
    unzip -q /tmp/antelopev2.zip -d /root/.insightface/models/ && \
    rm /tmp/antelopev2.zip

# ETN_LoadImageBase64 ノード（base64画像読み込みに必要）
RUN git clone https://github.com/Extraltodeus/ComfyUI-AutomaticCFG.git \
    /comfyui/custom_nodes/ComfyUI-AutomaticCFG || true
    
LABEL version="1.0.38"
