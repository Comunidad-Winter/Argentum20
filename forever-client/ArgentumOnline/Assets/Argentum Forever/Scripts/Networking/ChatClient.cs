/*
		Argentum Forever - Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
		gulfas@gmail.com
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Collections.Concurrent;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
using System.Linq;
using System.Xml;
using System.Globalization;
using UnityEngine.SceneManagement;
using TMPro;

public class ChatClient : MonoBehaviour {

	public bool IsSessionOpen(){
		return CryptoHelper.PublicKey.Length > 0;
	}

	public bool IsConnected(){
		if(mSocket == null){
			return false;
		}
		else {
			return mSocket.Connected;
		}
	}
	public void SetUsernameAndPassword(string u, string p){
		mUsername = u;
		mPassword = p;
	}

	public int ProcessChatJoinOkay(byte[] encrypted_character){
        var decrypted_char = CryptoHelper.Decrypt(encrypted_character,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
        mEventsQueue.Enqueue(Tuple.Create("CHAT_JOIN_OKAY",""));
		return 1;
	}
	public int ProcessCharacterLeftChat(byte[] encrypted_name){
        var decrypted_name = CryptoHelper.Decrypt(encrypted_name,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		mEventsQueue.Enqueue(Tuple.Create("CHARACTER_LEFT_CHAT",decrypted_name));
		return 1;
	}
	public int ProcessCharacterSaid(byte[] encrypted_data){
        var decrypted_chat = CryptoHelper.Decrypt(encrypted_data,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		try{
			//Can only be done from the main thread
			var ChatXml = new XmlDocument();
			ChatXml.LoadXml(decrypted_chat);
			mChatQueue.Enqueue(ChatXml);
		}
		catch (Exception e){
			Debug.Log("Failed to parse XML charjoined: " + e.Message);
			Debug.Assert(false);
		}
		return 1;
	}
	public int ProcessQOTD(byte[] encrypted_quote){
		Debug.Log("ProcessQOTD");
		var decrypted_q = CryptoHelper.Decrypt(encrypted_quote,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		mEventsQueue.Enqueue(Tuple.Create("QOTD",decrypted_q));
		return 1;
	}

	public int ProcessCharacterJoined(byte[] encrypted_joined_info){
		Debug.Log("ProcessCharacterJoined");
		Debug.Log("encrypted_joined_info len = " + Encoding.ASCII.GetString(encrypted_joined_info).Length + " "  + Encoding.ASCII.GetString(encrypted_joined_info) );
        var decrypted_info = CryptoHelper.Decrypt(encrypted_joined_info,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		Debug.Log("decrypted_data: " + decrypted_info);
		try{
			//Can only be done from the main thread
			var CharacterJoinedXml = new XmlDocument();
			CharacterJoinedXml.LoadXml(decrypted_info);
			mJoinedQueue.Enqueue(CharacterJoinedXml);
		}
		catch (Exception e){
			Debug.Log("Failed to parse XML charjoined: " + e.Message);
			Debug.Assert(false);
		}

		return 1;
	}
	public int ProcessChatJoinError(byte[] data){
		short error_code = ProtoBase.DecodeShort(data);
		var error_string = ProtoBase.LoginErrorCodeToString(error_code);
		mEventsQueue.Enqueue(Tuple.Create("LOGIN_ERROR_MSG_BOX_TITLE",error_string));
		return 1;
	}

	System.Diagnostics.Stopwatch mStopwatch;

	void Start (){
		Debug.Log("Initializing ChatClient");
		mIncommingData = new List<byte>();
		mAppQuit = false;
 		mStopwatch = new System.Diagnostics.Stopwatch();
		mStopwatch.Start();
	}
	public void SetMainMenu(MainMenu m){
		Debug.Assert(m!=null);
		mMainMenu = m;
	}
	void ShowMessageBox(string title, string message){
		Debug.Log("ShowMessageBox " + title + " " + message);
		mMainMenu.ShowMessageBox(title,message,true);
	}

	private Tuple<string, string, string, float,float> GetChatMessageFromXml(XmlDocument chat){
        var nodes = chat.SelectNodes("Chat");
        Debug.Assert(nodes.Count>0);
		string name;
		string pmap;
		string words;
		float fposx;
		float fposy;
		var nod = nodes[0];
        words  	= nod["Sentence"]["words"].InnerText;
		name  	= nod["Sentence"]["name"].InnerText;;
        pmap 	= nod["position"]["map"].InnerText;
        string xstr = nod["position"]["x"].InnerText;
        string ystr = nod["position"]["y"].InnerText;
        fposx = float.Parse(xstr, CultureInfo.InvariantCulture.NumberFormat);
        fposy = float.Parse(ystr, CultureInfo.InvariantCulture.NumberFormat);
		return Tuple.Create(name,words,pmap,fposx,fposy);
    }

	private Tuple<string, string, string, float,float> GetJoinedMessageFromXml(XmlDocument chat){
		var nodes = chat.SelectNodes("Spawn");
		Debug.Assert(nodes.Count>0);
		string uuid;
		string pmap;
		string name;
		float fposx;
		float fposy;
		var nod = nodes[0];
		name  	= nod["name"].InnerText;
		uuid   	= nod["uuid"].InnerText;
		pmap 	= nod["position"]["map"].InnerText;
		string xstr = nod["position"]["x"].InnerText;
		string ystr = nod["position"]["y"].InnerText;
		fposx = float.Parse(xstr, CultureInfo.InvariantCulture.NumberFormat);
		fposy = float.Parse(ystr, CultureInfo.InvariantCulture.NumberFormat);
		return Tuple.Create(uuid,name,pmap,fposx,fposy);
	}

	void Update(){
		try
		{
			if(!IsConnected()){
				Scene cur_scene = SceneManager.GetActiveScene();
				mStopwatch.Stop();
				if(cur_scene.name!="MainMenu"  && mStopwatch.ElapsedMilliseconds > 25000){
					Debug.Log("Reconnecting to chat server: " + mServerIP + ":" + mServerPort);
					this.ConnectToTcpServer(mServerIP,mServerPort);
					mStopwatch = System.Diagnostics.Stopwatch.StartNew();
				}
				else {
					mStopwatch.Start();
				}
			}
			GameObject p = GameObject.Find("ChatBox");

			while(mJoinedQueue.Count>0 && p!=null){
				XmlDocument e;
				if (mJoinedQueue.TryDequeue(out e)){
					Debug.Log("mJoinedQueue");
					if(p!=null){
						var cb = p.GetComponent<ChatBox>();
						var ji = GetJoinedMessageFromXml(e);
						cb.SendMessageToChatBox(ji.Item2 + " joined the game.", ChatMessage.MessageType.system);
					}
				}
			}


			if (mEventsQueue.Count > 0 && p!=null){

				Tuple<string, string> e;
				if (mEventsQueue.TryDequeue(out e)){
					Debug.Log("Event " + e.Item1);
					if(e.Item1 == "CHAT_JOIN_OKAY"){
						Debug.Log("CHAT_JOIN_OKAY");
					}
					else if(e.Item1 == "CHARACTER_LEFT_CHAT") {
						if(p!=null){
							var cb = p.GetComponent<ChatBox>();
							cb.SendMessageToChatBox(e.Item2 + " left the game.", ChatMessage.MessageType.system);
						}
					}
					else if(e.Item1 == "CHAT_JOIN_ERROR") {
						Debug.Log("CHAT_JOIN_ERROR");
						//ShowMessageBox("PLAY_CHARACTER_OKAY_TITLE","PLAY_CHARACTER_OKAY_TEXT");
					}
					else if(e.Item1 == "CHARACTER_JOINED") {

                    }
					else if(e.Item1 == "CHARACTER_SAID") {

                    }
					else if(e.Item1 == "QOTD") {
						if(p!=null){
							var cb = p.GetComponent<ChatBox>();
							cb.SendMessageToChatBox( "QOTD: " + e.Item2, ChatMessage.MessageType.system);
						}
                    }
					else if(e.Item1 == "CONNECTION_ERROR_MSGBOX_TITLE"){
						//ShowMessageBox("CONNECTION_ERROR_MSGBOX_TITLE",e.Item2);
						//TODO CREATE MESSAGE BOX TO NOTIFY USER ABOUT EVENTS
						Debug.Log("DECONECTADO DEL CHAT SERVER");

					}
					else{
						Debug.Assert(false);
					}
				}
			}

			while (mChatQueue.Count>0 && p!=null){
				XmlDocument e;
				if (mChatQueue.TryDequeue(out e)){
					//GameObject p = GameObject.Find("ChatBox");
					if(p!=null){
						var cb = p.GetComponent<ChatBox>();
						var ci = GetChatMessageFromXml(e);
						cb.SendMessageToChatBox( ci.Item1 + ": " +ci.Item2, ChatMessage.MessageType.player);
					}
				}
			}


		}
		catch (Exception e) {
			Debug.Log("Failed to read events" + e.Message);

		}
	}

    private void OnConnectionError(string title, string msg){
	   Debug.Log("mChatClientConnectionError " + msg);
	   mEventsQueue.Enqueue(Tuple.Create(title,msg));
    }

	private void CreateSendWorkload()
	{
		Debug.Log("CreateSendWorkload");
		if(mSendThread!=null){
			Debug.Log("Destroying thread " + mSendThread.Name);
			mSendThread.Abort();
			mSendThread = null;
		}
		try {
 			mSendThread = new Thread (new ThreadStart(WaitAndSendMessageWorkload));
			mSendThread.IsBackground = true;
			mSendThread.Start();
	    }
		catch (Exception e) {
			Debug.Log("WorldServer::On client connect exception " + e);
			OnConnectionError("Error", "CreateSendWorkload");
		}
	}

	private void CreateListenWorkload()
	{
		Debug.Log("CreateListenWorkload");
		if(mReceiveThread!=null){
			Debug.Log("Destroying thread " + mReceiveThread.Name);
			mReceiveThread.Abort();
			mReceiveThread = null;
		}
		try {
			mReceiveThread = new Thread (new ThreadStart(ListenForDataWorkload));
			mReceiveThread.IsBackground = true;
			mReceiveThread.Name = "ListenForDataWorkload" + DateTime.Now;
			Debug.Log("Creating thread " + " ListenForDataWorkload" + DateTime.Now);
			mReceiveThread.Start();
		}
		catch (Exception e) {
			Debug.Log("WorldServer::On client connect exception " + e);
			OnConnectionError("Error", "CreateListenWorkload");
		}
	}
	public void OnPlayerSays(string uuid, string map, float posx, float posy, string words)
	{
	   Debug.Log("WorldServer::OnPlayerSays!!!");
	   var p = new ProtoCharacterSays(uuid,map,posx,posy,words,CryptoHelper.Token);
	   SendMessage(p);
	}
   	private void OnConnectionEstablished()
   	{
	   Debug.Log("WorldServer::OnConnectionEstablished!!!");
	   ProtoPlayCharacter play_char_msg = new ProtoPlayCharacter("Seneca", CryptoHelper.Token,"CHAT_JOIN");
	   SendMessage(play_char_msg);
    }
	public void ConnectToTcpServer (string remote_ip, string remote_port, string operation="NOOP") {
		mOperationUponSessionOpened = operation;
		mAppQuit = false;
		if( mSocket!=null && mSocket.Connected )
		{
				Debug.Log("Already connected to the server!.");
				return;
		}
		Debug.Log("Trying ConnectToTcpServer " + remote_ip + ":" + remote_port);
		mServerIP = remote_ip;
		mServerPort = remote_port;
		CreateSendWorkload();
		CreateListenWorkload();
	}

	private int ProcessPacket(short id, byte[] data){
		Debug.Assert(ProcessFunctions.ContainsKey(id));
		return ProcessFunctions[id](this,data);
	}

	private void StopNetworkWorkloads(){
		if(mSocket!=null){
			mSocket.Close();
			mSocket = null;
		}
		if(mReceiveThread!=null){
			//mReceiveThread.Abort();
			mReceiveThread.Join();
			mReceiveThread = null;
		}
		if(mSendThread!=null){
			//mSendThread.Abort();
			mSendThread.Join();
			mSendThread =null;
		}

	}
	public void OnApplicationQuit(){
            Debug.Log("ChatClient Application ending after " + Time.time + " seconds");
			mAppQuit = true;
			StopNetworkWorkloads();
    }
	private void ListenForDataWorkload() {
		try
		{
			mSocket = new TcpClient();
			mSocket.LingerState = new LingerOption(true,0);
			//mSocket.ReceiveTimeout = 1000;
			//mSocket.SendTimeout = 1000;
			mSocket.NoDelay = true;
			mSocket.Connect(mServerIP, Convert.ToInt32(mServerPort));
			if(mSocket.Connected){
				OnConnectionEstablished();
			}
			//mSocket.GetStream().ReadTimeout = 1000;
			//mSocket.GetStream().WriteTimeout = 1000;
			Byte[] bytes = new Byte[1024*1024];
			while (!mAppQuit) {
				// Get a stream object for reading
				using (NetworkStream stream = mSocket.GetStream()){
					int length;
					if(stream.CanRead){
							while ((length = stream.Read(bytes, 0, bytes.Length)) != 0){
								// Copy the bytes received from the network to the array incommingData
								var incommingData = new byte[length];
								Array.Copy(bytes, 0, incommingData, 0, length);
								//Debug.Log("Read " + length + " bytes from server. " + incommingData + "{" + incommingData + "}");
								// Apprend the bytes to any excisting data previously received
								mIncommingData.AddRange(incommingData);
								//Attempt to build as many packets and process them
								//bool failed_to_build_packet = false;
								// We consume the packets
								while( mIncommingData.Count>=4 /*&& !failed_to_build_packet*/){
									var msg_size 	= mIncommingData.GetRange(2, 2).ToArray();
									//Debug.Log(" msg_size len " + msg_size.Length);
									var header	 	= mIncommingData.GetRange(0, 2).ToArray();
									short decoded_size = ProtoBase.DecodeShort(msg_size);
									if(decoded_size>mIncommingData.Count )
									{
										// not enough bytes to build packet
										break;
									}
									//Debug.Log(" Msg_size: " + decoded_size);
									short message_id = ProtoBase.DecodeShort(header);
									//Debug.Log(String.Format("{0,10:X}", header[0]) + " " + String.Format("{0,10:X}", header[1]));
									//failed_to_build_packet = (decoded_size > 1024);
									//Drop the heade and size fields
									var message_data	 	= mIncommingData.GetRange(4,decoded_size-4).ToArray();
									mIncommingData.RemoveRange(0,decoded_size);
									ProcessPacket(message_id, message_data);
								}
							}
					}
				}
			}
			Debug.Log("ListenForDataWorkload thread finished due to OnApplicationQuit event!");
		}

	    catch(ThreadAbortException e) {
            Debug.Log("Thread - caught ThreadAbortException - resetting.");
            Debug.Log("Exception message: {0}" + e.Message);
            //Thread.ResetAbort();
        }
		catch(Exception e){
			Debug.Log("ChatClient::ListenForDataWorkload::Exception: " + e.Message);
			OnConnectionError("CONNECTION_ERROR_MSGBOX_TITLE","CONNECTION_CLOSED_BY_SERVER_TEXT");
		}

		Debug.Log("ChatClient::ListenForDataWorkload finished");
	}

	private void WaitAndSendMessageWorkload() {
		while (!mAppQuit) {
			try {
				if( mSocket!=null && mSocket.Connected )
				{
					// Get a stream object for writing.
					NetworkStream stream = mSocket.GetStream();
					while (mSendQueue.Count > 0)
					{
						if (stream.CanWrite) {
							ProtoBase msg;
							if (mSendQueue.TryDequeue(out msg))
	      					{
								Debug.Assert(msg.Data()!=null);
                                try{
                                    stream.Write(msg.Data(), 0, msg.Size());
                                }
                                catch(IOException e){
    								Debug.Log("World::stream.write() Timeout: (" + e.Message  + ") " );
    							}

							}
						}
					}
				}
			}
			catch (SocketException socketException) {
				Debug.Log("Socket exception: " + socketException);
				//OnConnectionError(socketException);
			}
			catch(ThreadAbortException e) {
	            Debug.Log("Thread - caught ThreadAbortException - resetting.");
	            Debug.Log("Exception message: {0}" + e.Message);
	        }
			catch(Exception e){
				Debug.Log("Socket exception: " + e);
			}
		}
		Debug.Log("ChatClient::WaitAndSendMessageWorkload finished.");
	}

	/// <summary>
	/// Send message to server using socket connection.
	/// </summary>
	private void SendMessage(ProtoBase msg) {
		mSendQueue.Enqueue(msg);
	}

	private TcpClient 	mSocket;
	/*
		NetworkStream stream = mSocket.GetStream() will be accesed from two different threads: Receive and Send workloads.
		According to MS Documentation there is no need for a mutex as this is supposed to be thread safe when using just 2 threads:
		Read and write operations can be performed simultaneously on an instance of the NetworkStream class without the need
		for synchronization. As long as there is one unique thread for the write operations and one unique thread for the read
		operations, there will be no cross-interference between read and write threads and no synchronization is required.
	*/
	private List<byte>				mIncommingData;
	private Thread 					mReceiveThread;
	private Thread 					mSendThread;
	private string 					mServerIP;
	private string 					mServerPort;
	private string					mUsername;
	private string					mPassword;
	private MainMenu				mMainMenu;
	private bool					mAppQuit;
	private XmlCharacterParser 		mPlayerCharacter;
	// Construct a ConcurrentQueue for Sending messages to the server
    private ConcurrentQueue<ProtoBase> mSendQueue = new ConcurrentQueue<ProtoBase>();
	// Connection events queue
	private ConcurrentQueue<Tuple<string, string>> mEventsQueue = new ConcurrentQueue<Tuple<string, string>>();
	private ConcurrentQueue<XmlDocument> mChatQueue = new ConcurrentQueue<XmlDocument>();
	private ConcurrentQueue<XmlDocument> mJoinedQueue = new ConcurrentQueue<XmlDocument>();

	private string mOperationUponSessionOpened = "NOOP";
	private Dictionary<string, string> UUID2Name = new Dictionary<string,string>();

	private static Dictionary<short, Func<ChatClient, byte[], int>> ProcessFunctions
        = new Dictionary<short, Func<ChatClient, byte[], int>>
    {
		{ ProtoBase.ProtocolNumbers["CHAT_JOIN_OKAY"], (@this, x) => @this.ProcessChatJoinOkay(x) },
		{ ProtoBase.ProtocolNumbers["CHAT_JOIN_ERROR"], (@this, x) => @this.ProcessChatJoinError(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_JOINED"], (@this, x) => @this.ProcessCharacterJoined(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_LEFT_CHAT"], (@this, x) => @this.ProcessCharacterLeftChat(x) },
		{ ProtoBase.ProtocolNumbers["QOTD"], (@this, x) => @this.ProcessQOTD(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_SAID"], (@this, x) => @this.ProcessCharacterSaid(x) }
    };
	private XmlDocument				mPlayerCharacterXml;



}
