using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[CreateAssetMenu(fileName = "Item", menuName = "Item", order = 1)]
public class Item : ScriptableObject
{
    // Item ID
    [SerializeField] public int mID;

    // Item name
    [SerializeField] private string mName;

    // Item description
    [SerializeField] private string mDescription;

    // Base price at NPCs
    [SerializeField] private int nBasePrice;

    // Item weight in "stones" ;)
    [SerializeField] private int mWeight;

    // Item type (consumable/equipable)
    [SerializeField] private ItemType mType;

    // Allowed slots
    [SerializeField] public EquipmentSlotType[] mAllowedSlots;

    // Animation clips (paperdoll system)
    [SerializeField] public StringAnimationClipDictionary mAnimationClips;

    // Inventory icon
    [SerializeField] public Sprite mInventoryIcon;

    public Item()
    {
        // Preload the requiered animation set slots
        //TODO cargar animaciones desde el blend tree (es posible? los scriptables se crean en editor, no en runtime)
        mAnimationClips = new StringAnimationClipDictionary();
        mAnimationClips.Add("attack_east", null);
        mAnimationClips.Add("attack_north", null);
        mAnimationClips.Add("attack_northeast", null);
        mAnimationClips.Add("attack_northwest", null);
        mAnimationClips.Add("attack_south", null);
        mAnimationClips.Add("attack_southeast", null);
        mAnimationClips.Add("attack_southwest", null);
        mAnimationClips.Add("attack_west", null);
        mAnimationClips.Add("run_east", null);
        mAnimationClips.Add("run_north", null);
        mAnimationClips.Add("run_northeast", null);
        mAnimationClips.Add("run_northwest", null);
        mAnimationClips.Add("run_south", null);
        mAnimationClips.Add("run_southeast", null);
        mAnimationClips.Add("run_southwest", null);
        mAnimationClips.Add("run_west", null);
        mAnimationClips.Add("stand_east", null);
        mAnimationClips.Add("stand_north", null);
        mAnimationClips.Add("stand_northeast", null);
        mAnimationClips.Add("stand_northwest", null);
        mAnimationClips.Add("stand_south", null);
        mAnimationClips.Add("stand_southeast", null);
        mAnimationClips.Add("stand_southwest", null);
        mAnimationClips.Add("stand_west", null);
        mAnimationClips.Add("walk_east", null);
        mAnimationClips.Add("walk_north", null);
        mAnimationClips.Add("walk_northeast", null);
        mAnimationClips.Add("walk_northwest", null);
        mAnimationClips.Add("walk_south", null);
        mAnimationClips.Add("walk_southeast", null);
        mAnimationClips.Add("walk_southwest", null);
        mAnimationClips.Add("walk_west", null);
    }
}
