/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
#ifndef OCEAN_IMPL_INCLUDED
#define OCEAN_IMPL_INCLUDED

#define _SPECULAR_COLOR
//#define _FOG_FRAGMENT

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.sb.depth-edge-flow/Shaders/DepthEdgeFlow.hlsl"
            
struct VertexInput
{
    float4 positionOS : POSITION; 
};

struct VertexOutput
{
    float3 positionWS       : TEXCOORD0;
    float4 waveNormalUVs    : TEXCOORD1;
    float4 positionSS       : TEXCOORD2;
    float4 positionCS       : SV_POSITION;
};

static const real3x3 c_upPlaneMatrix = real3x3(real3(-1.0, 0.0, 0.0),
	real3(0.0, 0.0, -1.0), real3(0.0, 1.0, 0.0));

TEXTURE2D(_WaveNormalMap); SAMPLER(sampler_WaveNormalMap);
            
CBUFFER_START(UnityPerMaterial)
float _Depth;
float _DepthPow;
float _OffestHeight;
half3 _ShallowColor;
half3 _DeepColor;
float _PerlinWorldScale;
float _PerlinNoiseSpeed;
float _PerlinRnageRatio;
float _WaveWorldScale;
float _WaveXMovement;
float _WaveZMovement;
float _SubWaveWorldScale;
half _SubWaveWeight;
float _RefractionDistortion;
CBUFFER_END

float4 GetWaveNormalUV(in float2 positionWS2D)
{
    float2 waveMovement = frac(float2(_WaveXMovement, _WaveZMovement) * _Time.y);
    float2 baseWorldUV = positionWS2D * _PerlinWorldScale;

    return float4(
        baseWorldUV * _WaveWorldScale + waveMovement,
        baseWorldUV * _SubWaveWorldScale - waveMovement);
}

VertexOutput VertexProgram(VertexInput input)
{
    VertexOutput output;
    output.positionWS = TransformObjectToWorld(input.positionOS.xyz);
    output.positionCS = TransformWorldToHClip(output.positionWS);
    output.positionSS = ComputeScreenPos(output.positionCS);
    output.waveNormalUVs = GetWaveNormalUV(output.positionWS.xz);
    return output;
}

real3 GetWaveNormal(in float4 waveNormalUVs, out half3 normalTS)
{
    half4 mainWaveNormalTS = SAMPLE_TEXTURE2D(_WaveNormalMap, sampler_WaveNormalMap,
        waveNormalUVs.xy);

    half4 subWaveNormalTS = SAMPLE_TEXTURE2D(_WaveNormalMap, sampler_WaveNormalMap,
        waveNormalUVs.zw);

    normalTS = UnpackNormal(lerp(mainWaveNormalTS, subWaveNormalTS, _SubWaveWeight));

    return TransformTangentToWorld(normalTS, c_upPlaneMatrix);
}

void InitializeInputData(VertexOutput input, out InputData inputData, out half3 normalTS)
{
    inputData = (InputData)0;    
    inputData.normalWS = GetWaveNormal(input.waveNormalUVs, normalTS);
    inputData.positionWS = input.positionWS;
    inputData.viewDirectionWS = SafeNormalize(GetWorldSpaceNormalizeViewDir(inputData.positionWS));
    inputData.shadowCoord = float4(0, 0, 0, 0);

    inputData.fogCoord = InitializeInputDataFog(
        float4(inputData.positionWS, 1.0), 0);
    inputData.bakedGI = SampleSH(inputData.normalWS);
    inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
}

half4 FragmentProgram(VertexOutput input) : SV_Target
{   
    InputData inputData;
    half3 normalTS;
    InitializeInputData(input, inputData, normalTS);

    half softEdgeFlowWeight = CalculateSoftEdgeFlowWeight(input.positionCS.xy, input.positionWS,
        float3(_Depth, _DepthPow, _OffestHeight),
        float3(_PerlinWorldScale, _PerlinNoiseSpeed, _PerlinRnageRatio));

    half3 diffuse = lerp(_ShallowColor, _DeepColor, softEdgeFlowWeight);
    half4 specularGloss = half4(1.0, 1.0, 1.0, 1.0);
    half smoothness = 0.5;
    half3 emission = half3(0, 0, 0);
    half alpha = 1.0;

    half3 lightResult = UniversalFragmentBlinnPhong(inputData, diffuse, 
        specularGloss, smoothness, emission, 1.0, normalTS).rgb;
    
    half2 distortionScreenUV = input.positionSS.xy / input.positionSS.w + 
        _RefractionDistortion * softEdgeFlowWeight * inputData.normalWS.xz;
    half3 sceneColor = SampleSceneColor(distortionScreenUV);
    return half4(lerp(sceneColor, lightResult, softEdgeFlowWeight), 1.0);
}

#endif //OCEAN_IMPL_INCLUDED