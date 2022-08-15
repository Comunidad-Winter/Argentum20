using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class PaperdollManager : MonoBehaviour
{
    // Paperdoll slots
    private Dictionary<EquipmentSlotType, PaperdollSlot> mPaperdollSlots;

    #region unity loop
    // Start is called before the first frame update
    void Awake()
    {
        // Get all the paperdoll slots in the children GOs
        mPaperdollSlots = new Dictionary<EquipmentSlotType, PaperdollSlot>();
        PaperdollSlot[] paperdollSlots = GetComponentsInChildren<PaperdollSlot>();
        foreach (PaperdollSlot slot in paperdollSlots)
        {
            mPaperdollSlots.Add(slot.mType, slot);
        }
    }
    #endregion

    public void UpdatePaperdoll(bool directionChanged, float horizontalSpeed, float verticalSpeed, float finalSpeed)
    {
        // Update all equipment slots (PAPERDOLL)
        foreach (PaperdollSlot slot in mPaperdollSlots.Values)
        {
            slot.UpdateAnimatorFlags(directionChanged, horizontalSpeed, verticalSpeed, finalSpeed);
        }
    }

    public void NotifyMeleeAttackToPaperdoll(bool started)
    {
        // Update all equipment slots (PAPERDOLL)
        foreach (PaperdollSlot slot in mPaperdollSlots.Values)
        {
            slot.UpdateMeleeAttackStatus(started);
        }
    }

    public void LoadAnimationSet(StringAnimationClipDictionary animations, EquipmentSlotType slot)
    {
        mPaperdollSlots[slot].LoadAnimationSet(animations);
    }

    public void CleanAnimationSet(EquipmentSlotType slot)
    {
        mPaperdollSlots[slot].ResetAnimationSet();
    }
}
