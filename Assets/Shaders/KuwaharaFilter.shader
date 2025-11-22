Shader "Custom/KuwaharaFilter"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Radius("Radius", Range(1,10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {   Ztest Always Cull Off Zwrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize; // x = 1/width, y = 1/height
            int _Radius;

            float3 Kuwahara(float2 uv, int radius)
            {
                float r = (float)radius;

                float2 regionOffset[4];
                regionOffset[0] = float2(-r, -r); // top-left
                regionOffset[1] = float2(0.0, -r); // top-right
                regionOffset[2] = float2(-r, 0.0); // bottom-left
                regionOffset[3] = float2(0.0, 0.0); //bottom-right

                float3 avg[4];
                float3 var[4];

                for (int i = 0; i < 4; i++)
                {
                    avg[i] = float3(0.0, 0.0, 0.0);
                    var[i] = float3(0.0, 0.0, 0.0);
                }

                float pixelCount = (r + 1.0) * (r + 1.0);

                for (int region = 0; region < 4; region++)
                {
                    for (int x = 0; x <= radius; x++)
                        for (int y = 0; y <= radius; y++)
                        {
                            float2 offset = regionOffset[region] + float2(x, y);
                            float2 sampleUV = uv + offset * _MainTex_TexelSize.xy;
                            float3 color = tex2D(_MainTex, sampleUV).rgb;
                            avg[region] += color;
                            var[region] += color * color;
                        }

                    avg[region] /= pixelCount;
                    var[region] = abs((var[region] / pixelCount) - (avg[region] * avg[region]));
                }

                float bestValue = 1e9;
                float3 bestColor = float3(0.0, 0.0, 0.0);

                for (int i = 0; i < 4; i++)
                {
                    float sumVariance = var[i].r + var[i].g + var[i].b;
                    if (sumVariance < bestValue)
                    {
                        bestValue = sumVariance;
                        bestColor = avg[i];
                    }
                }

                return bestColor;
            }

            fixed4 frag(v2f_img i) : SV_Target
            {
                float3 color = Kuwahara(i.uv, _Radius);
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
    FallBack Off
}
