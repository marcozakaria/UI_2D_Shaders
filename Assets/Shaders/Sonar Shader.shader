Shader "Custom/Sonar Shader"
{
    Properties
    {
        _Color("Color",Color) = (1.0,1.0,1.0)
        _SizeA("Size A", Float) = 0.2
        _SizeB("Size B", Float) = 0.2
        _Speed("Speed", Range(0.0,2.0)) = 0.4
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"
                "Queue"="Transparent" }

        //ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        //Cull front
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            fixed _SizeA;
            fixed _SizeB;
            fixed _Speed;
            fixed3 _Color;

            /*v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }*/

            appdata vert(appdata i)
            {
                appdata vs;
                vs.vertex = UnityObjectToClipPos(i.vertex);
                vs.uv = i.uv;
                return vs;
            }


            inline fixed circle(fixed2 d, fixed r)
            {
                return smoothstep(r - (r * _SizeA), r + (r * _SizeB), dot(d, d));
            }

            fixed4 frag(appdata i) : COLOR
            {
                fixed2 uv = i.uv.xy;
                fixed a = circle(uv - fixed2(0.5,0.5), 0.04 * sin(fmod(_Time.g * _Speed,1.0)));
                fixed b = 1.0 - (circle(uv - fixed2(0.5,0.5), 0.05 * sin(fmod(_Time.g * _Speed,1.0))));
                //fixed value = min(a, b) * (1.0 - (sin((fmod(_Time.g * _Speed, 1.0)))));
                //fixed3 c = fixed3(0.0, min(a, b),0.0); //RGB
                //c = c * (1.0 - (sin((fmod(_Time.g * _Speed, 1.0)))));

                return fixed4(_Color, min(a, b));
            }
            ENDCG
        }
    }
}
