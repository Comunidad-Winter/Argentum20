using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class EquipmentManager : NetworkBehaviour
{
    // Equipment slots
    public Dictionary<EquipmentSlotType, EquipmentSlot> mEquipmentSlots;

    // Character reference
    private PlayableCharacter mCharacter;

    #region unity loop
    private void Start()
    {
        InitializeSlots();
        mCharacter = GetComponent<PlayableCharacter>();
    }
    #endregion

    // Equip the item received as parameter. Returns FALSE if the item cannot be equiped
    public void EquipItem(Item item, EquipmentSlotType requestedSlotType)
    {
        // Network check
        if (!isLocalPlayer) { return; }

        //TODO implementar verificación de slot
 
        // Fetch request slot index
        int requestedSlotIndex = 0;
        foreach (EquipmentSlotType slot in item.mAllowedSlots)
        {
            if (slot != requestedSlotType)
            {
                requestedSlotIndex += 1;
            }
            else
            {
                break;
            }
        }

        // Notify server
        CmdCharacterEquippedItem(mCharacter.transform, item.mID, requestedSlotIndex);
    }

    [Command]
    private void CmdCharacterEquippedItem(Transform character, int itemID, int slotID)
    {
        // Notify the character that a new item was equiped
        mCharacter.RpcProcessEquipedItem(itemID, slotID);
    }

    // Unequip the item indicated by the slot received as parameter
    public void UnequipItemInSlot(EquipmentSlotType requestedSlotType)
    {
        // Network check
        if (!isLocalPlayer) { return; }

        // Unequiped item
        Item unequipedItem = mEquipmentSlots[requestedSlotType].mEquipedItem;

        //TODO implementar verificación de slot
        mEquipmentSlots[requestedSlotType].FreeSlot();

        // Notify the character that a new item was equiped
        mCharacter.ProcessUnequipedItem(unequipedItem, requestedSlotType);
    }

    private void InitializeSlots()
    {
        // Initialize standard slots
        mEquipmentSlots = new Dictionary<EquipmentSlotType, EquipmentSlot>();

        // TORSO
        mEquipmentSlots.Add(EquipmentSlotType.TORSO, new EquipmentSlot(EquipmentSlotType.TORSO));

        // HEAD
        mEquipmentSlots.Add(EquipmentSlotType.HEAD, new EquipmentSlot(EquipmentSlotType.HEAD));

        // MAIN HAND
        mEquipmentSlots.Add(EquipmentSlotType.MAIN_HAND, new EquipmentSlot(EquipmentSlotType.MAIN_HAND));

        // OFFHAND
        mEquipmentSlots.Add(EquipmentSlotType.OFFHAND, new EquipmentSlot(EquipmentSlotType.OFFHAND));

        // CLOAK
        mEquipmentSlots.Add(EquipmentSlotType.CLOAK, new EquipmentSlot(EquipmentSlotType.CLOAK));

        // QUIVER (AMMO)
        mEquipmentSlots.Add(EquipmentSlotType.QUIVER, new EquipmentSlot(EquipmentSlotType.QUIVER));

        // BOOTS
        mEquipmentSlots.Add(EquipmentSlotType.BOOTS, new EquipmentSlot(EquipmentSlotType.BOOTS));

        // BELT
        mEquipmentSlots.Add(EquipmentSlotType.BELT, new EquipmentSlot(EquipmentSlotType.BELT));

        // HANDS
        mEquipmentSlots.Add(EquipmentSlotType.HANDS, new EquipmentSlot(EquipmentSlotType.HANDS));

        // RING 1
        mEquipmentSlots.Add(EquipmentSlotType.RING_1, new EquipmentSlot(EquipmentSlotType.RING_1));

        // RING 2
        mEquipmentSlots.Add(EquipmentSlotType.RING_2, new EquipmentSlot(EquipmentSlotType.RING_2));

        // NECKLACE
        mEquipmentSlots.Add(EquipmentSlotType.NECKLACE, new EquipmentSlot(EquipmentSlotType.NECKLACE));
    }

    public Item GetItemInSlot(EquipmentSlotType slot)
    {
        return mEquipmentSlots[slot].mEquipedItem;
    }
}
