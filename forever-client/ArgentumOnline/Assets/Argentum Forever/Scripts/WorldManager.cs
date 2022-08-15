using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WorldManager : NetworkBehaviour
{
    // Flag for local testing (true = testing engabled)
    [SerializeField] private bool mLocalDebugMode;

    // Spawn scene for testing mode
    [SerializeField] private int mTestingMapID;

    // Currently loaded map scenes
    [SerializeField] private IntStringDictionary mCurrentlyLoadedMapScenes = new IntStringDictionary();

    // Active map reference
    private Map mActiveMap = null;

    // Async loading helpers ****
    private bool mWaitingNextFrameToLoadSyncMap = false;
    [SerializeField] private string mLastSyncMapName;
    private int mFrameSkipCount = 0;

    private bool mWaitingForMapReposition = false;
    //***************************

    #region singleton
    private static WorldManager _instance;
    public static WorldManager Instance { get { return _instance; } }
    #endregion

    #region unity loop
    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        } else
        {
            _instance = this;
        }
    }

    private void Start()
    {
        // Test mode (local)
        if (mLocalDebugMode)
        {
            StartCoroutine("FetchPlayableCharacter");
        }
    }

    private IEnumerator FetchPlayableCharacter()
    {
        // Retrieve the local character
        PlayableCharacter character = null;

        while (character == null)
        {
            character = GameObject.FindObjectOfType<PlayableCharacter>();
            yield return new WaitForEndOfFrame();
        }

        // Teleport to testing level
        character.TeleportToMap(mTestingMapID, new Vector2(50, 50), CardinalDirection.SOUTH);

        // Manage spawn scene management
        LoadScenesAfterSpawn(mTestingMapID);
    }

    private void Update()
    {           
        // Async map loading
        if (WorldManager._instance.mWaitingNextFrameToLoadSyncMap)
        {
            if (WorldManager._instance.mFrameSkipCount > 0)
            {
                WorldManager._instance.mFrameSkipCount--;
            }
            else
            {
                // Set the new active scene
                SceneManager.SetActiveScene(SceneManager.GetSceneByName(WorldManager._instance.mLastSyncMapName));

                // Load adjacent scenes async
                StartCoroutine("LoadAdjacentScenesAsync");
            }
        }

        // Async map repositions
        else if (WorldManager._instance.mWaitingForMapReposition)
        {
            if (WorldManager._instance.mFrameSkipCount > 0)
            {
                WorldManager._instance.mFrameSkipCount--;
            }
            else
            {
                // Reposition adjacent maps accordingly
                StartCoroutine("RepositionAdjacentMapsAsync");
            }
        }
    }
    #endregion

    private IEnumerator LoadAdjacentScenesAsync()
    {
        // Retrieve active maps exits (only cardinal directions)
        if (WorldManager._instance.mActiveMap == null)
        {
            WorldManager._instance.mActiveMap = Resources.FindObjectsOfTypeAll<Map>()[0];
            WorldManager._instance.mActiveMap.EnableMap();
        }
        Vector2 currentSceneCoordinates = new Vector2(WorldManager._instance.mActiveMap.transform.position.x, WorldManager._instance.mActiveMap.transform.position.y);

        // Load adjacents maps (async)
        foreach (KeyValuePair<CardinalDirection, int> adjacentMap in WorldManager._instance.mActiveMap.mAdjacentMaps)
        {
            string sceneName = MapScenesManager.GetNameFor(adjacentMap.Value);
            if (!WorldManager._instance.mCurrentlyLoadedMapScenes.ContainsKey(adjacentMap.Value))
            {
                // Load scene
                WorldManager.LoadMapAsync(sceneName);
                WorldManager._instance.mCurrentlyLoadedMapScenes.Add(adjacentMap.Value, sceneName);
            }
        }

        WorldManager._instance.mWaitingNextFrameToLoadSyncMap = false;
        WorldManager._instance.mWaitingForMapReposition = true;
        WorldManager._instance.mFrameSkipCount = 1;

        yield return null;
    }

    private IEnumerator RepositionAdjacentMapsAsync()
    {
        // Fetch all loaded maps
        foreach (KeyValuePair<CardinalDirection, int> adjacentMap in WorldManager._instance.mActiveMap.mAdjacentMaps)
        {
            // Get the map GO
            GameObject aMapReference = null;
            while (aMapReference == null)
            {
                Map[] allMaps = Resources.FindObjectsOfTypeAll<Map>();

                foreach (Map map in allMaps)
                {
                    if (map.name == ("Map_" + adjacentMap.Value))
                    {
                        aMapReference = map.gameObject;
                        break;
                    }
                }
                yield return new WaitForEndOfFrame();
            }

            // Get the map component
            Map mapComponent = aMapReference.GetComponent<Map>();         
            
            // Reposition the map
            Vector2 adjacentPosition = GetOriginForAdjacentMap(adjacentMap.Key, WorldManager._instance.mActiveMap.transform.position);
            aMapReference.transform.position = new Vector3(adjacentPosition.x, adjacentPosition.y, aMapReference.transform.position.z);

            // Activate map
            mapComponent.EnableMap();

            // Enable edges
            mapComponent.EnableEdges();
        }

        WorldManager._instance.mWaitingForMapReposition = false;
    }

    private void LoadScenesAfterSpawn(int activeMapID)
    {
        // Retrieve map scene name
        string mapName = MapScenesManager.GetNameFor(activeMapID);

        // Load scene and wait
        SceneManager.LoadScene(mapName, LoadSceneMode.Additive);
        WorldManager._instance.mCurrentlyLoadedMapScenes.Add(activeMapID, mapName);
        WorldManager._instance.mLastSyncMapName = mapName;
        WorldManager._instance.mWaitingNextFrameToLoadSyncMap = true;
        WorldManager._instance.mFrameSkipCount = 2;
    }

    public static void LoadMapAsync(string sceneName)
    {
        AsyncOperation loadMap = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);
    }

    public Vector2 GetPositionInMap(int mapID, Vector2 worldPos)
    {
        // TODO return converted pos relative to the map
        // Could be like...
        // If I'm in map 34, I check where that map is in X Y relative to the world grid.
        // So if map 34 is in [3,4], I know the offset is 200x200.
        // 200 * 3 = 600 in X
        // 200 * 4 = 800 in Y
        // Those are the absolute coordinates.
        // The inverse operation should return pos relative to map, instead of absolute pos.
        return Vector2.up;
    }

    public Vector2 GetOriginForAdjacentMap(CardinalDirection direction, Vector2 activeMapOrigin)
    {
        Vector2 adjacentOrigin = Vector2.zero;
        int x = 0;
        int y = 0;

        switch (direction)
        {
            case CardinalDirection.NORTH :
                                            x = (int) activeMapOrigin.x;
                                            y = (int) activeMapOrigin.y + Map.MAP_SIZE.y;
                                            break;
            case CardinalDirection.NORTHEAST:
                                            x = (int) activeMapOrigin.x + Map.MAP_SIZE.x;
                                            y = (int) activeMapOrigin.y + Map.MAP_SIZE.y;
                                            break;
            case CardinalDirection.EAST:
                                            x = (int) activeMapOrigin.x + Map.MAP_SIZE.x;
                                            y = (int) activeMapOrigin.y;
                                            break;
            case CardinalDirection.SOUTHEAST:
                                            x = (int) activeMapOrigin.x + Map.MAP_SIZE.x;
                                            y = (int) activeMapOrigin.y - Map.MAP_SIZE.y;
                                            break;
            case CardinalDirection.SOUTH:
                                            x = (int)activeMapOrigin.x;
                                            y = (int) activeMapOrigin.y - Map.MAP_SIZE.y;
                                            break;
            case CardinalDirection.SOUTHWEST:
                                            x = (int) activeMapOrigin.x - Map.MAP_SIZE.x;
                                            y = (int) activeMapOrigin.y - Map.MAP_SIZE.y;
                                            break;
            case CardinalDirection.WEST:
                                            x = (int)activeMapOrigin.x - Map.MAP_SIZE.x;
                                            y = (int)activeMapOrigin.y;
                                            break;
            case CardinalDirection.NORTHWEST:
                                            x = (int) activeMapOrigin.x - Map.MAP_SIZE.x;
                                            y = (int) activeMapOrigin.y + Map.MAP_SIZE.y;
                                            break;
        }

        adjacentOrigin = new Vector2(x, y);
        return adjacentOrigin;
    }

    public static void ProcessMapChange(int destinationMapID, PlayableCharacter character)
    {
        // Disable edges
        DisableEdges();

        // Notify character
        character.EnteredMap(destinationMapID);

        // Retrieve map scene name
        string mapName = MapScenesManager.GetNameFor(destinationMapID);

        // If the new map is already loaded...
        if (WorldManager._instance.mCurrentlyLoadedMapScenes.ContainsKey(destinationMapID))
        {
            // Get the active map GO and component
            Map newActiveMap = GameObject.Find("Map_" + destinationMapID).GetComponent<Map>();

            // Unload not-adjacent map scenes
            List<int> removedMapIDs = new List<int>();
            foreach (int loadedMapID in WorldManager._instance.mCurrentlyLoadedMapScenes.Keys)
            {
                // If the loaded map scene is not adjacent of the new active map...
                if (loadedMapID != newActiveMap.mID && !newActiveMap.mAdjacentMaps.ContainsValue(loadedMapID))
                {
                    // Unload the map scene
                    SceneManager.UnloadSceneAsync(WorldManager._instance.mCurrentlyLoadedMapScenes[loadedMapID]);
                    removedMapIDs.Add(loadedMapID);
                }
            }

            // Remove unloaded scenes from the cached list
            foreach (int unloadedMapID in removedMapIDs)
            {
                WorldManager._instance.mCurrentlyLoadedMapScenes.Remove(unloadedMapID);
            }

            WorldManager._instance.mActiveMap = newActiveMap;
        }

        // If the new map is not loaded yet...
        else
        {
            // Load scene and wait
            SceneManager.LoadScene(mapName, LoadSceneMode.Additive);
            WorldManager._instance.mCurrentlyLoadedMapScenes.Add(destinationMapID, mapName);
        }

        // Clear flags
        WorldManager._instance.mLastSyncMapName = mapName;
        WorldManager._instance.mWaitingNextFrameToLoadSyncMap = true;
        WorldManager._instance.mFrameSkipCount = 2;
    }

    private static void DisableEdges()
    {
        // Disable active map entrances
        WorldManager._instance.mActiveMap.DisableEdges();
    }
}
