Shader "Custom/Suntail_Surface2"
{
	Properties
	{
		[SingleLineTexture][Header(Maps)][Space(10)][MainTexture]_Albedo("Albedo", 2D) = "white" {}
		[Normal][SingleLineTexture]_Normal("Normal", 2D) = "bump" {}
		[SingleLineTexture]_MetallicSmoothness("Metallic/Smoothness", 2D) = "white" {}
		[HDR][SingleLineTexture]_Emission("Emission", 2D) = "white" {}
		_Tiling("Tiling", Float) = 1
		[Header(Settings)][Space(5)]_Color("Color", Color) = (1,1,1,0)
		[HDR]_EmissionColor("Emission", Color) = (0,0,0,1)
		_NormalScale("Normal", Float) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_SurfaceSmoothness("Smoothness", Range( 0 , 1)) = 0
		[KeywordEnum(Metallic_Alpha,Albedo_Alpha)] _SmoothnessSource("Smoothness Source", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_local _SMOOTHNESSSOURCE_METALLIC_ALPHA _SMOOTHNESSSOURCE_ALBEDO_ALPHA
		#pragma multi_compile __ LOD_FADE_CROSSFADE
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nometa noforwardadd dithercrossfade 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _Tiling;
		uniform float _NormalScale;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform sampler2D _Emission;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform sampler2D _MetallicSmoothness;
		uniform float _SurfaceSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord250 = i.uv_texcoord * temp_cast_0;
			float2 Tiling252 = uv_TexCoord250;
			float3 Normal75 = UnpackScaleNormal( tex2D( _Normal, Tiling252 ), _NormalScale );
			o.Normal = Normal75;
			float4 tex2DNode2 = tex2D( _Albedo, Tiling252 );
			float4 Albedo19 = ( _Color * tex2DNode2 );
			o.Albedo = Albedo19.rgb;
			float4 Emission259 = ( tex2D( _Emission, Tiling252 ) * _EmissionColor );
			o.Emission = Emission259.rgb;
			float4 tex2DNode239 = tex2D( _MetallicSmoothness, Tiling252 );
			float Metallic262 = ( _Metallic * tex2DNode239.r );
			o.Metallic = Metallic262;
			float AlbedoSmoothness267 = tex2DNode2.a;
			#if defined(_SMOOTHNESSSOURCE_METALLIC_ALPHA)
				float staticSwitch266 = tex2DNode239.a;
			#elif defined(_SMOOTHNESSSOURCE_ALBEDO_ALPHA)
				float staticSwitch266 = AlbedoSmoothness267;
			#else
				float staticSwitch266 = tex2DNode239.a;
			#endif
			float Smoothness263 = ( staticSwitch266 * _SurfaceSmoothness );
			o.Smoothness = Smoothness263;
			o.Alpha = 0.1f;
		}

		ENDCG
	}
	Fallback "Diffuse"
}