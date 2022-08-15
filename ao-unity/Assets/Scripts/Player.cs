using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using UnityEngine.InputSystem;

public class Player : NetworkBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    void Update()
    {
        
    }

    public void OnMovement(InputAction.CallbackContext value)
    {
        if (!isLocalPlayer) return;

        Vector2 inputMovement = value.ReadValue<Vector2>();
        Debug.Log(inputMovement);
    }
}
