using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//TODO cargar listado de objetos de un DAT o algo mejor
public class ItemManager : MonoBehaviour
{
    [SerializeField] private List<Item> mItems = new List<Item>();

    private static ItemManager _instance;
    public static ItemManager Instance { get { return _instance; } }

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }


    public static Item GetItemByID(int id)
    {
        return ItemManager._instance.mItems[id];
    }
}
