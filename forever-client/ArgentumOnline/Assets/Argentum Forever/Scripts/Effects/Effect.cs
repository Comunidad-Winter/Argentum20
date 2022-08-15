using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Effect
{
    public abstract void ApplyTo(ref Collider2D[] targets, int targetsCount, Vector2 position);

    //protected abstract bool TargetTypeValid(EffectTargetType targetType);
}
