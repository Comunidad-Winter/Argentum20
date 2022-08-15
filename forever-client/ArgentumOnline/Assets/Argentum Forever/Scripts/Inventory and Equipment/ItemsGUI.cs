using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ItemsGUI : MonoBehaviour
{

    // Character reference
    PlayableCharacter mCharacter;

    void Start()
    {
        mCharacter = GetComponentInParent<PlayableCharacter>();
        DontDestroyOnLoad(gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        //FIXME actualizar solo cuando cambia el inventario real (evento al equipar/desequipar/agarrar, etc)

        // Update inventory slots images
        UpdateInventoryGUI();

        // Update equipment slots images
        UpdateEquipmentGUI();
    }

    private void UpdateInventoryGUI()
    {
        int itemN = 0;
        foreach (Item invItem in mCharacter.mInventoryManager.mInventory)
        {
            Transform invSlot = transform.GetChild(0).GetChild(itemN);

            // Update sprite
            invSlot.GetComponent<Image>().sprite = invItem.mInventoryIcon;
            invSlot.GetComponent<Image>().color = Color.white;

            itemN++;
        }

        // Clear empty inventory slots (in GUI)
        for (int i = itemN; i < mCharacter.mInventoryManager.mInventoryCapacity; i++)
        {
            // Clear sprite
            transform.GetChild(0).GetChild(i).GetComponent<Image>().sprite = null;
            transform.GetChild(0).GetChild(i).GetComponent<Image>().color = Color.clear;
        }
    }

    private void UpdateEquipmentGUI()
    {
        foreach (KeyValuePair<EquipmentSlotType, EquipmentSlot> equipmentSlot in mCharacter.mEquipmentManager.mEquipmentSlots)
        {
            // Get the item
            Item item = equipmentSlot.Value.mEquipedItem;

            // If there's an item equipped in that slot...
            if (item != null)
            {
                // Update sprite
                transform.GetChild(1).GetChild(ParseSlotPositionInGUI(equipmentSlot.Key)).GetComponent<Image>().sprite = item.mInventoryIcon;
                transform.GetChild(1).GetChild(ParseSlotPositionInGUI(equipmentSlot.Key)).GetComponent<Image>().color = Color.white;
            }

            // otherwise, clear the slot
            else
            {
                // Clear  sprite
                int parsedSlot = ParseSlotPositionInGUI(equipmentSlot.Key);
                if (parsedSlot != -1)
                {
                    transform.GetChild(1).GetChild(ParseSlotPositionInGUI(equipmentSlot.Key)).GetComponent<Image>().sprite = null;
                    transform.GetChild(1).GetChild(ParseSlotPositionInGUI(equipmentSlot.Key)).GetComponent<Image>().color = Color.clear;
                }                
            }
        }
    }

    private int ParseSlotPositionInGUI(EquipmentSlotType slotType)
    {
        int parsedSlot = -1;

        //FIXME horrible, generalizar en la jerarquia con algun componente custom
        switch (slotType)
        {
            case EquipmentSlotType.HEAD: parsedSlot = 0; break;
            case EquipmentSlotType.TORSO: parsedSlot = 1; break;
            case EquipmentSlotType.MAIN_HAND: parsedSlot = 2; break;
            case EquipmentSlotType.OFFHAND: parsedSlot = 3; break;
        }

        return parsedSlot;
    }

    public void EquipItemInSlot(int slotNumber)
    {
        Item item = mCharacter.mInventoryManager.mInventory[slotNumber];
        if (item != null)
        {
            mCharacter.mEquipmentManager.EquipItem(item, item.mAllowedSlots[0]);
        }        
    }
}
