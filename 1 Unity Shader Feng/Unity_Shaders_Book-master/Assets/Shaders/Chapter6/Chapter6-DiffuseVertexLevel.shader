Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level" {
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass { 
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			fixed4 _Diffuse;
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};
			//顶点空间的漫反射
			v2f vert(a2v v) {
				v2f o;
				// 从模型空间变换到齐次裁剪空间
				o.pos = UnityObjectToClipPos(v.vertex);
				// 环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				// 法线变换，逆矩阵的转置矩阵
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				// 光照方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				// 漫反射
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				o.color = ambient + diffuse;
				return o;
			}
			fixed4 frag(v2f i) : SV_Target {
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
