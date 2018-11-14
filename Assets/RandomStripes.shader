Shader "Jared/RandomStripes"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Frequency("Frequency", float) = 20
		_Fill("Fill", Range(0, 1)) = 0.8
		_ShiftAmount("Shift Amount", Range(0, 1)) = 0.5
		_ShiftHeight("Shift Height", Range(0, 1)) = 0.5
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _Frequency;
			float _Fill;
			float _ShiftAmount;
			float _ShiftHeight;

			//Random number between 0 and 1.  Taken from Book of Shaders
			float random(float2 input) {
				return frac(sin(dot(input, float2(12.9898,78.233)))* 43758.5453123);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				i.uv.y = i.uv.y + _Time.y;
				//i.uv.x = i.uv.x - _Time.x;

				if ((i.uv.y % 1.0) > _ShiftHeight)
				{
					i.uv.x = i.uv.x + _ShiftAmount + _Time.x;
					//return float4(1.0, 0.0, 0.0, 1.0); 
				}
				
				//i.uv.x = i.uv.x - _Time.y;
				//step returns 0 if 2nd value < 1st value
				float stripes = 1 - step(_Fill, random(floor(i.uv.x * _Frequency)));
				return float4(stripes, stripes, stripes, 1);
			}
			ENDCG
		}
	}
}