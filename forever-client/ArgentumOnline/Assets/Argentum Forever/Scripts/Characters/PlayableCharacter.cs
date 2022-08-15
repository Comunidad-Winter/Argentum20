using Cinemachine;
using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayableCharacter : Character
{
    //Placeholder until data is recorded with player
    public List<Spell> spellsToLearnOnStart = new List<Spell>();
    protected override void InitializeDefaultComponents()
    {
        DontDestroyOnLoad(transform);

        mPaperdollManager = transform.GetComponentInChildren<PaperdollManager>();
        mEquipmentManager = transform.GetComponentInChildren<EquipmentManager>();
        mInventoryManager = transform.GetComponentInChildren<InventoryManager>();
        mSpellManager = transform.GetComponentInChildren<SpellManager>();
    }

    public override void OnStartLocalPlayer()
    {
        base.OnStartLocalPlayer();
        CinemachineVirtualCamera rVcam = FindObjectOfType<CinemachineVirtualCamera>();
        rVcam.m_Follow = gameObject.transform;

        //TODO KILLME TEST
        //Instantiate(GetComponent<TestingGUI>().mPaperdollTestingGUI, transform);
        mInventoryManager.AddItem(GetComponent<TestingGUI>().mMonkRobes);
        mInventoryManager.AddItem(GetComponent<TestingGUI>().mNewbieClothes);
        mInventoryManager.AddItem(GetComponent<TestingGUI>().mWoodenBucker);
        mInventoryManager.AddItem(GetComponent<TestingGUI>().mWoodenSword);
        mInventoryManager.AddItem(GetComponent<TestingGUI>().mHelmet);

        for (int i = 0; i < spellsToLearnOnStart.Count; i++)
            LearnSpell(spellsToLearnOnStart[i]);

        Instantiate(GetComponent<TestingGUI>().mCharacterInfoGUI, transform);
        //Instantiate(GetComponent<TestingGUI>().mItemsGUI, transform);
        Instantiate(GetComponent<TestingGUI>().mMagicGUI, transform);
        Instantiate(GetComponent<TestingGUI>().mPlayerStateGUI, transform);
    }

    [ClientRpc]
    public void RpcProcessEquipedItem(int itemID, int slotID)
    {
        // Get animation set from the item ID
        Item item = ItemManager.GetItemByID(itemID);

        // Update equipment slot
        mEquipmentManager.mEquipmentSlots[item.mAllowedSlots[slotID]].EquipItem(item);

        // Update paperdoll
        LoadAnimationSet(item.mAnimationClips, item.mAllowedSlots[slotID]);

        // TODO actualizar stats...
    }

    public void ProcessUnequipedItem(Item item, EquipmentSlotType slot)
    {
        // Update paperdoll
        CleanAnimationSet(slot);

        // TODO actualizar stats... validar..
    }
       
    public void LaunchSelectedSpell(Vector2 targetPosition)
    {
        mSpellManager.CastSelectedSpell(gameObject, targetPosition);
    }

    public void UpdateSelectedSpellSlot(int newSlot)
    {
        mSpellManager.SelectSlot(newSlot);
    }
}
