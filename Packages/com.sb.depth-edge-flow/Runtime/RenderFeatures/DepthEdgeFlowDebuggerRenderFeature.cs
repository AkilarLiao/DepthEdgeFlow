/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace SB.DepthEdgeFlow
{
    [DisallowMultipleRendererFeature("DepthEdgeFlowDebuggerRenderFeature")]
    public class DepthEdgeFlowDebuggerRenderFeature : ScriptableRendererFeature
    {
        public override void Create()
        {
            if (!isActive)
                return;
#if UNITY_EDITOR
            RenderPipelineManager.beginContextRendering -= OnBeginContextRendering;
            RenderPipelineManager.beginContextRendering += OnBeginContextRendering;
#endif //UNITY_EDITOR
        }
        public override void AddRenderPasses(ScriptableRenderer renderer, 
            ref RenderingData renderingData) { }
        protected override void Dispose(bool disposing)
        {
#if UNITY_EDITOR
            RenderPipelineManager.beginContextRendering -= OnBeginContextRendering;
#endif //UNITY_EDITOR
        }
#if UNITY_EDITOR
        private void OnBeginContextRendering(ScriptableRenderContext context, List<Camera> cameras)
        {
            if (m_viewDepthEdgeFlowWeight)
                Shader.EnableKeyword(c_viewDepthEdgeFlowKeyword);
            else
                Shader.DisableKeyword(c_viewDepthEdgeFlowKeyword);
        }

        [Tooltip("The view edge flow weight flag.")]
        public bool m_viewDepthEdgeFlowWeight = false;
        
        private const string c_viewDepthEdgeFlowKeyword = "VIEW_DEPTH_EDGE_FLOW";
#endif //UNITY_EDITOR
    }
}