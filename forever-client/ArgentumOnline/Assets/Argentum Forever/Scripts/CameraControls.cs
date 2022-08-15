using Cinemachine;
using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D;

public class CameraControls : MonoBehaviour
{
    // Zoom levels
    [SerializeField] private int _minZoomPixelPerUnit;
    [SerializeField] private int _maxZoomPixelPerUnit;
    [SerializeField] private int _zoomStep;

    private PixelPerfectCamera _mainCameraPixelPerfect;
    
    private void Awake()
    {
        _mainCameraPixelPerfect = Camera.main.GetComponent<PixelPerfectCamera>();
    }

    private void Update()
    {
        // Check mouse wheel input
        if (Input.GetAxis("Mouse ScrollWheel") > 0f)
        {
            if ((_mainCameraPixelPerfect.assetsPPU + _zoomStep) < _maxZoomPixelPerUnit)
                _mainCameraPixelPerfect.assetsPPU += _zoomStep;
        } else if (Input.GetAxis("Mouse ScrollWheel") < 0f)
        {
            if ((_mainCameraPixelPerfect.assetsPPU - _zoomStep) > _minZoomPixelPerUnit)
                _mainCameraPixelPerfect.assetsPPU -= _zoomStep;
        }
    }
}