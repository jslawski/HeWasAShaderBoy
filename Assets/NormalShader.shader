// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Jared/NormalMap"
{
	SubShader 
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _LightColor0;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 color : COLOR;
				float3 normal : NORMAL;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color.xyz = v.normal * 0.5 + 0.5;
				o.normal = mul(float4(v.normal, 0.0), unity_ObjectToWorld).xyz;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float3 normalDirection = normalize(i.normal);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
			 
				float3 diffuse  = _LightColor0.rgb * max(0.0, dot(normalDirection, lightDirection));
				return i.color * float4(diffuse, 1.0);
			}
			ENDCG
		}
	}
}