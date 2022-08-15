using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapScenesManager : MonoBehaviour
{
    // Maps
    private static Dictionary<int, string> mMapScenes = new Dictionary<int, string>();

    // Start is called before the first frame update
    void Start()
    {
        //TODO do this with a dat file or something cooler
        InitializeMapNames();
    }

    private void InitializeMapNames()
    {
        // KILLME test scenes
        MapScenesManager.mMapScenes.Add(1, "TEST_SCENE_1");
        MapScenesManager.mMapScenes.Add(2, "TEST_SCENE_2");
        MapScenesManager.mMapScenes.Add(3, "TEST_SCENE_3");
        MapScenesManager.mMapScenes.Add(4, "TEST_SCENE_4");
        MapScenesManager.mMapScenes.Add(5, "TEST_SCENE_5");
        MapScenesManager.mMapScenes.Add(6, "TEST_SCENE_6");
        MapScenesManager.mMapScenes.Add(7, "TEST_SCENE_7");
        MapScenesManager.mMapScenes.Add(8, "TEST_SCENE_8");
        MapScenesManager.mMapScenes.Add(9, "TEST_SCENE_9");
        MapScenesManager.mMapScenes.Add(14, "4");
    }

    public static string GetNameFor(int mapID)
    {
        string mapName = null;

        if (MapScenesManager.mMapScenes.ContainsKey(mapID))
        {
            mapName = MapScenesManager.mMapScenes[mapID];
        }

        return mapName;
    }
}
