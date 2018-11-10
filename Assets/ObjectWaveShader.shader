Shader "Jared/ObjectWaveShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range(0, 1)) = 0
		_DissolveOutlineColor("Dissolve Outline Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Intensity("Intensity", Range(0, 0.1)) = 0.01
		_Frequency("Frequency", Range(1, 100)) = 20
	}
		SubShader
	{
		Pass
	{
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag

	#include "UnityCG.cginc"

	float4 _LightColor0;

	struct appdata
	{
		float4 vertex : POSITION;
		float4 color : COLOR;
		float3 normal : NORMAL;
		float2 uv : TEXCOORD0;
		float2 dissolveUV : TEXCOORD1;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float2 dissolveUV : TEXCOORD1;
		float4 vertex : SV_POSITION;
		float3 normal : NORMAL;
		float4 color : COLOR;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	sampler2D _DissolveTex;
	float4 _DissolveTex_ST;
	float4 _DissolveOutlineColor;
	half _DissolveAmount;
	float _Intensity;
	float _Frequency;

	

	//This is faster than NormalShader, because we are doing all of our calculations per-vertex rather than per-fragment
	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.normal = normalize(mul(float4(v.normal, 0.0), unity_ObjectToWorld).xyz);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		o.dissolveUV = TRANSFORM_TEX(v.dissolveUV, _DissolveTex);

		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
		
		float4 newVertex = mul(v.vertex, unity_ObjectToWorld) + _Intensity * ((float4(o.normal, 0.0) * sin(o.uv.x * _Frequency + _Time.w)) + (float4(o.normal, 0.0) * sin(o.uv.y * _Frequency + _Time.w)));

		o.vertex = UnityObjectToClipPos(newVertex);
		o.normal = normalize(newVertex);
		float3 diffuse = _LightColor0.rgb * max(0.0, dot(o.normal, lightDirection));
		o.color = float4(diffuse, 1.0);

		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		i.uv.x = i.uv.x + _Time.x;
		i.dissolveUV.x = i.dissolveUV.x - _Time.x;
		
		// sample the dissolve texture.  The texture is greyscale so r == b == g
		float dissolveColor = tex2D(_DissolveTex, i.dissolveUV).r;

		clip(dissolveColor - _DissolveAmount);

		if (dissolveColor - _DissolveAmount < 0.05)
		{
			return _DissolveOutlineColor;
		}
		else
		{
			return tex2D(_MainTex, i.uv);// *i.color;
		}
	}
		ENDCG
	}
	}
}
