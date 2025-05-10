/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
Shader "SB/Ocean"
{
    Properties
    {
        _Depth("Depth", Range(0.0, 5.0)) = 1.5
        _DepthPow("DepthPow", Range(1.0, 10.0)) = 2
        _OffestHeight("OffestHeight", Range(0.0, 10.0)) = 1        
        _ShallowColor("ShallowColor", Color) = (1, 1, 1, 1)
        _DeepColor("DeepColor", Color) = (1, 1, 1, 1)
        _PerlinWorldScale("PerlinWorldScale", Range(0.1, 10.0)) = 1.0
        _PerlinNoiseSpeed("PerlinNoiseSpeed", Range(0.0, 10.0)) = 0.5
        _PerlinRnageRatio("PerlinRnageRatio", Range(0.1, 100.0)) = 20.0
        _RefractionDistortion("RefractionDistortion", Range(0.0, 20.0)) = 0.25
        [NoScaleOffset] _NormalMap("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags 
        {  
           "Queue" = "Transparent-1"
        }
        Pass
        {   
            HLSLPROGRAM
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
            #include "OceanImpl.hlsl"
            ENDHLSL
        }
    }
}