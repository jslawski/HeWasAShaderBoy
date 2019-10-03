Shader "Jared/FireShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_FireSize ("Fire Size", Range(0, 0.5)) = 0.1
		_FireIntensity("Fire Intensity", Range(0, 1.0)) = 0.7
    }
    SubShader
    {
		Tags{ "RenderType" = "Transparent" }

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
				float2 noiseUV : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 noiseUV :TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
			float _FireSize;
			float _FireIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.noiseUV = TRANSFORM_TEX(v.noiseUV, _NoiseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {				
				i.noiseUV.y -= _Time.y;
				
				//Get Noise
				float noiseSample = tex2D(_NoiseTex, i.noiseUV).r * _FireIntensity;
				
				// sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

				float redValue = lerp(col.r, (i.uv.y + noiseSample), step(i.uv.y + noiseSample, 0.5 + _FireSize));

				col = fixed4(redValue, col.g, col.b, col.a);
				
				return col;
            }
            ENDCG
        }
    }
}
