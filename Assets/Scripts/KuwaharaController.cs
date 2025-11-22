using UnityEngine;
using UnityEngine.UI;

public class KuwaharaController : MonoBehaviour
{
    public KuwaharaPostProcess kuwaharaPostProcess;
    public Slider slider;

    void Start()
    {
        if (slider != null)
        {
            slider.onValueChanged.AddListener(OnSliderChanged);
            OnSliderChanged(slider.value);
        }
    }

    void OnSliderChanged(float value)
    {
        if (kuwaharaPostProcess != null)
            kuwaharaPostProcess.SetRadius(value);
    }


}
