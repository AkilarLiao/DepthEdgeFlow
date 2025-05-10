/// <summary>
/// Author: SmallBurger Inc
/// Date: 2025/05/09
/// Desc:
/// </summary>
#ifndef SOFT_EDGE_FLOW_INCLUDED
#define SOFT_EDGE_FLOW_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

static const float c_RingSegment = 17.0;
static const float c_RingSize = c_RingSegment * c_RingSegment; //near 7 * 41
static const float c_PointCount = 41.0;

float3 Mod289(float3 x)
{
    return x - floor(x * (1.0 / c_RingSize)) * c_RingSize;
}

float2 Mod289(float2 x)
{
    return x - floor(x * (1.0 / c_RingSize)) * c_RingSize;
}

float3 Permute(float3 x)
{
    return Mod289(((x * 34.0) + 1.0) * x);
}

float Snoise(float2 v)
{
    const float4 C = float4(
        0.211324865405187,
		0.366025403784439,
		-0.577350269189626,
		1.0 / c_PointCount);

	// First corner
    float2 i = floor(v + dot(v, C.yy));
    float2 x0 = v - i + dot(i, C.xx);

	// Other corners
    float2 i1;
	i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
	float4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

	// Permutations
    // Avoid truncation effects in permutation
    i = Mod289(i);
    float3 p = Permute(Permute(i.y + float3(0.0, i1.y, 1.0))
		+ i.x + float3(0.0, i1.x, 1.0));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
    m = m * m;
    m = m * m;

	// Gradients: 41 points uniformly over a line, mapped onto a diamond.
	// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

    float3 x = 2.0 * frac(p * C.www) - 1.0;
    float3 h = abs(x) - 0.5;
    float3 ox = floor(x + 0.5);
    float3 a0 = x - ox;

	// Normalise gradients implicitly by scaling m
	// Approximation of: m *= inversesqrt( a0*a0 + h*h );
    m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);

	// Compute final noise value at P
    float3 g;
    g.x = a0.x * x0.x + h.x * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;

	//return 130.0 * dot(m, g);
    return dot(m, g);
}

float3 ComputeWorldSpacePositionFromDepth(float2 positionCS2)
{
    //float2 destPositionCS = positionCS;
#if UNITY_REVERSED_Z
    float depth = LoadSceneDepth(positionCS2.xy);
#else
    // Adjust z to match NDC for OpenGL
    float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(positionCS2.xy));
#endif
    float2 positionSS = positionCS2 * _ScreenSize.zw;
    return ComputeWorldSpacePosition(positionSS, depth, UNITY_MATRIX_I_VP);
}

half GetSoftEdgeFlowWeight(float2 positionCS2, float surfaceHeight, float depthRange,
    float depthPow)
{
    float3 groundPosition = ComputeWorldSpacePositionFromDepth(positionCS2);
    float depthRatio = saturate((surfaceHeight - groundPosition.y) / depthRange);
    depthRatio = 1.0 - pow(1.0 - depthRatio, depthPow);
    return depthRatio;
}

half CalculateSoftEdgeFlowWeight(float2 positionCS2, float3 positionWS,    
    //x:range, y:power, z:offest surfaceHeight
    float3 depthParams,
    //x:worldScale, noiseSpeed, rangeRatio
    float3 perlinNoiseParams)
{
    float2 offestXZ = positionWS.xz * perlinNoiseParams.x + _Time.y * perlinNoiseParams.y;
    float surfaceHeight = positionWS.y + Snoise(offestXZ) * perlinNoiseParams.z - depthParams.z;
    return GetSoftEdgeFlowWeight(positionCS2, surfaceHeight, depthParams.x, depthParams.y);    
}

#endif//UTILITY_FUNCTIONS_INCLUDED