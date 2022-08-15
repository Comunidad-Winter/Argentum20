using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Tilemaps;


/*public class WarpingDestination
{
    public static float teleport_x=0;
    public static float teleport_y=0;
    public static bool warping = false;
    public static Movement.Direction direction= Movement.Direction.North;

}*/


public class MotorOnEnterLoadScene : MonoBehaviour
{
    public string scene = "35";
    public string teleport_x = "12";
    public string teleport_y = "7";
    public bool locky = false;
    public bool lockx = false;

    void OnTriggerEnter2D(Collider2D col)
    {
        UnityEngine.Debug.Log("OnEnterLoadScene " + col.gameObject.name + " : " + gameObject.name + " : " + Time.time);
        if (col.CompareTag("Player"))
        {
            var player = col.gameObject;
            var playerScript = player.GetComponent<MotorPlayerMovement>();
            UnityEngine.Debug.Assert(playerScript != null);
            //var wc = GameObject.Find("WorldClient");
            //UnityEngine.Debug.Assert(wc != null);
            //var client = wc.GetComponent<WorldClient>();
            var newPos = new Vector3(0, 0, 0);
            if (!lockx)
            {
                float x = float.Parse(teleport_x);
                newPos.x = x;
                //UnityEngine.Debug.Log("TELEPORT X: " + newPos.x.ToString());
            }
            else
            {
                newPos.x = player.transform.position.x;
                //UnityEngine.Debug.Log("TELEPORT X (Locked): " + newPos.x.ToString());
            }
            if (!locky)
            {
                float y = float.Parse(teleport_y);
                newPos.y = y;
                //UnityEngine.Debug.Log("TELEPORT Y: " + newPos.y.ToString());
            }
            else
            {
                newPos.y = player.transform.position.y;
                //UnityEngine.Debug.Log("TELEPORT Y (Locked): " + newPos.y.ToString());
            }


            //client.OnPlayerOnEnterLoadScene(scene,newPos); // Send the command MAP_REQ to the server

            Scene cur_scene = SceneManager.GetActiveScene();
            if(cur_scene.name!=scene){
                //client.SetSceneLoaded(false);
                SceneManager.LoadScene(scene);
                UnityEngine.Debug.Log("Warping to a new scene: " + scene);
                playerScript.SetTeleportingPos(newPos);
                UnityEngine.Debug.Log("TELEPORT X: " + player.transform.position.x.ToString() + " Y:" + player.transform.position.y.ToString());
                UnityEngine.Debug.Log("Teleporting player to x:" + WarpingDestination.teleport_x + " y:" + WarpingDestination.teleport_y);
                //WarpingDestination.direction = player.GetComponent<PlayerMovement>().GetDirection();
                //WarpingDestination.warping = true;
            }
            else {
                // We teleport to the current scene, only need to update the player position
                UnityEngine.Debug.Log("Warping to the same scene");
                player.transform.position = newPos;
            }

        }
    }
}
