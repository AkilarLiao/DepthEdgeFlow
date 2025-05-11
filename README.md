# DepthEdgeFlow

> **Geometry-Free. Suit Mobile.**  
> A lightweight screen-space technique for soft edge FX — no tessellation, no geometry, just depth.

---

**DepthEdgeFlow** is a lightweight, screen-space rendering technique  
that simulates soft, dynamic edge effects — such as **shorelines**, **fog boundaries**, and **volumetric transitions** —  
**without any geometry deformation or mesh subdivision**.

It reconstructs world position from scene depth, then applies **noise-driven height offset and flow simulation**  
to create the illusion of natural motion at surface edges — perfect for **mobile and performance-constrained platforms**.

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
