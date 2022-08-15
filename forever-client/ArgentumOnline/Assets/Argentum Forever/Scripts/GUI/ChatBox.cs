using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;

public class ChatBox : MonoBehaviour
{
    public int maxMessages = 25;
    public GameObject chatPanel, textObject;
    public InputField chatInput;
    public Color playerColorMsg, infoColorMsg, systemColorMsg, meColorMsg, wisperColorMsg;
    private bool panelView = true;
    private bool close = false;
    private ChatClient mChatClient;
    private float timeTextToHeadMax = 7.0f;
    private float timeTextToHeadLeft;
    private bool checkTextToHeadTime = false;

    [SerializeField]
    List<ChatMessage> messageList = new List<ChatMessage>();
    void Start()
    {
        timeTextToHeadLeft = timeTextToHeadMax;
        // setup the chat client
        GameObject chat_client_object = GameObject.FindGameObjectsWithTag("ChatClient")[0];
        mChatClient = chat_client_object.GetComponent<ChatClient>();
        Debug.Assert(mChatClient!=null);
    }

    void Update()
    {
        if (checkTextToHeadTime)
        {
            timeTextToHeadLeft -= Time.deltaTime;
            if (timeTextToHeadLeft < 0)
            {

                Debug.Log("ChekTime to Head is ZERO");
                GameObject player_object = GameObject.FindGameObjectsWithTag("Player")[0];
                Debug.Assert(player_object != null);
                var np_canvas = player_object.transform.Find("CanvasPlayer").gameObject;
                TextMeshProUGUI textToHead = np_canvas.transform.Find("TextToHead").GetComponent<TextMeshProUGUI>();
                Debug.Assert(textToHead != null);
                textToHead.text = "";
                timeTextToHeadLeft = timeTextToHeadMax;
                checkTextToHeadTime = false;
            }
        }
        if (close)
        {
            //if (Input.GetKeyDown(KeyCode.C))
            if (Input.GetKey(KeyCode.LeftControl) && Input.GetKeyDown(KeyCode.C))
            {
                GameObject mChatDialog = GameObject.Find("ChatDialog");
                Debug.Assert(mChatDialog != null);
                mChatDialog.transform.localScale = new Vector3(0.6f, 0.6f, 0);
                close = false;
            }
            return;
        }
        if (chatInput.text != "")
        {
            if (Input.GetKeyDown(KeyCode.Return))
            {
                SendMessageToChatBox(chatInput.text,  ChatMessage.MessageType.me);
                chatInput.text = "";
            }
        }
        else
        {
            //if (!chatInput.isFocused && Input.GetKeyDown(KeyCode.Return)) { }
                //chatInput.ActivateInputField();
        }
        /*if (Input.GetKeyDown(KeyCode.Space))
        {
            SendMessageToChatBox("System Message received...", ChatMessage.MessageType.system);
        }*/
    }

    public void SendMessageToChatBox(string text, ChatMessage.MessageType messageType = ChatMessage.MessageType.player)
    {
        if (messageList.Count >= maxMessages)
        {
            Destroy(messageList[0].textObject.gameObject);
            messageList.Remove(messageList[0]);
        }
        ChatMessage newMessage = new ChatMessage();
        newMessage.text = text;
        GameObject newText = Instantiate(textObject, chatPanel.transform);
        newMessage.textObject = newText.GetComponent<Text>();
        newMessage.textObject.text = newMessage.text;
        newMessage.textObject.color = MessageTypeColor(messageType);
        messageList.Add(newMessage);
        if (messageType == ChatMessage.MessageType.me){
            Debug.Assert(mChatClient!=null);
            GameObject player_object = GameObject.FindGameObjectsWithTag("Player")[0];
            Debug.Assert(player_object!=null);
            var np_canvas = player_object.transform.Find("CanvasPlayer").gameObject;
            TextMeshProUGUI textToHead = np_canvas.transform.Find("TextToHead").GetComponent<TextMeshProUGUI>();
            Debug.Assert(textToHead != null);
            textToHead.text = text;
            checkTextToHeadTime = true;
            var  char_pos = player_object.transform.position;
            var  words = newMessage.text;
            var active_scene = SceneManager.GetActiveScene();
            var sceneName = active_scene.name;
            var posx = char_pos.x;
            var posy = char_pos.y;
            var uuid = player_object.name;
            Debug.Log("ChatBox: " + words + " " + name + " " + posx.ToString() + " " + sceneName);
            mChatClient.OnPlayerSays(uuid, sceneName, posx, posy, words);
        }
    }

    Color MessageTypeColor(ChatMessage.MessageType messagetype)
    {
        Color color = meColorMsg;
        switch(messagetype)
        {
            case ChatMessage.MessageType.info:
                color = infoColorMsg;
                break;
            case ChatMessage.MessageType.system:
                color = systemColorMsg;
                break;
            case ChatMessage.MessageType.player:
                color = playerColorMsg;
                break;
            case ChatMessage.MessageType.wisper:
                color = wisperColorMsg;
                break;
        }
        return color;
    }
    public void MinimizeMaximize()
    {
        GameObject chatView = GameObject.Find("ChatView");
        Debug.Assert(chatView != null);
        var canvasGroup = chatView.GetComponent<CanvasGroup>();
        if (panelView)
        {
            chatView.transform.localScale = new Vector3(0, 0, 0);
            panelView = false;
        }
        else
        {
            chatView.transform.localScale = new Vector3(1, 1, 0);
            GameObject scrollView = GameObject.Find("ScrollView");
            ScrollRect scrollRect = scrollView.GetComponent<ScrollRect>();
            Debug.Assert(scrollRect != null);
            //Canvas.ForceUpdateCanvases();
            scrollRect.content.GetComponent<VerticalLayoutGroup>().CalculateLayoutInputVertical();
            scrollRect.content.GetComponent<ContentSizeFitter>().SetLayoutVertical();
            scrollRect.verticalNormalizedPosition = 0;
            panelView = true;
        }

    }
    public void Close()
    {
        GameObject mChatDialog = GameObject.Find("ChatDialog");
        Debug.Assert(mChatDialog != null);
        mChatDialog.transform.localScale = new Vector3(0, 0, 0);
        close = true;
    }
    //private ChatClient mChatClient;
}



[System.Serializable]
public class ChatMessage
{
    public string text;
    public Text textObject;
    public MessageType messageType;

    public enum MessageType
    {
        player,
        me,
        info,
        system,
        wisper
    }
}
