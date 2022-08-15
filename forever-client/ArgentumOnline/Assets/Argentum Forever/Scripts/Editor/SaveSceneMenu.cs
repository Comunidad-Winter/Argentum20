using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CountSceneObjects
{
    private static SceneData scData;
    public string sc = "";
    [MenuItem("File/Save scene")]
    public static void Execute()
    {
        scData = new SceneData();
        // get root objects in scene
        UnityEngine.SceneManagement.Scene scene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
        List<GameObject> rootObjects = new List<GameObject>(scene.rootCount + 1);
        scene.GetRootGameObjects(rootObjects);
        Debug.Log("Object Count: " + rootObjects.Count.ToString());
        // iterate root objects
        for (int i = 0; i < rootObjects.Count; ++i)
        {
            GameObject gameObject = rootObjects[i];
            Debug.Log(gameObject.name);
            if (gameObject.name == "Grid")
                ProcessGrid(gameObject);

        }
        string jsonToSave = JsonHelper.ToJson(scData.buildingData);
        Debug.Log("*******************");
        Debug.Log(jsonToSave);
        Debug.Log("*******************");
        Debug.Log(Application.persistentDataPath);
        string file = "Scene-" + scene.name + ".json";
        System.IO.File.WriteAllText(Application.persistentDataPath + file, jsonToSave);
        //System.IO.File.WriteAllText(@"C:\" + file, jsonToSave);
    }
    static void ProcessGrid(GameObject gameObject)
    {
        Debug.Log("Process Grid");
        GameObject sprites = gameObject.transform.Find("Sprites").gameObject;
        ProcessSprites(sprites);
        return;
    }
    static void ProcessSprites(GameObject gameObject)
    {
        Debug.Log("Process Sprites");
        //Transform children;
        Transform edificaciones = gameObject.transform.Find("Edificaciones");
        if (edificaciones != null)
        {
            List<Building> buildingList = new List<Building>();
            foreach (Transform child in edificaciones)
            {
                Debug.Log("Edificacion: " + child);

                Component rendererComponent = child.GetComponent<Renderer>();
                if (rendererComponent)
                {
                    Debug.Log("Renderer Component X: " + child.GetComponent<Renderer>().bounds.size.x.ToString());
                    Debug.Log("Renderer Component Y: " + child.GetComponent<Renderer>().bounds.size.x.ToString());
                }
                Debug.Log("Position X: " + child.position.x.ToString());
                Debug.Log("Position Y: " + child.position.y.ToString());

                OnEnterLoadScene hasScript = child.GetComponent<OnEnterLoadScene>();
                string teleport = "";
                if (hasScript)
                {
                    // This collider is a trigger
                    Debug.Log("Teleport X: " + hasScript.teleport_x);
                    Debug.Log("Teleport Y: " + hasScript.teleport_y);
                    Debug.Log("Scene: " + hasScript.scene);
                    teleport = hasScript.scene;
                }
                else
                    Debug.Log("***************");

                buildingList.Add(new Building(child.name, child.position.x, child.position.y, teleport));


                /*Collider2D[] colliders = child.GetComponents<Collider2D>();
                foreach (Collider2D collider in colliders)
                {
                    if (collider.isTrigger)
                    {
                        // This is collider is a trigger
                        Debug.Log("************************************************");
                    }
                }*/
            }
            scData.buildingData = buildingList.ToArray();
        }
        else
        {
            Debug.Log("DIDNT FIND Sprites/Edificaciones");
        }
        return;
    }

}

[System.Serializable]
public class SceneData
{
    public Building[] buildingData;
    //public List<Tree> treeData;
    //public List<Teleport> teleportData;
}

[System.Serializable]
public class Building
{
    public Building(string n, float px, float py, string tp) { name = n; positionX = px; positionY = py; teleport = tp; }
    public string name;
    public float positionX;
    public float positionY;
    public string teleport;

}

[System.Serializable]
public class Tree
{
    public Tree(string n, float px, float py) { name = n; positionX = px; positionY = py; }
    public string name;
    public float positionX;
    public float positionY;
}
[System.Serializable]
public class Teleport
{
    public Teleport(string n, string d, float tx, float ty) { name = n; destination = d; targetX = tx; targetY = ty; }
    public string name;
    public string destination;
    public float targetX;
    public float targetY;
}

public static class JsonHelper
{
    public static T[] FromJson<T>(string json)
    {
        Wrapper<T> wrapper = JsonUtility.FromJson<Wrapper<T>>(json);
        return wrapper.Items;
    }

    public static string ToJson<T>(T[] array)
    {
        Wrapper<T> wrapper = new Wrapper<T>();
        wrapper.Items = array;
        return JsonUtility.ToJson(wrapper);
    }

    public static string ToJson<T>(T[] array, bool prettyPrint)
    {
        Wrapper<T> wrapper = new Wrapper<T>();
        wrapper.Items = array;
        return JsonUtility.ToJson(wrapper, prettyPrint);
    }

    [System.Serializable]
    private class Wrapper<T>
    {
        public T[] Items;
    }
}
