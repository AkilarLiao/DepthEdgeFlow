/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
Shader "SB/AreaFog"
{
    Properties
    {
        _Depth("Depth", Range(0.0, 5.0)) = 1.5
        _DepthPow("DepthPow", Range(1.0, 10.0)) = 2
        _OffestHeight("OffestHeight", Range(0.0, 10.0)) = 1
        _Color("Color", Color) = (1, 1, 1, 1)
        _PerlinWorldScale("PerlinWorldScale", Range(0.1, 10.0)) = 1.0
        _PerlinNoiseSpeed("PerlinNoiseSpeed", Range(0.0, 10.0)) = 0.5
        _PerlinRnageRatio("PerlinRnageRatio", Range(0.1, 100.0)) = 20.0
        [NoScaleOffset]_MaskMap("Mask Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        {            
           "RenderType" = "Transparent"
           "Queue" = "Transparent"
        }
        Pass
        {            
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            HLSLPROGRAM

            //VIEW_SOFT_EDGE_FLOW

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            #pragma multi_compile_fragment _ VIEW_SOFT_EDGE_FLOW
            #include "AreaFogImpl.hlsl"
            ENDHLSL
        }
    }
}