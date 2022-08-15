using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EquipmentSlot
{
    // Slot type
    private EquipmentSlotType mSlotType;

    // Equiped item (if any)
    public Item mEquipedItem { get; set; }

    public EquipmentSlot(EquipmentSlotType slotType)
    {
        mSlotType = slotType;
        mEquipedItem = null;
    }

    public void EquipItem(Item item)
    {
        mEquipedItem = item;
    }

    public void FreeSlot()
    {
        mEquipedItem = null;
    }
}
