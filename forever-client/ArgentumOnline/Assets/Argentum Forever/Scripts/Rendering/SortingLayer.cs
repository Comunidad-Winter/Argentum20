using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SortingLayer : MonoBehaviour
{
    private SpriteRenderer spriteRenderer;
    // Start is called before the first frame update
    void Start()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void Update()
    {

    }
    void LateUpdate()
    {
        if (spriteRenderer.isVisible)
            spriteRenderer.sortingOrder = (int)Camera.main.WorldToScreenPoint(transform.position).y * -1;
    }
}
