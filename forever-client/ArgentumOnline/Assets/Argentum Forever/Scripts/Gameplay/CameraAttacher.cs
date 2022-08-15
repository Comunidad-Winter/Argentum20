using Mirror;
using UnityEngine;

public class CameraAttacher : NetworkBehaviour
{     
    private void Start()
    {
        if (isLocalPlayer)
        {
            Camera.main.transform.SetParent(transform);
            Camera.main.transform.localPosition = new Vector3(0, 0, -1);
        }
    }
}
