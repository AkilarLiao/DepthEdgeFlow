/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace SB.SoftEdgeFlow
{
    [DisallowMultipleRendererFeature("SoftEdgeFlowDebuggerRenderFeature")]
    public class SoftEdgeFlowDebuggerRenderFeature : ScriptableRendererFeature
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
        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData) { }
        protected override void Dispose(bool disposing)
        {
#if UNITY_EDITOR
            RenderPipelineManager.beginContextRendering -= OnBeginContextRendering;
#endif //UNITY_EDITOR
        }
#if UNITY_EDITOR
        private void OnBeginContextRendering(ScriptableRenderContext context, List<Camera> cameras)
        {
            if (m_viewSoftEdgeFlowWeight)
                Shader.EnableKeyword(c_viewSoftEdgeFlowKeyword);
            else
                Shader.DisableKeyword(c_viewSoftEdgeFlowKeyword);
        }

        [Tooltip("The view edge flow weight flag.")]
        public bool m_viewSoftEdgeFlowWeight = false;
        
        private const string c_viewSoftEdgeFlowKeyword = "VIEW_SOFT_EDGE_FLOW";
#endif //UNITY_EDITOR
    }
}