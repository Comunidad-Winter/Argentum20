using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellManager : NetworkBehaviour
{
    // Spell slots
    public List<SpellSlot> mSpellSlots;

    // Current selected slot
    public SpellSlot mSelectedSlot = null;

    // Character reference
    private PlayableCharacter mCharacter;

    //Fixed size to 5 to avoid allocating/GC memory
    private Collider2D[] mOverlapBuffer = new Collider2D[5];

    #region unity loop
    private void Awake()
    {
        mCharacter = GetComponent<PlayableCharacter>();

        // Initialize slots
        InitializeSlots();
    }
    #endregion

    public void CastSelectedSpell(GameObject caster, Vector2 targetPosition)
    {
        Spell spellToCast = GetSelectedSpell();
        if (spellToCast == null)
            return;
        float currentMana = caster.GetComponent<Character>().mAttributes[DefaultAttributeType.MANA].mCurrentValue;
        if (currentMana - spellToCast._requiredMana < 0)
            return;

        int spellIndex = VisualEffectsManager.Instance.GetIndexFromSpell(spellToCast);
        CmdCastSpell(caster, targetPosition, spellIndex);
    }

    [Command(ignoreAuthority = true)]
    protected void CmdCastSpell(GameObject caster, Vector2 targetPosition, int spellIndex)
    {
        Spell spell = VisualEffectsManager.Instance.GetSpellFromIndex(spellIndex);

        Character casterCharacter = caster.GetComponent<Character>();
        float currentMana = casterCharacter.mAttributes[DefaultAttributeType.MANA].mCurrentValue;
        if (currentMana - spell._requiredMana < 0)
            return;

        int layerMask = 0;
        foreach (EffectTargetType targetType in spell._validTargets)
            layerMask |= GetLayerMaskFromTargetType(targetType);

        Vector2 spellDetectionExtent = Vector2.one * 0.25f;

        int overlapCount = Physics2D.OverlapBoxNonAlloc(targetPosition, spellDetectionExtent, 0, mOverlapBuffer, layerMask);

        ExtDebug.DrawBox(targetPosition, spellDetectionExtent * 0.5f, Quaternion.identity, Color.red);

        if (overlapCount > 0)
        {
            foreach (Effect effect in spell.GetSpellEffects())
                effect.ApplyTo(ref mOverlapBuffer, overlapCount, targetPosition);

            Debug.Log("Casted Spell: " + spell._name);
            casterCharacter.GetComponent<Character>().ModifyAttribute(DefaultAttributeType.MANA, -spell._requiredMana);
            Connection.Instance.PlaySpellFX(spell, targetPosition, mOverlapBuffer[0].transform);
        }
        else
        {
            Debug.Log("No valid target for: " + spell._name);
        }
    }

    protected int GetLayerMaskFromTargetType(EffectTargetType targetType)
    {
        switch (targetType)
        {
            case EffectTargetType.ANY:
                return LayerMask.GetMask("");
            case EffectTargetType.ANY_CHARACTER:
                return LayerMask.GetMask("Players");
            case EffectTargetType.OTHER_CHARACTER_ONLY:
                return LayerMask.GetMask("Players");
            case EffectTargetType.SELF_CHARACTER_ONLY:
                return LayerMask.GetMask("Players");
            case EffectTargetType.EMPTY_TERRAIN_ONLY:
                return LayerMask.GetMask("");
            default:
                return 0;
        }
    }

    public void SelectSlot(int newSlot)
    {
        mSelectedSlot = mSpellSlots[newSlot];
    }

    public Spell GetSelectedSpell()
    {
        return mSelectedSlot != null ? mSelectedSlot.mSpell : null;
    }

    internal void AddNewSpell(Spell spell)
    {
        if (mSpellSlots == null) { InitializeSlots();  }

        foreach (SpellSlot slot in mSpellSlots)
        {
            if (slot.mSpell == null)
            {
                slot.mSpell = spell;
                break;
            }
        }
    }
    private void InitializeSlots()
    {
        //FIXME cargar tope de slots desde el server
        int max_slots = 3;
        mSpellSlots = new List<SpellSlot>();
        for (int i = 0; i < max_slots; i++)
        {
            mSpellSlots.Add(new SpellSlot());
        }
        //mSelectedSlot = mSpellSlots[0];
    }
}