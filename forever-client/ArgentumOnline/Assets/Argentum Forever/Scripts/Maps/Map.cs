using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Map : MonoBehaviour
{
    // Basic information
    [SerializeField] public int mID;
    [SerializeField] public string mMapName;
    [SerializeField] public static Vector2Int MAP_SIZE = new Vector2Int(200, 200);

    // Adjacent maps (including non-walkable diagonals)
    [SerializeField] public DirectionIntDicionary mAdjacentMaps = new DirectionIntDicionary();

    // Dungeons (offmap connections) <Portal prefab, Destination Map ID>
    private Dictionary<Portal, int> mOffmapConnections;

    // Custom music
    [SerializeField] private AudioClip[] mMusicTracks;

    // Custom SFXs
    [SerializeField] private AudioClip[] mAmbienceSFXs;

    private void Awake()
    {
        // Load off-map connections
        LoadPortalExits();

        // Change GO name to include the map ID
        gameObject.name += "_" + mID;

        // Disble GO until the map is positioned correctly
        gameObject.SetActive(false);
    }

    public void EnableMap()
    {
        gameObject.SetActive(true);
    }

    private void LoadPortalExits()
    {
        // Portals dictionary
        mOffmapConnections = new Dictionary<Portal, int>();

        // Fetch all "Portal" childs
        foreach (Transform childPortals in transform.Find("Portals"))
        {
            Portal portal = childPortals.GetComponent<Portal>();
            if (portal != null)
            {
                mOffmapConnections.Add(portal, portal.mDestinationMapID);
            }
        }
    }

    public void DisableEdges()
    {
        foreach (Transform mapEdge in transform.Find("Edges"))
        {
            MapEdge currentEdge = mapEdge.GetComponent<MapEdge>();
            if (currentEdge != null)
            {
                currentEdge.GetComponent<Collider2D>().enabled = false;
            }
        }
    }

    public void EnableEdges()
    {
        foreach (Transform mapEdge in transform.Find("Edges"))
        {
            MapEdge currentEdge = mapEdge.GetComponent<MapEdge>();
            if (currentEdge != null)
            {
                currentEdge.GetComponent<Collider2D>().enabled = true;
            }
        }
    }
}
