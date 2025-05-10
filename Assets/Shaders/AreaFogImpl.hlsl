/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
#ifndef AREA_FOG_IMPL_INCLUDED
#define AREA_FOG_IMPL_INCLUDED
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.sb.soft-edge-flow/Shaders/SoftEdgeFlow.hlsl"
            
struct VertexInput
{
    float4 positionOS : POSITION; 
    float2 texcoordOS : TEXCOORD0;
};

struct VertexOutput
{
    float3 positionWS   : TEXCOORD0;
    real2 baseUV        : TEXCOORD1;
    real2 noiseUV       : TEXCOORD2;
    float4 positionCS : SV_POSITION;
};

TEXTURE2D(_MaskMap); SAMPLER(sampler_MaskMap);
            
CBUFFER_START(UnityPerMaterial)
float4 _MaskMap_ST;
float _Depth;
float _DepthPow;
float _OffestHeight;
half3 _Color;
float _PerlinWorldScale;
float _PerlinNoiseSpeed;
float _PerlinRnageRatio;
CBUFFER_END

VertexOutput VertexProgram(VertexInput input)
{
    VertexOutput output;
    output.positionWS = TransformObjectToWorld(input.positionOS.xyz);
    output.positionCS = TransformWorldToHClip(output.positionWS);
    output.baseUV = TRANSFORM_TEX(input.texcoordOS, _MaskMap);
    return output;
}

half4 FragmentProgram(VertexOutput input) : SV_Target
{   
    half softEdgeFlowWeight = CalculateSoftEdgeFlowWeight(input.positionCS.xy, input.positionWS,
        float3(_Depth, _DepthPow, _OffestHeight),
        float3(_PerlinWorldScale, _PerlinNoiseSpeed, _PerlinRnageRatio));
    half maskWeight = SAMPLE_TEXTURE2D(_MaskMap, sampler_MaskMap, input.baseUV).r;
#ifdef VIEW_SOFT_EDGE_FLOW
    return half4(softEdgeFlowWeight, 0.0, 0.0, 1.0);
#else    
    return half4(_Color, softEdgeFlowWeight * maskWeight);

#endif
}

#endif //AREA_FOG_IMPL_INCLUDED