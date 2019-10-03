Shader "Jared/FireShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_FireHeight ("Fire Height", Range(0, 0.5)) = 0.1
		_FireWidth("Fire Width", Range(0, 1.0)) = 0.1
		_FireIntensity("Fire Intensity", Range(0, 1.0)) = 0.7
    }
    SubShader
    {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

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
			float _FireHeight;
			float _FireWidth;
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

				float finalValue = step(i.uv.y + noiseSample, 0.5 + _FireHeight);// *step(i.uv.x + noiseSample, 0.5 + _FireWidth);

				float redValue = lerp(col.r, (i.uv.y + noiseSample), finalValue);
				float greenValue = lerp(col.g, 0, finalValue);
				float blueValue = lerp(col.b, 0, finalValue);
				float alphaValue = lerp(col.a, (i.uv.y + noiseSample), finalValue);

				col = fixed4(redValue, greenValue, blueValue, col.a);
				
				clip(0 - col.g);

				return col;
            }
            ENDCG
        }
    }
}
