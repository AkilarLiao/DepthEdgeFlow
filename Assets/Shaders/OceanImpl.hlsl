/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
#ifndef OCEAN_IMPL_INCLUDED
#define OCEAN_IMPL_INCLUDED
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"
#include "Packages/com.sb.soft-edge-flow/Shaders/SoftEdgeFlow.hlsl"
            
struct VertexInput
{
    float4 positionOS : POSITION; 
};

struct VertexOutput
{
    float3 positionWS : TEXCOORD0;
    float4 positionSS : TEXCOORD1;
    float4 positionCS : SV_POSITION;
};

TEXTURE2D(_NormalMap); SAMPLER(sampler_NormalMap);
            
CBUFFER_START(UnityPerMaterial)
float _Depth;
float _DepthPow;
float _OffestHeight;
half3 _ShallowColor;
half3 _DeepColor;
float _PerlinWorldScale;
float _PerlinNoiseSpeed;
float _PerlinRnageRatio;
float _RefractionDistortion;
CBUFFER_END

VertexOutput VertexProgram(VertexInput input)
{
    VertexOutput output;
    output.positionWS = TransformObjectToWorld(input.positionOS.xyz);
    output.positionCS = TransformWorldToHClip(output.positionWS);
    output.positionSS = ComputeScreenPos(output.positionCS);
    return output;
}

//[Tooltip("The refraction distortion intensity")]
//[Range(0.0f, 0.2f)]
//public float m_refractionDistortion = 0.075f;

//half3 GetRefractionColor(in real2 screenUV, in real3 normal, in float depthRatio,
//    in float viewDistance, out half3 grabColor)
//{
//    float distortionFade = 1.0 - clamp(viewDistance * 0.01, 0.0001, 1.0);
//    float3 distortion = normal * _RefractionDistortion * distortionFade * depthRatio;
//
//    grabColor = SAMPLE_TEXTURE2D(_CameraOpaqueTexture,
//        sampler_CameraOpaqueTexture, screenUV + distortion.xz).rgb;
//
//    return lerp(grabColor * _AbsorptionTintValue.xyz * exp(
//        ((-_AbsorptionParams.xyz * depthRatio) / _PlaneDepthParams.y) *
//        _AbsorptionParams.w), grabColor, 1.0 - depthRatio);
//}

//void GetEnvironmentInformation(in float2 positionCS2, in float3 positionWS, in float4 positionSS,
//    in real3 normalWS, out half depth, out half shadowMask, out Light mainLight,
//    out half edgeFoamDepth, out half2 distortionScreenUV, out float3 groundPosition)
//{
//    real2 screenUV = positionSS.xy / positionSS.w;
//    float depthDifference;
//    depth = ProcessDepth(positionCS2, screenUV, positionWS.y, groundPosition, depthDifference);
//
//    distortionScreenUV = screenUV + _WorldParams.w * depth * normalWS.xz;
//
//    float distortionDepthDifference;
//    half distortionDepth = ProcessDepth(positionCS2, distortionScreenUV, positionWS.y,
//        groundPosition, distortionDepthDifference);
//
//    if (groundPosition.y <= positionWS.y)
//    {
//        depth = lerp(distortionDepth, depth, depth);
//        depth = distortionDepth;
//        depthDifference = distortionDepthDifference;
//    }
//
//    edgeFoamDepth = saturate(depthDifference * _EdgeFoamWorldParams.x);
//    edgeFoamDepth = 1.0 - saturate(pow(1.0 - edgeFoamDepth, 5));
//
//#ifdef _MAIN_LIGHT_SHADOWS
//    float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
//#else
//    float4 shadowCoord = float4(0, 0, 0, 0);
//#endif
//
//    mainLight = GetMainLight(shadowCoord, positionWS, half4(1, 1, 1, 1));
//    shadowMask = lerp(1.0, max(0.5, mainLight.distanceAttenuation * mainLight.shadowAttenuation),
//        depth);
//}

//void GetWaterSurfaceData(inout float3 positionWS, out real3 normalWS, out float distanceMask,
//    out half3 normalTS)
//{
//    real3 waveNormal = real3(0, 1, 0);
//#ifdef PROCESS_VALUE_NOISE
//    float2 movement = _Time.y * _ValueNoiseParams.xy;
//    float centerHeight = GetValueNoisePositionHeight(positionWS, movement);
//    waveNormal = GetValueNoiseNormal(positionWS, movement, centerHeight, 1.0);
//    positionWS.y += centerHeight;
//#else
//    float3 wavePositionWS;
//    SampleWaves(positionWS.xz * _WorldParams.x, saturate((0.0 * 0.1 + 0.05)),
//        _WaveControlParams.x, _WaveControlParams.y, _WaveControlParams.z, wavePositionWS, waveNormal);
//    positionWS += wavePositionWS;
//#endif
//    distanceMask = saturate(exp(-_WorldParams.y * length(positionWS - _WorldSpaceCameraPos)));
//    positionWS.y -= _DepthParams.z * distanceMask;
//    normalWS = lerp(real3(0, 1, 0), waveNormal, pow(distanceMask, 2.5));
//    normalWS.y *= _SmoothNormalFactor;
//    ApplyNormalMap(positionWS, distanceMask, normalWS, normalTS);
//}
//NormalWS applya normal TS
half4 FragmentProgram(VertexOutput input) : SV_Target
{   
    //real3 normalWS = real3(0.0, 1.0, 0.0);

    half softEdgeFlowWeight = CalculateSoftEdgeFlowWeight(input.positionCS.xy, input.positionWS,
        float3(_Depth, _DepthPow, _OffestHeight),
        float3(_PerlinWorldScale, _PerlinNoiseSpeed, _PerlinRnageRatio));

    half3 sceneColor = SampleSceneColor(input.positionSS.xy / input.positionSS.w);    
    half3 destShallowColor = lerp(sceneColor, _ShallowColor, softEdgeFlowWeight);
    return half4(lerp(destShallowColor, _DeepColor, softEdgeFlowWeight), 1.0);
}

#endif //OCEAN_IMPL_INCLUDED