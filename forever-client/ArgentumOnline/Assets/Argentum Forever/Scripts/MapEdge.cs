using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapEdge : MonoBehaviour
{
    // Map owner ID
    private int mMapOwnerID;

    private void Awake()
    {
        mMapOwnerID = GetComponentsInParent<Map>()[0].mID;
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        // Get the character that collided with this portal
        PlayableCharacter character = collision.gameObject.GetComponent<PlayableCharacter>();

        // If it is a character
        if (character != null)
        {
            // Notify the map transition
            WorldManager.ProcessMapChange(mMapOwnerID, character);
        }
    }
}
