using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EXPERIMENTAL_AutoMove : MonoBehaviour
{
    public Rigidbody2D rb;
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void FixedUpdate() {
        rb.MovePosition(rb.position + Time.fixedDeltaTime * Vector2.right * 2.0f); 
    }
}
