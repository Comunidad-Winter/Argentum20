using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaperdollTesting : MonoBehaviour
{
    [SerializeField] public PlayableCharacter mPlayer;
    [SerializeField] private Item monkRobes;
    [SerializeField] private Item newbieClothes;
    [SerializeField] private Item testShield;
    [SerializeField] private Item testSword;
    [SerializeField] private Item testHelmet;

    private void Start()
    {
        mPlayer = GetComponentInParent<PlayableCharacter>();
    }

    public void FreeTorsoSlot()
    {
        mPlayer.GetComponent<EquipmentManager>().UnequipItemInSlot(EquipmentSlotType.TORSO);
    }

    public void FreeOffhandSlot()
    {
        mPlayer.GetComponent<EquipmentManager>().UnequipItemInSlot(EquipmentSlotType.OFFHAND);
    }

    public void FreeMainhandSlot()
    {
        mPlayer.GetComponent<EquipmentManager>().UnequipItemInSlot(EquipmentSlotType.MAIN_HAND);
    }

    public void FreeHeadSlot()
    {
        mPlayer.GetComponent<EquipmentManager>().UnequipItemInSlot(EquipmentSlotType.HEAD);
    }

    public void EquipMonkRobes()
    {
        mPlayer.GetComponent<EquipmentManager>().EquipItem(monkRobes, EquipmentSlotType.TORSO);
    }

    public void EquipNewbieClothes()
    {
        mPlayer.GetComponent<EquipmentManager>().EquipItem(newbieClothes, EquipmentSlotType.TORSO);
    }

    public void EquipTestShield()
    {
        mPlayer.GetComponent<EquipmentManager>().EquipItem(testShield, EquipmentSlotType.OFFHAND);
    }

    public void EquipTestSword()
    {
        mPlayer.GetComponent<EquipmentManager>().EquipItem(testSword, EquipmentSlotType.MAIN_HAND);
    }

    public void EquipTestHelmet()
    {
        mPlayer.GetComponent<EquipmentManager>().EquipItem(testHelmet, EquipmentSlotType.HEAD);
    }
}
