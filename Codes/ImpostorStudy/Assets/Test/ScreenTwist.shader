// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader  "Unlit/screenTwist"
{
     Properties
     {
         _MainTex ( "Texture" , 2D) =  "white"  {}
         _Twist( "Twist" , float ) = 1
     }
     SubShader
     {
         Tags {  "RenderType" = "Opaque"  }
         LOD 100
 
         Pass
         {
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             // make fog work
             #pragma multi_compile_fog
             
             #include "UnityCG.cginc"
 
             struct  appdata
             {
                 float4 vertex : POSITION;
                 float2 uv : TEXCOORD0;
             };
 
             struct  v2f
             {
                 float2 uv : TEXCOORD0;
                 UNITY_FOG_COORDS(1)
                 float4 vertex : SV_POSITION;
             };
 
             sampler2D _MainTex;
             float4 _MainTex_ST;
             float4 _MainTex_TexelSize;
             float  _Twist;
             
             v2f vert (appdata v)
             {
                 v2f o;
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                 UNITY_TRANSFER_FOG(o,o.vertex);
                 return  o;
             }
             
             fixed4 frag (v2f i) : SV_Target
             {              
                 fixed2 tuv = i.uv;
                                 
  //���ｫ��ǰ��������ƽ�������ĵ㣬��ʾ��������ת��
  //�������Ҫ���������3d��������Ļ�ϵ�λ�ã�Ȼ�������Ļλ����ƽ��
                 fixed2 uv = fixed2(tuv.x - 0.5, tuv.y - 0.5);
  //ͨ������������ǰ�����ת����PI/180=0.1745
                 float  angle = _Twist * 0.1745 / (length(uv) + 0.1);
                 float  sinval, cosval;
                 sincos(angle, sinval, cosval);
  //������ת����
                 float2x2 mat = float2x2(cosval, -sinval, sinval, cosval);
  //��ת��ɺ�ƽ����ԭλ��
                 uv = mul(mat, uv) + 0.5;
 
                 // sample the texture
                 fixed4 col = tex2D(_MainTex, uv);
                 
                 // apply fog
                 UNITY_APPLY_FOG(i.fogCoord, col);              
                 return  col;
             }
             ENDCG
         }
     }
}