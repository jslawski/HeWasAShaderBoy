// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Jared/SilhouetteShader"
{
	Properties
	{
		_Color("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex("Texture", 2D) = "white" {}
		_CheckeredTex("Checkered Texture", 2D) = "white" {}
		_SilColor("Silhouette Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	//Anything in CGINCLUDE is included in each pass for this shader file
	CGINCLUDE
	#include "UnityCG.cginc"

	struct appdata {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float2 uv : TEXCOORD0;
	};

	struct v2f {
		float4 pos : POSITION;
		float4 color : COLOR;
		float2 uv : TEXCOORD0;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	sampler2D _CheckeredTex;
	float4 _CheckeredTex_ST;
	float4 _SilColor;
	float4 _Color;

	v2f vert(appdata v) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		//UNITY_MATRIX_IT_MV = Inverse transpose of the model*view matrix.  Look into why we do this
		float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
		o.color = _SilColor;
		return o;
	}
	ENDCG

		SubShader{
			//Pass 1: Ensure that the objects vertices are all rendered on top of everything.
			//		  Set the color of all of the fragments as the Silhouette Color.  Apply checkered texture.
			Pass{
				Cull Off
				ZWrite Off
				ZTest Always

				CGPROGRAM
				#pragma vertex vert //Remember we're using the vert function from the CGINCLUDE section here
				#pragma fragment frag

				half4 frag(v2f i) : COLOR {
					clip(tex2D(_CheckeredTex, i.uv).r - 0.95);
					return i.color;
				}
				ENDCG
			}

			//Pass 2: Apply texture to all of the fragments that are higher (closer to screen) in the depth buffer
			//		  by re-enabling ZTesting and ZWriting to the depth buffer
			Pass {
				//Cull Back
				ZWrite On
				ZTest LEqual
		
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				half4 frag(v2f i) : COLOR {
					return tex2D(_MainTex, i.uv) * _Color;
				}
				ENDCG
			}
		}
}
