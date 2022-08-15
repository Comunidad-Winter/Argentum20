/*
    Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
    Argentum Online Clasico
    noland.studios@gmail.com
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;
using System.Threading;
using UnityEngine;
using UnityEngine.Tilemaps;
using UnityEngine.UI;
using TMPro;

public class MotorPlayerMovement : Movement
{
    public float WalkSpeed = 6.0f; //Velocidad normal
    private float runDelta = 2.2f; // delta Velocidad correr. se multiplica por la velocidad de caminar
    private float walkDiagDelta = 0.7f; //Delta de velocidad de las diagonales. (No modificar 0.7 default)
    private float WalkRunSpeed = 6.0f;
    private bool running = false;
    private bool isDead = false;
    private Vector3 scaleHuman;
    private Vector3 teleportingPos;
    private WorldClient mWorldClient;

    public void Awake()
    {
        base.Awake();
        DontDestroyOnLoad(this.gameObject);
    }

    public override void Start()
    {
        base.Start();
        scaleHuman = this.transform.localScale;
    }


    private bool TryToMove(Vector3 pos)
    {
        if (IsThereWater(pos))
        {
            // nothing to do
            return false;
        }
        else
        {
            //mWorldClient.OnPlayerMoved(pos);
            mBody.MovePosition(pos);
            return true;
        }
    }
    public void SetTeleportingPos(Vector3 newPos )
    {
        teleportingPos = newPos;
    }
    public Vector3 GetTeleportingPos()
    {
        return teleportingPos;
    }

    void Update(){
        if (Input.GetKeyDown(KeyCode.R))
        {
            if (running)
            {
                running = false;
            }
            else
            {
                running = true;
            }
        }
    }

    // Update is called once per frame
    float mTimeElapsedFixedUpdate = 0.0f;

    void FixedUpdate()
    {
        base.FixedUpdate();
        mTimeElapsedFixedUpdate += Time.deltaTime;

        if( mTimeElapsedFixedUpdate >= 0.05f ){
            mTimeElapsedFixedUpdate= 0.0f;
        }
        else{
            return ;
        }


        if (IsAnimationPlaying("Attack"))
        {
            return;
        }
        else if (Input.GetButton("Fire1"))
        {
            PlayAnimation("Attack");
            return;
        }


        Vector2 input_delta = new Vector2(
            Input.GetAxisRaw("Horizontal"),
            Input.GetAxisRaw("Vertical"));

        string anim_name = "Stand";
        if (input_delta.x != 0f || input_delta.y != 0f)
        {
            if (!running)
            {
                WalkRunSpeed = WalkSpeed;
                anim_name = "Walk";
            }
            else
            {
                WalkRunSpeed = WalkSpeed * runDelta;
                anim_name = "Run";
            }
        }

        if (input_delta.x != 0f && input_delta.y != 0f) input_delta *= walkDiagDelta;
        if (input_delta.x != 0f || input_delta.y != 0f) {
                SetDirection(GetDirectionFromDelta(input_delta));
                var newpos = mBody.position + input_delta * WalkRunSpeed * Time.deltaTime;
                PlayAnimation(anim_name);
                TryToMove(newpos);
        }
        else {
                PlayAnimation(anim_name);
        }

    }



}
