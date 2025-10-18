# Gemma Model Files

This directory should contain Gemma model files for on-device AI inference.

## Required Models

### For Mobile (Android/iOS):
- **File**: `gemma3-1b-it-int4.task`
- **Format**: MediaPipe Task Bundle (.task)
- **Size**: ~500 MB
- **Download**: https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/Gemma3-1B-IT_multi-prefill-seq_q4_ekv2048.task

### For Web:
- **File**: `gemma3-1b-it-gpu-int8.bin`
- **Format**: Binary (.bin)
- **Size**: ~1 GB
- **Download**: https://www.kaggle.com/models/google/gemma/tfLite/gemma-1.1-2b-it-gpu-int8
  - Or from: https://huggingface.co/google/gemma-2b/tree/main

## How to Download

### Option 1: Manual Download

```bash
# For mobile (.task file)
curl -L -o assets/gemma3-1b-it-int4.task \
  https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/Gemma3-1B-IT_multi-prefill-seq_q4_ekv2048.task

# For web (.bin file) - requires Kaggle API or manual download
# Visit Kaggle link above and download manually
```

### Option 2: App Auto-Download

The app will automatically prompt to download models on first use:
- Mobile: Downloads `.task` file on first Gemma usage
- Web: Requires manual download (browser security restrictions)

## Platform-Specific Notes

### Web Platform
- ✅ Requires GPU backend (CPU not supported)
- ✅ Uses `.bin` format
- ⚠️  Must be downloaded manually and placed in `assets/`
- ⚠️  Large file size (~1 GB) - ensure good internet connection

### Mobile Platform
- ✅ Supports both GPU and CPU backends
- ✅ Uses `.task` format (smaller, optimized)
- ✅ Can auto-download from app
- ✅ ~500 MB size

## Model Versions

Current supported models:
- **Gemma 3 1B IT** - Instruction-tuned, 1 billion parameters
- **Gemma 3 270M IT** - Ultra-compact, 270 million parameters (mobile only)
- **Gemma 3 Nano E2B/E4B** - Multimodal with function calling (mobile only)

## Troubleshooting

**Error: "Model file not found"**
- Ensure the file is in the `assets/` directory
- Verify filename matches exactly (case-sensitive)
- Check file isn't corrupted (compare file size)

**Web: "GPU backend not available"**
- Web platform requires WebGPU support
- Try Chrome/Edge 113+ or Safari 17+
- Check `chrome://gpu` for WebGPU status

**Mobile: "Out of memory"**
- Try CPU backend instead of GPU
- Use smaller model (270M instead of 1B)
- Close other apps to free RAM
