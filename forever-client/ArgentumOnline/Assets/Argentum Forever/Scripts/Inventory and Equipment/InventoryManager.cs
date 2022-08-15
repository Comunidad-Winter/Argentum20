using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InventoryManager : MonoBehaviour
{
    // Inventory capacity
    public int mInventoryCapacity = 20;

    // Inventory (item collection)
    public List<Item> mInventory = new List<Item>();

    // Character reference
    private PlayableCharacter mCharacter;

    #region unity loop
    private void Awake()
    {
        mCharacter = GetComponent<PlayableCharacter>();
    }
    #endregion

    public void AddItem(Item item)
    {
        // If there's space in the inventory...
        if (mInventory.Count + 1 <= mInventoryCapacity)
        {
            // Add the item to it
            mInventory.Add(item);
        }
    }
}
