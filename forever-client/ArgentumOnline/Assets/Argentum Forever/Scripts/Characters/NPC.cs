using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NPC : Character
{
    #region components cache
    private Rigidbody2D mRigidBody;
    #endregion

    protected override void InitializeDefaultComponents()
    {
        //DontDestroyOnLoad(transform);
        //mPaperdollManager = transform.GetComponentInChildren<PaperdollManager>();
        //mEquipmentManager = transform.GetComponentInChildren<EquipmentManager>();
        //mInventoryManager = transform.GetComponentInChildren<InventoryManager>();
        //mSpellManager = transform.GetComponentInChildren<SpellManager>();

        // Setup the component cache
        mRigidBody = GetComponent<Rigidbody2D>();
    }
}
