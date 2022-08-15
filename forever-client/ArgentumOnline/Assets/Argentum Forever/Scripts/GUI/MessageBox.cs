using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class MessageBox : MonoBehaviour
{
    //public TextMesh mTitle;

    public void OnButtonOK(){
        this.transform.localScale = new Vector3(0, 0, 0);
    }
    // Start is called before the first frame update
    void Start()
    {
        /*
        Button b = GameObject.Find("ButtonOK").GetComponent<Button>();
        Debug.Assert(b!=null);

        Text TitleText = GameObject.Find("MsgBoxTitle").GetComponent<Text>(); //.GetComponent<Text>();

        Debug.Assert(TitleText!=null);
        TitleText.text = "aedfasdasd";
        Debug.Log("MessageBox.Start >>>>>>>>>>>>>>>>>>");
        */
    }


}
