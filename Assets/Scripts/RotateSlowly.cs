using UnityEngine;

public class RotateSlowly : MonoBehaviour
{
    [SerializeField]
    private float rotationSpeed = 20f;

    void Update()
    {
        transform.Rotate(Vector3.up * rotationSpeed * Time.deltaTime, Space.World);
    }
}