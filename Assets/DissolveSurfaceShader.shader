Shader "Jared/DissolveSurfaceShader" {
	Properties {
		_DissolveTexture ("Dissolve Texture", 2D) = "white" {}
		_DissolveAmount ("Dissolve Amount", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Transparent" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _DissolveTexture;

		struct Input {
			float2 uv_DissolveTexture;
		};

		half _DissolveAmount;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// sample the texture.  The texture is greyscale so r == b == g
			float dissolveColor = tex2D (_DissolveTexture, IN.uv_DissolveTexture).r;
			clip(dissolveColor - _DissolveAmount);
			//o.Albedo = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
