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
        [HDR] _ShallowColor("ShallowColor", Color) = (1, 1, 1, 1)
        [HDR] _DeepColor("DeepColor", Color) = (1, 1, 1, 1)
        _PerlinWorldScale("PerlinWorldScale", Range(0.1, 10.0)) = 1.0
        _PerlinNoiseSpeed("PerlinNoiseSpeed", Range(0.0, 10.0)) = 0.5
        _PerlinRnageRatio("PerlinRnageRatio", Range(0.1, 100.0)) = 20.0
        _WaveWorldScale("WaveWorldScale", Range(0.01, 10.0)) = 1.0
        _WaveXMovement("WaveXMovement", Range(0.0, 10.0)) = 0.3
        _WaveZMovement("WaveZMovement", Range(0.0, 10.0)) = 0.3
        _SubWaveWorldScale("SubWaveWorldScale", Range(0.01, 10.0)) = 1.0        
        _SubWaveWeight("SubWaveWeight", Range(0.0, 1.0)) = 0.5
        _RefractionDistortion("RefractionDistortion", Range(0.0, 20.0)) = 0.25
        [NoScaleOffset] _WaveNormalMap("WaveNormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags 
        {  
           "LightMode" = "UniversalForward"
           "Queue" = "Transparent-1"
        }
        Pass
        {   
            HLSLPROGRAM
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
            #pragma multi_compile _ _FORWARD_PLUS
            #include "OceanImpl.hlsl"
            ENDHLSL
        }
        UsePass "Universal Render Pipeline/Simple Lit/DepthOnly"
        UsePass "Universal Render Pipeline/Simple Lit/DepthNormals"
    }
}