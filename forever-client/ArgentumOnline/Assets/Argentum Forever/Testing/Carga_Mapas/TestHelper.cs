using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TestHelper : MonoBehaviour
{
    // Player GO reference
    [SerializeField] private GameObject mPlayer;

    private static List<string> loadedScenes = new List<string>();

    // Start is called before the first frame update
    void Start()
    {
        DontDestroyOnLoad(gameObject);
        //mPlayer.GetComponent<CharacterInfo>().EnteredMap(1, new Vector2(mPlayer.transform.position.x, mPlayer.transform.position.y), CardinalDirection.SOUTH);
        TestHelper.loadedScenes.Add("TEST_SCENE_1");
        Map testMap1 = GameObject.Find("Map").GetComponent<Map>();
        TestHelper.LoadMapBatchAsync(testMap1.mAdjacentMaps);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    internal static void LoadMap(string sceneName)
    {
        if (!TestHelper.loadedScenes.Contains(sceneName))
        {
            AsyncOperation loadMap = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);
            TestHelper.loadedScenes.Add(sceneName);
        }

        // ADYACENTES HARCODEADOS PARA PROBAR
        int[] adjacents = new int[5];
        adjacents[0] = 1;
        adjacents[1] = 2;
        adjacents[2] = 3;
        adjacents[3] = 4;
        adjacents[4] = 5;
        foreach (int mapID in adjacents)
        {
            string sName = "TEST_SCENE_" + mapID;
            if (!TestHelper.loadedScenes.Contains(sName))
            {
                AsyncOperation loadMap = SceneManager.LoadSceneAsync(sName, LoadSceneMode.Additive);
                TestHelper.loadedScenes.Add(sName);
            }
        }
    }

    internal static void LoadMapBatchAsync(DirectionIntDicionary mConnectedMaps)
    {
        foreach (int mapID in mConnectedMaps.Values)
        {
            string sceneName = "TEST_SCENE_" + mapID;
            if (!TestHelper.loadedScenes.Contains(sceneName))
            {
                TestHelper.LoadMap(sceneName);
                TestHelper.loadedScenes.Add(sceneName);
            }   
        }
    }
}
