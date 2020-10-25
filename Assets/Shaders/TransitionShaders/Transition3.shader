Shader "Transitions/Transition3"
{
    Properties
    {
        _ThresHold("ThresHold", Range(0, 1)) = 0.5
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
                fixed left = i.uv.y;
                fixed right = 1 - i.uv.y; 
                fixed c = 0;

                if (i.uv.x < 0.5)
                {
                    c = left;
                }
                else
                {
                    c = right;
                }

                if(c < _ThresHold)
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
