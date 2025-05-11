# DepthEdgeFlow

> **Geometry-Free. Suit Mobile.**  
> A lightweight screen-space technique for soft edge FX — no tessellation, no geometry, just depth.

---

## 🧠 What is DepthEdgeFlow?

**DepthEdgeFlow** is a screen-space rendering technique that simulates soft and dynamic edge effects (shorelines, fog, cloudbanks)  
without relying on geometry deformation, vertex displacement, or raymarching.

It reconstructs world position from scene depth, then uses height offsets and noise modulation to alter transparency, distortion, or visibility —  
all in fragment shader.

---

## 💡 Core Idea

At the core, DepthEdgeFlow combines:

1. **Depth Texture → World Space** reconstruction  
2. **Noise-modulated height offsets**  
3. **Pixel-wise alpha / distortion / masking**

---

### ✅ Features
- Geometry-free: no vertex displacement or tessellation
- Mobile-ready: optimized for low-end devices
- Easy to integrate into existing URP pipelines
---

### 🧪 Example Use Cases
- 🌊 Shoreline flow without water mesh deformation  
- ☁️ Fog, gas, or cloudbank edges with soft dynamic motion  
- 🔮 Screen-space "volumetric-lite" effects without raymarching  
- 💡 Projected edge effects based on world height and noise

![Fog effect preview](Images/SeaAndMountainFog.png)
![Sample scene](Images/SampleScene.png)

---
### 📸 Demo Video
[![Watch the demo on YouTube](https://img.youtube.com/vi/_a9CZXP_7Bs/maxresdefault.jpg)](https://www.youtube.com/watch?v=_a9CZXP_7Bs)

---
### 🧩 Compatibility
- Unity URP 12+  
- GLES3, Metal, Vulkan  
- Mobile and Desktop
---
### 📄 License
MIT
