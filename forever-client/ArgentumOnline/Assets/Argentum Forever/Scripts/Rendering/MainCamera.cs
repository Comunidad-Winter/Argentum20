using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCamera : MonoBehaviour
{
    private Camera mCamera;
    // Start is called before the first frame update
    void Start()
    {
        mCamera = Camera.main;
        mCamera.orthographicSize = 3;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetAxis("Mouse ScrollWheel") != 0f)
        {
            float delta = 1.0f; //Cambiar esta variable para acelerar o no el scroll del mouse
            mCamera.orthographicSize -= Input.GetAxis("Mouse ScrollWheel") * delta;
            if (mCamera.orthographicSize > 5)
                mCamera.orthographicSize = 5;
            if (mCamera.orthographicSize < 2)
                mCamera.orthographicSize = 2;
        }
    }

    //public void Move(Vector3 position)
    //{
    //    this.transform.position = position;
    //}
}
