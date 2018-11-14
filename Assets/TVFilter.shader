Shader "Jared/TVFilter"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ScreenLuminance("Screen Luminance", Range(0, 1)) = 1.0
		_HiddenTex("Hidden Texture", 2D) = "white" {}
		_ScanLineLuminance("Scan Line Luminance", float) = 0.75
		_Frequency("Frequency", float) = 20
		_Fill("Fill", Range(0, 1)) = 0.8
		_ShiftAmount("Shift Amount", float) = 0.0
		_DistortionHeight("Distortion Height", Range(0, 1)) = 0.5
		_ChromaticAmount("Chromatic Amount", Range(0, 1)) = 0.5
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 lighting : COLOR;
			};

			float4 _LightColor0;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				
				float3 lightDirection = normalize(_WorldSpaceCameraPos.xyz);
				float3 diffuse = _LightColor0.rgb * max(0.0, dot(v.normal, lightDirection));
				
				o.lighting = float4(diffuse, 1.0);
				return o;
			}

			sampler2D _MainTex;
			float _ScreenLuminance;
			sampler2D _HiddenTex;
			float _ScanLineLuminance;
			float _Frequency;
			float _Fill;
			float _ShiftAmount;
			float _DistortionHeight;
			float _ChromaticAmount;
			float _FlickerScreen;
			float _RevealHiddenTex;

			//Random number between 0 and 1.  Taken from Book of Shaders
			float random(float2 input) {
				return frac(sin(dot(input, float2(12.9898,78.233)))* 43758.5453123);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//Cycle entire screen up quickly for a flicker effect 
				if (_FlickerScreen != 0.0) 
				{
					i.uv.y -= _Time.w * 2;
				}
		
				//Shift entire screen
				if (_ShiftAmount != 0.0) 
				{
					i.uv.x -= _ShiftAmount;
				}

				float4 currentColor;
				//Chance to show hidden texture during flicker
				if (_FlickerScreen != 0.0 && _RevealHiddenTex)
				{
					float colR = tex2D(_HiddenTex, float2(i.uv.x + _ChromaticAmount, i.uv.y)).r;
					float colG = tex2D(_HiddenTex, float2(i.uv.x, i.uv.y)).g;
					float colB = tex2D(_HiddenTex, float2(i.uv.x - _ChromaticAmount, i.uv.y)).b;

					currentColor = float4(colR, colG, colB, 1.0);
				}
				else
				{
					currentColor = tex2D(_MainTex, i.uv);
				}


				//Generate distortion bar that travels down the screen
				//Simulates shifting i.uv.y, but saves value to a variable instead so i.uv.y remains unchanged	
				float distortion = i.uv.y + _Time.y;
				if (abs(distortion % 1.0) < _DistortionHeight)
				{
					i.uv.x = i.uv.x + 0.1;

					float colR;
					float colG;
					float colB;

					if (_RevealHiddenTex != 0.0)
					{
						colR = tex2D(_HiddenTex, float2(i.uv.x + _ChromaticAmount, i.uv.y)).r;
						colG = tex2D(_HiddenTex, float2(i.uv.x, i.uv.y)).g;
						colB = tex2D(_HiddenTex, float2(i.uv.x - _ChromaticAmount, i.uv.y)).b;
					}
					else
					{
						colR = tex2D(_MainTex, float2(i.uv.x + _ChromaticAmount, i.uv.y)).r;
						colG = tex2D(_MainTex, float2(i.uv.x, i.uv.y)).g;
						colB = tex2D(_MainTex, float2(i.uv.x - _ChromaticAmount, i.uv.y)).b;
					}

					currentColor = float4(colR, colG, colB, 1);
				}

				//step returns 0 if 2nd value < 1st value
				float stripes = 1 - step(_Fill, random(floor(i.uv.y * _Frequency + _Time.x * _Frequency)));
				float scanLine = 1.0;
				if (stripes == 0.0)
				{
					scanLine = _ScanLineLuminance;
				}

				

				return currentColor * i.lighting * float4(scanLine, scanLine, scanLine, 1) + (currentColor * float4(_ScreenLuminance, _ScreenLuminance, _ScreenLuminance, 1));
			}
			ENDCG
		}
	}
}