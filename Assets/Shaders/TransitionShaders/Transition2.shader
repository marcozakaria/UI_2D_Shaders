Shader "Transitions/Transition2"
{
    Properties
    {
         [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)

        _ThresHold("ThresHold", Range(0, 1)) = 0.5
        [Toggle(horizontal)] _Horizontal("Horizontal", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" 
                "IgnoreProjector"="True" "PreviewType"="Plane"
			    "CanUseSpriteAtlas"="True"}

        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature horizontal 

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            fixed _ThresHold;

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            //float4 _ClipRect;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv , _MainTex);
                o.color = v.color * _Color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                #ifdef horizontal
                    fixed upDown = i.uv.x;
                #else
                    fixed upDown = i.uv.y;
                #endif

                if(0.5 - abs(upDown - 0.5) < _ThresHold * 0.5)
                {
                    return (tex2D(_MainTex, i.uv) + _TextureSampleAdd) * i.color;
                }
                else
                {
                    return fixed4(0,0,0,0);
                }

            }
            ENDCG
        }
    }
}
