using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class MagicGUI : MonoBehaviour
{
    // Character reference
    PlayableCharacter mCharacter;

    public bool mTargetingEnabled = false;

    public float mSpellInterval = 1f;
    private float mCurrentSpellInterval = 0f;

    [SerializeField] Texture2D targetCursorTexture;
    

    void Awake()
    {
        mCharacter = GetComponentInParent<PlayableCharacter>();
        DontDestroyOnLoad(gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        if (!mTargetingEnabled)
            mCurrentSpellInterval += Time.deltaTime;

        //FIXME actualizar solo cuando haga falta

        // Update spell slots
        UpdateSpellList();

        // FIXME no va aca
        CheckSpellCast();
    }

    private void UpdateSpellList()
    {
        int slotN = 0;
        foreach (SpellSlot slot in mCharacter.mSpellManager.mSpellSlots)
        {
            Transform guiSlot = transform.GetChild(0).GetChild(slotN);

            // Update slot text
            if (slot.mSpell != null)
            {
                transform.GetChild(0).GetChild(slotN).GetComponent<Text>().text = slot.mSpell._name;
            }
            else
            {
                transform.GetChild(0).GetChild(slotN).GetComponent<Text>().text = "(SLOT " + slotN + ")";
            }
            
            slotN++;
        }

        // Clear empty inventory slots (in GUI)
        for (int i = slotN; i < transform.GetChild(0).childCount - 1; i++)
        {
            // Clear slot
            transform.GetChild(0).GetChild(slotN).GetComponent<Text>().text = "(SLOT " + slotN + ")";
        }
    }

    public void SelectSlot(int slotNumber)
    {
        mCharacter.UpdateSelectedSpellSlot(slotNumber);

        foreach (Transform guiSlot in transform.GetChild(0))
        {
            guiSlot.GetComponent<Text>().color = Color.white;
        }

        transform.GetChild(0).GetChild(slotNumber).GetComponent<Text>().color = Color.green;

        DisableTargetingMode();
    }

    public void EnableTargetingMode()
    {
        if (mCurrentSpellInterval < mSpellInterval)
            return;

        mTargetingEnabled = true;
        Vector2 cursorOffset = new Vector2(targetCursorTexture.width / 2, targetCursorTexture.height / 2);
        Cursor.SetCursor(targetCursorTexture, cursorOffset, CursorMode.Auto);
    }
    public void DisableTargetingMode()
    {
        if (mTargetingEnabled)
            mCurrentSpellInterval = 0;

        mTargetingEnabled = false;
        Cursor.SetCursor(null, Vector2.zero, CursorMode.Auto);
    }

    private void CheckSpellCast()
    {
        if (Input.GetMouseButtonUp(0) && !EventSystem.current.IsPointerOverGameObject())
        {
            if (mTargetingEnabled)
            {
                // Check if it hits something before sending to the server
                // If I didn't check, it would generate traffic unnecesarily
                Vector2 mousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                mCharacter.LaunchSelectedSpell(mousePos);
            }
            DisableTargetingMode();
        }
    }
}
