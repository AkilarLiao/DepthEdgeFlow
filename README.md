**DepthEdgeFlow** is a lightweight screen-space rendering technique that simulates soft dynamic edge effects (such as shorelines, fog boundaries, or volumetric transitions) without requiring any geometry deformation.

It reconstructs world position from the scene depth, then applies noise-driven height perturbation and alpha blending to create the illusion of natural flow at object edges — perfect for mobile and resource-constrained platforms.

> ✅ Geometry-free
> ✅ Easy to integrate into existing rendering pipelines

---

### Example Use Cases

- Shoreline edge flow without water mesh deformation  
- Fog or toxic gas volume edges with soft transitions  
- Screen-space "volumetric-lite" visual effects
[![Watch the demo on YouTube](https://img.youtube.com/vi/_a9CZXP_7Bs/maxresdefault.jpg)](https://www.youtube.com/watch?v=_a9CZXP_7Bs)
---

### Compatibility

- Unity URP 12+  
- GLES3, Metal, Vulkan  
- Mobile and Desktop

---

### License

MIT
