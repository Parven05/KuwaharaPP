using UnityEngine;
using UnityEngine.SceneManagement;

public class CameraMovement : MonoBehaviour
{
    public float moveSpeed = 2f;    
    public float wiggleAmount = 0.2f; 
    public float wiggleSpeed = 3f;    

    private float startY;

    void Start()
    {
        startY = transform.position.y;
    }

    void Update()
    {
        transform.position += Vector3.left * moveSpeed * Time.deltaTime;

        float wiggle = Mathf.Sin(Time.time * wiggleSpeed) * wiggleAmount;

        transform.position = new Vector3(
            transform.position.x,
            startY + wiggle,
            transform.position.z
        );

        if (transform.position.x <= -9f)
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
    }
}
