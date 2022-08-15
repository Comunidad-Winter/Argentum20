using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Portal : MonoBehaviour
{
    public int mDestinationMapID;
    [SerializeField] private int mDestinationX;
    [SerializeField] private int mDestinationY;
    [SerializeField] private bool mForcesDirectionOnEnter;
    [SerializeField] public CardinalDirection mForcedDirection;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        // Get the character that collided with this portal
        PlayableCharacter character = collision.gameObject.GetComponent<PlayableCharacter>();

        // If it is a character
        if (character != null)
        {
            // Notify the map transition
            WorldManager.ProcessMapChange(mDestinationMapID, character);
        }


        //TODO implementar teleport
    //    UnityEngine.Debug.Log("OnEnterLoadScene " + col.gameObject.name + " : " + gameObject.name + " : " + Time.time);
    //    if (col.CompareTag("Player"))
    //    {
    //        var player = col.gameObject;
    //        var playerScript = player.GetComponent<Character>();
    //        UnityEngine.Debug.Assert(playerScript != null);
    //        var wc = GameObject.Find("WorldClient");
    //        UnityEngine.Debug.Assert(wc != null);
    //        var client = wc.GetComponent<WorldClient>();
    //        var newPos = new Vector3(0, 0, 0);
    //        if (!lockx)
    //        {
    //            float x = float.Parse(teleport_x);
    //            newPos.x = x;
    //        }
    //        else
    //        {
    //            newPos.x = player.transform.position.x;
    //        }
    //        if (!locky)
    //        {
    //            float y = float.Parse(teleport_y);
    //            newPos.y = y;
    //        }
    //        else
    //        {
    //            newPos.y = player.transform.position.y;
    //        }

    //        client.OnPlayerOnEnterLoadScene(scene, newPos); // Send the command MAP_REQ to the server

    //        Scene cur_scene = SceneManager.GetActiveScene();
    //        if (cur_scene.name != scene)
    //        {
    //            client.SetSceneLoaded(false);
    //            SceneManager.LoadScene(scene);
    //            UnityEngine.Debug.Log("Warping to a new scene: " + scene);
    //            playerScript.SetTeleportingPos(newPos);
    //            UnityEngine.Debug.Log("TELEPORT X: " + player.transform.position.x.ToString() + " Y:" + player.transform.position.y.ToString());
    //            UnityEngine.Debug.Log("Teleporting player to x:" + WarpingDestination.teleport_x + " y:" + WarpingDestination.teleport_y);
    //            WarpingDestination.warping = true;
    //        }
    //        else
    //        {
    //            // We teleport to the current scene, only need to update the player position
    //            UnityEngine.Debug.Log("Warping to the same scene");
    //            player.transform.position = newPos;
    //        }

    //    }
    //}
    }

}
