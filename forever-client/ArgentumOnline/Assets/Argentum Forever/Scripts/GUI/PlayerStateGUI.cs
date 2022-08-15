using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerStateGUI : MonoBehaviour
{
    public Slider _healthBar;
    public Slider _manaBar;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Attribute attribute;
        bool bValueFound = GetComponentInParent<Character>().mAttributes.TryGetValue(DefaultAttributeType.HEALTH, out attribute);
        if (bValueFound)
        {
            //Value
            _healthBar.value = attribute.mCurrentValue / (float)attribute.mMaxValue;
        }

        bValueFound = GetComponentInParent<Character>().mAttributes.TryGetValue(DefaultAttributeType.MANA, out attribute);
        if (bValueFound)
        {
            //Value
            _manaBar.value = attribute.mCurrentValue / (float)attribute.mMaxValue;
        }
    }
}
