/*
    Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
    Argentum Online Clasico
    noland.studios@gmail.com
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugMenu : MonoBehaviour
{

    public GameObject character;
    public Transform  char_pos;

    public void SpawnButton(){
       Debug.Log("SpawnButton");
       GameObject player = GameObject.FindGameObjectsWithTag("Player")[0];
       Vector3 pc_pos = player.transform.position;
       Debug.Log("PC " + pc_pos.ToString() );
       GameObject[] whatever = GameObject.FindGameObjectsWithTag("GenericCharacter");
       char_pos = whatever[0].transform;
       Vector3  offset = new Vector3(Random.Range(-2.0f, 2.0f), Random.Range(-2.0f, 2.0f), 0);
       Debug.Log("char_pos.position" + char_pos.position.ToString() );
       char_pos.position =  pc_pos + offset;
       GameObject tilemap = GameObject.FindGameObjectsWithTag("Tilemap")[0];
       Instantiate(whatever[0], char_pos.position, Quaternion.identity, tilemap.transform);
    }
}
