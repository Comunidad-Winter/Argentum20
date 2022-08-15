using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using Unity.Properties.UI;
using UnityEngine;

public class DayNightCycle : MonoBehaviour
{
    [SerializeField] private float _dayIntensity = 1.3f;
    [SerializeField] private float _nightIntensity = 0.3f;
    [SerializeField] private float _duration = 1f;

    [SerializeField] private Color _dayColor = new Color(255f, 255f, 255f, 255f);
    [SerializeField] private Color _nightColor = new Color(134f, 182f, 155f, 255f);

    private bool _isDay = true;
    private Light _lightComponent;

    private void OnValidate()
    {
        _nightIntensity = Mathf.Max(_nightIntensity, 0);
    }

    private void Start()
    {
        _lightComponent = GetComponent<Light>();
        _lightComponent.intensity = _dayIntensity;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            if (_isDay)
            {
                _isDay = false;
                _lightComponent.DOIntensity(_nightIntensity, _duration);
                _lightComponent.DOColor(_nightColor, _duration);
            } else
            {
                _isDay = true;
                _lightComponent.DOIntensity(_dayIntensity, _duration);
                _lightComponent.DOColor(_dayColor, _duration);
            }
        }

        //if (_isDay && !DOTween.IsTweening(_lightComponent))
        //{
        //    _lightComponent.intensity = _dayIntensity;
        //    _lightComponent.color = _dayColor;
        //}
        //else
        //{
        //    _lightComponent.intensity = _nightIntensity;
        //    _lightComponent.color = _nightColor;
        //}
    }
}
