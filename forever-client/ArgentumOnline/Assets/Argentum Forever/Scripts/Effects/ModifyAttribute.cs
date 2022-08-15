using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[Serializable]
public class ModifyAttribute : Effect
{
    [SerializeField]
    private DefaultAttributeType mModifiedAttribute;
    [SerializeField]
    private ValueModifierType mType;
    [SerializeField]
    private int mValue;

    public override void ApplyTo(ref Collider2D[] targets, int targetsCount, Vector2 position)
    {
        Character targetCharacter = targets[0].GetComponent<Character>();
        if (targetCharacter != null)
            targetCharacter.ModifyAttribute(mModifiedAttribute, mValue);
    }

/*
    protected override bool TargetTypeValid(EffectTargetType targetType)
    {
        bool valid = false;
        if (targetType == EffectTargetType.ANY_CHARACTER || targetType == EffectTargetType.SELF_CHARACTER_ONLY || targetType == EffectTargetType.OTHER_CHARACTER_ONLY)
        {
            valid = true;
        }
        return valid;
    }*/
}
