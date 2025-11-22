using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class KuwaharaPostProcess : MonoBehaviour
{
    public Material material; 
    [Range(1, 10)] public int radius = 3;

    public void SetRadius(float r)
    {
        radius = Mathf.RoundToInt(r);

        if (material != null)
        {
            material.SetInt("_Radius", radius);        
        }
    }


    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetInt("_Radius", radius);
            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
