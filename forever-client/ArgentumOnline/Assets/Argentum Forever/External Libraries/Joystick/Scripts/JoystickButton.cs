using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Localization;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class JoystickButton : MonoBehaviour
{
    public Button runButton;
    public Button attackButton;
    public Button deadButton;
    public bool mRun;
    public bool mAttack;
    public bool mDead;
    public bool mAlive;
    // Start is called before the first frame update
    public virtual void Start()
    {
        Button btnRun = runButton.GetComponent<Button>();
        btnRun.GetComponent<Button>().onClick.RemoveAllListeners();
        btnRun.onClick.AddListener(Run);
        Button btnAttack = attackButton.GetComponent<Button>();
        btnAttack.GetComponent<Button>().onClick.RemoveAllListeners();
        btnAttack.onClick.AddListener(Attack);
        Button btnDead = deadButton.GetComponent<Button>();
        btnDead.GetComponent<Button>().onClick.RemoveAllListeners();
        btnDead.onClick.AddListener(Dead);
        mRun = false;
        mDead = false;
        mAttack = false;
        mAlive = true;
    }


    public void Run()
    {
        if (!mAlive)
            return;
        if (mRun)
        {
            Image image = runButton.image;
            runButton.image.color = new Color(image.color.r, image.color.g, image.color.b, 0.3f);
            mRun = false;
        }
        else
        {
            Image image = runButton.image;
            runButton.image.color = new Color(image.color.r, image.color.g, image.color.b, 1f);
            mRun = true;
        }
    }
    public void Attack()
    {
        if (!mAlive)
            return;
        mAttack = true;
    }
    public void Dead()
    {
        if (mDead)
        {
            mDead = false;
        }
        else
        {
            mDead = true;
        }
        if(mAlive)
        {
            Image image = runButton.image;
            deadButton.image.color = new Color(image.color.r, image.color.g, image.color.b, 1.0f);
            runButton.image.color = new Color(image.color.r, image.color.g, image.color.b, 0.3f);
            mRun = false;
        }
        else
        {
            Image image = runButton.image;
            deadButton.image.color = new Color(image.color.r, image.color.g, image.color.b, 0.3f);
        }
    }
}
