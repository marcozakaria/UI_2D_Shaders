Shader "Custom/Stiplle Unlite Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Transparency("Transparency", Range(0,1)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            half _Transparency;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            inline void MakeStippling(v2f i)
            {
                // threshold values foreach 4x4 block of pixels , random selected numbers
                const float4x4 thresholdMatrix =
                {
                    1, 9, 3, 11,
                    13, 5, 15, 7,
                    4, 12, 2, 10,
                    16, 8, 14, 6
                };

                // multiply screen pos by (Width , height) of screen to get pixel coordinates
                float2 pixelPos = i.vertex.xy / i.vertex.w * _ScreenParams.xy;
                // divide by 17 to get value in range (0,1)
                float threshhold = thresholdMatrix[pixelPos.x % 4][pixelPos.y % 4] / 17;
                //clip discrad current pixel if value is less than zero
                clip(_Transparency - threshhold);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //Stipple section
                MakeStippling(i);
                // end stipple 

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
