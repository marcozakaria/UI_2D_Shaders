Shader "Transitions/Transition1"
{
    Properties
    {
        _ThresHold("ThresHold", Range(0, 1)) = 0.5
        [Toggle(horizontal)] _Horizontal("Horizontal", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                #ifdef horizontal
                   fixed left = i.uv.y;
                   fixed right = 1 - i.uv.y;
                #else
                   fixed left = i.uv.x;
                   fixed right = 1 - i.uv.x;
                #endif

                if (left < _ThresHold)
                {
                    return i.color;
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
