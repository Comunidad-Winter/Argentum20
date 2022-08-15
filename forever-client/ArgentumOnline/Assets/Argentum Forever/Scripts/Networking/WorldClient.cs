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
using UnityEngine.SceneManagement;
using TMPro;

public class WorldClient : MonoBehaviour {
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
	public int ProcessPlayCharacterOkay(byte[] encrypted_character){
		Debug.Log("ProcessPlayCharacterOkay");
        Debug.Log("encrypted_character len = " + Encoding.ASCII.GetString(encrypted_character).Length + " "  + Encoding.ASCII.GetString(encrypted_character) );
        var decrypted_char = CryptoHelper.Decrypt(encrypted_character,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		Debug.Log("decrypted_data: " + decrypted_char);
		//Can only be done from the main thread
		try{
			mPlayerCharacterXml = new XmlDocument();
			mPlayerCharacterXml.LoadXml(decrypted_char);
			var wm = new WorldMessage();
			wm.mErrorStr = "";
			wm.mID  = "PLAY_CHARACTER_OKAY";
			mEventsQueue.Enqueue(wm);
		}
		catch (Exception e){
			Debug.Log("Failed to parse XML charfile: " + e.Message);
			var wm = new WorldMessage();
			wm.mErrorStr = "";
			wm.mID  = "PLAY_CHARACTER_ERROR";
			mEventsQueue.Enqueue(wm);
		}
		return 1;
	}
	public int ProcessCharacterLeftMap(byte[] encrypted_data){
		var uuid_len = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,0,2));
		var encrypted_uuid = ProtoBase.SliceArray(encrypted_data,2,uuid_len);
		var decrypted_uuid = CryptoHelper.Decrypt(encrypted_uuid,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var encrypted_map = ProtoBase.SliceArray(encrypted_data,2+uuid_len,encrypted_data.Length - (2+uuid_len) );
		string decrypted_map = CryptoHelper.Decrypt(encrypted_map,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var wm = new WorldMessage();
		wm.mUUID = decrypted_uuid;
		wm.mID  = "CHARACTER_LEFT_MAP";
		wm.mMap = decrypted_map;
		mEventsQueue.Enqueue(wm);
		return 1;
	}
	public int ProcessCharacterMelee(byte[] encrypted_data){
		var damage = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,0,2));
		var encrypted_uuid_len = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,2,2));
		var encrypted_uuid = ProtoBase.SliceArray(encrypted_data,4,encrypted_uuid_len);
		var decrypted_uuid = CryptoHelper.Decrypt(encrypted_uuid,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var wm = new WorldMessage();
		wm.mUUID = decrypted_uuid;
		wm.mID  = "CHARACTER_MELEE";
		wm.mMeleeDamage = damage;
		mEventsQueue.Enqueue(wm);
		return 1;
	}
	public int ProcessCharacterMoved(byte[] encrypted_data){
		var uuid_len = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,0,2));
		var encrypted_uuid = ProtoBase.SliceArray(encrypted_data,2,uuid_len);
		var decrypted_uuid = CryptoHelper.Decrypt(encrypted_uuid,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var nxny_len = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,2+uuid_len,2));
		var encrypted_nxny = ProtoBase.SliceArray(encrypted_data,4+uuid_len,nxny_len);
		string decrypted_nxny = CryptoHelper.Decrypt(encrypted_nxny,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var base64_decoded_array =  CryptoHelper.Base64DecodeString(Encoding.ASCII.GetBytes(decrypted_nxny));
		var nx = System.BitConverter.ToSingle(base64_decoded_array, 0);
		var ny = System.BitConverter.ToSingle(base64_decoded_array, 4);
		var wm = new WorldMessage();
		wm.mUUID = decrypted_uuid;
		wm.mID  = "CHARACTER_MOVED";
		wm.mX   = nx;
		wm.mY	= ny;
		mEventsQueue.Enqueue(wm);
		return 1;
	}
	public int ProcessCharacterNewPos(byte[] encrypted_data){
		var uuid_len = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,0,2));
		var encrypted_uuid = ProtoBase.SliceArray(encrypted_data,2,uuid_len);
		var decrypted_uuid = CryptoHelper.Decrypt(encrypted_uuid,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var nxny_len = ProtoBase.DecodeShort(ProtoBase.SliceArray(encrypted_data,2+uuid_len,2));
		var encrypted_nxny = ProtoBase.SliceArray(encrypted_data,4+uuid_len,nxny_len);
		string decrypted_nxny = CryptoHelper.Decrypt(encrypted_nxny,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		var base64_decoded_array =  CryptoHelper.Base64DecodeString(Encoding.ASCII.GetBytes(decrypted_nxny));
		var nx = System.BitConverter.ToSingle(base64_decoded_array, 0);
		var ny = System.BitConverter.ToSingle(base64_decoded_array, 4);
		var wm = new WorldMessage();
		wm.mUUID = decrypted_uuid;
		wm.mID  = "CHARACTER_NEWPOS";
		wm.mX   = nx;
		wm.mY	= ny;
		mEventsQueue.Enqueue(wm);
		return 1;
	}
	public int ProcessSpawnCharacter(byte[] encrypted_spawn_info){
		var decrypted_info = CryptoHelper.Decrypt(encrypted_spawn_info,Encoding.UTF8.GetBytes(CryptoHelper.PublicKey));
		try{
			//Can only be done from the main thread
			var SpawnCharacterXml = new XmlDocument();
			SpawnCharacterXml.LoadXml(decrypted_info);
			var wm = new WorldMessage();
			wm.mXml = SpawnCharacterXml;
			wm.mID  = "SPAWN_CHARACTER";
			mEventsQueue.Enqueue(wm);
		}
		catch (Exception e){
			Debug.Log("Failed to parse XML charfile: " + e.Message);
			Debug.Assert(false);
		}
		return 1;
	}
	public int ProcessPlayCharacterError(byte[] data){
		Debug.Log("ProcessPlayCharacterError");
		short error_code = ProtoBase.DecodeShort(data);
		var error_string = ProtoBase.LoginErrorCodeToString(error_code);
		var wm = new WorldMessage();
		wm.mErrorStr = error_string;
		wm.mID  = "LOGIN_ERROR_MSG_BOX_TITLE";
		mEventsQueue.Enqueue(wm);
		return 1;
	}

	void Start (){
		Debug.Log("Initializing WorldClient");
		mIncommingData = new List<byte>();
		mAppQuit = false;
		mSpawningPlayerCharacter = false;
		SetSceneLoaded(false);
		var debugUI = GameObject.Find("DebugUI");
		if(debugUI != null)
			debugUI.transform.localScale = new Vector3(0, 0, 0);

	}
	public void SetMainMenu(MainMenu m){
		Debug.Assert(m!=null);
		mMainMenu = m;
	}
	void ShowMessageBox(string title, string message){
		Debug.Log("ShowMessageBox " + title + " " + message);
		mMainMenu.ShowMessageBox(title,message,true);
	}

    void OnEnable(){
        Debug.Log("OnEnable called");
		SceneManager.sceneLoaded += OnSceneLoaded;
    }
	void OnDisable(){
       Debug.Log("OnDisable");
       SceneManager.sceneLoaded -= OnSceneLoaded;
    }
    void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        //Debug.Log("OnSceneLoaded: " + scene.name);
		SetSceneLoaded(true);
		if( mSpawningPlayerCharacter ){
			//Second step PLAY_CHARACTER_OKAY
			Debug.Log("Must spawn Player Character");
			InstantiatePlayerCharacterSprite();
		}else {
			if(mPlayerCharacter!=null){
				GameObject p = GameObject.Find(mPlayerCharacter.UUID());
				if(p != null){
					// If the server closed by server due to inactivity we
					// need to Destroy the Player Character
					if(scene.name == "MainMenu"){
						//We need this, otherwise we get multiple clones
                    	p.SetActive(false);
                    	Destroy(p);
						mSpawningPlayerCharacter = false;
						SetSceneLoaded(false);
					}
					else {
                    	var playerScript = p.GetComponent<OLD_Character>();
                    	p.transform.position = playerScript.GetTeleportingPos();
					}
                }
			}

		}
    }
	private XmlCharacterParser InstantiateCharacterFromXml(XmlDocument xml_doc,string selectnode){
		try{
			var pc = new XmlCharacterParser();
			pc.CreateFromXml(xml_doc,selectnode);
			return pc;
		}
		catch (Exception e){
			Debug.Log("Failed to create PlayerCharacter: " + e.Message);
			var wm = new WorldMessage();
			wm.mErrorStr = "";
			wm.mID  = "PLAY_CHARACTER_ERROR";
			mEventsQueue.Enqueue(wm);
		}
		return null;
	}

	private GameObject SpawnCharacter(string uuid, string name, string tag, Vector3 pos, GameObject clonable, GameObject parent, string color){
		var ClonedChar = Instantiate(clonable, pos, Quaternion.identity, parent.transform);
		ClonedChar.tag = tag;
		ClonedChar.name = uuid;
		var np_canvas = ClonedChar.transform.Find("CanvasPlayer").gameObject;
		var textName = np_canvas.transform.Find("TextName").GetComponent<TextMeshProUGUI>();
		Debug.Assert(textName!=null);
        textName.text = name+" ["+uuid+"]";
		var CharScript = ClonedChar.GetComponent<OLD_Character>();
		CharScript.SetColorSkin(color);
		if(tag == "Player"){
			CharScript.SetPlayerCharater(true);
		}
        else
        {
            CharScript.SetPlayerCharater(false);
        }
		return ClonedChar;
	}
	private void InstantiatePlayerCharacterSprite(){
		try{
			// Load character Prefab
			GameObject player = (GameObject)Resources.Load("Playable characters/Human");
			Debug.Assert(player != null, "Cannot find PLAYER in Resources prefabs");
			player.SetActive(false);
			// Clone plater, set position and name
			var pc_pos = mPlayerCharacter.Position();
			Vector3  v3pos = new Vector3(pc_pos.Item2,pc_pos.Item3, 0);
			Transform  char_pos = player.transform;
			char_pos.position =  v3pos;
			GameObject world = GameObject.Find("World");
			Debug.Assert(world != null);
			var new_player_character = SpawnCharacter(mPlayerCharacter.UUID(),mPlayerCharacter.Name(),"Player",char_pos.position,player,world, mPlayerCharacter.SkinColor());
			new_player_character.SetActive(true);
            //Set Main Camera positionand make it child of Player
            GameObject cameraObj = (GameObject)Resources.Load("Cameras/MainCamera");
            Debug.Assert(cameraObj != null, "Cannot find Camera in Resources prefabs");
            Vector3 cameraPos = new Vector3(v3pos.x, v3pos.y, -1);
            var mainCamera = Instantiate(cameraObj, cameraPos, Quaternion.identity, null);
            mainCamera.transform.SetParent(new_player_character.transform);
            new_player_character.transform.parent = null;
            DontDestroyOnLoad(new_player_character.gameObject);
            mSpawningPlayerCharacter = false;
		}
		catch (Exception e){
			Debug.Log("Failed to create PlayerCharacter: " + e.Message);
			var wm = new WorldMessage();
			wm.mErrorStr = "";
			wm.mID  = "PLAY_CHARACTER_ERROR";
			mEventsQueue.Enqueue(wm);

		}
	}
	void Update(){
		if (Input.GetKeyDown(KeyCode.Semicolon))
		{
			var graph = GameObject.Find("DebugUI").gameObject;
			Debug.Assert(graph!=null);
			if ( graph.transform.localScale.x == 0f){
				graph.transform.localScale = new Vector3(1, 1, 1);
			}
			else
				graph.transform.localScale = new Vector3(0, 0, 0);
		}


		try
		{
			if (mEventsQueue.Count > 0){
				WorldMessage e;
				if (mEventsQueue.TryPeek(out e)){
					if(mSceneLoaded && (e.mID == "CHARACTER_MOVED" || e.mID == "CHARACTER_MELEE" || e.mID== "CHARACTER_NEWPOS")){
						if(e.mID == "CHARACTER_MELEE" && e.mUUID == mPlayerCharacter.UUID()){
							//Notification to myself of the attack result: damage?
							Debug.Log("CHARACTER_MELEE Player damage = " + e.mMeleeDamage);
						}
						else {
							GameObject pc = GameObject.Find(e.mUUID);
							if(pc == null){
								//Client might have left
								Debug.Log("Ignoring Movement because cannot find player: " + e.mUUID);
							}
							else {
								Debug.Assert(pc!=null); //TODO FIX IF PC IS NOT ONLINE
								var p = pc.GetComponent<OLD_Character>();
								Debug.Assert(p!=null);
								p.PushMovement(Tuple.Create(ProtoBase.ProtocolNumbers[e.mID],e.mX,e.mY));
							}
						}
						mEventsQueue.TryDequeue(out e);
					}
					else if(e.mID == "SPAWN_CHARACTER"){
						XmlCharacterParser c = InstantiateCharacterFromXml(e.mXml,"Spawn");
						Scene cur_scene = SceneManager.GetActiveScene();
						if( c.Map() == cur_scene.name) {
							//Debug.Log("SPAWN_CHARACTER UUID:" + c.UUID() + " Prefab:" + c.Prefab() + " Color: " + c.SkinColor());
							var remove_char = GameObject.Find(e.mUUID);
							if(remove_char!=null){
								remove_char.SetActive(false);
								Destroy(remove_char);
							}

							GameObject player = (GameObject)Resources.Load(c.Prefab());
							Debug.Assert(player != null, "Cannot find Prefab, server is probably sending a prefab which does not exist in the client");
							player.SetActive(false);
							var spawn_pos = c.Position();
							Vector3  v3pos = new Vector3(spawn_pos.Item2,spawn_pos.Item3, 0);
							Transform  char_pos = player.transform;
							char_pos.position =  v3pos;
							GameObject world = GameObject.Find("World");
							Debug.Assert(world != null);
							char_pos.position =  v3pos; // + offset;
							var x = SpawnCharacter(c.UUID(), c.Name(),"Human",char_pos.position,player,world, c.SkinColor());
							x.SetActive(true);
							mEventsQueue.TryDequeue(out e);
						}
						else {
							Debug.Log("Ignoring SPAWN_CHARACTER " + c.Name() + " " + "cur_scene= " + cur_scene.name + " requested scene= " + c.Map());
						}
					}
					else if(e.mID == "PLAY_CHARACTER_OKAY"){
						Debug.Log("PLAY_CHARACTER_OKAY");
						mSpawningPlayerCharacter = true;
						mPlayerCharacter = InstantiateCharacterFromXml(mPlayerCharacterXml,"Character");
						// The PLAY_CHARACTER_OKAY process has two steps:
						// 			First step: Load the new scene.
						//			Second step: Spawn the Character
						SceneManager.LoadScene(mPlayerCharacter.Position().Item1);
						// Set the flag to true to spawn the PC after scene loading
						mEventsQueue.TryDequeue(out e);
					}
					else if(e.mID == "CHARACTER_LEFT_MAP") {
						 // We may get a CHARACTER_LEFT_MAP while Loading scene
						 //Debug.Log("CHARACTER_LEFT_MAP");
						 Scene cur_scene = SceneManager.GetActiveScene();
  						 if( e.mMap == cur_scene.name) {
							var remove_char = GameObject.Find(e.mUUID);
						 	Debug.Assert(remove_char!=null);
						 	remove_char.SetActive(false);
						 	Destroy(remove_char);
						 }
						 else {
							 Debug.Log("Ignoring CHARACTER_LEFT_MAP " + e.mUUID + " " + e.mMap + " because scene is not ready");
						 }
						 mEventsQueue.TryDequeue(out e);
					}
					else if(e.mID == "PLAY_CHARACTER_ERROR") {
						Debug.Log("PLAY_CHARACTER_ERROR");
						//ShowMessageBox("PLAY_CHARACTER_OKAY_TITLE","PLAY_CHARACTER_OKAY_TEXT");
						mEventsQueue.TryDequeue(out e);
					}
					else if(e.mID == "CONNECTION_ERROR_MSGBOX_TITLE"){
						//ShowMessageBox("CONNECTION_ERROR_MSGBOX_TITLE",e.Item2);
						//TODO CREATE MESSAGE BOX TO NOTIFY USER ABOUT EVENTS
						Debug.Log("DECONECTADO DEL SERVIDOR");
						SceneManager.LoadScene("MainMenu");
						mEventsQueue.TryDequeue(out e);
					}
					else{
						//mSceneLoaded
						Debug.Log("Skipping command " + e.mID + " because mSceneLoaded == false");
					}
				}
			}
		}
		catch (Exception e) {
			Debug.Log("Failed to read events" + e.Message);

		}
	}

    private void OnConnectionError(string title, string msg){
	   Debug.Log("mWorldClientConnectionError " + msg);
	   var wm = new WorldMessage();
	   wm.mErrorStr = msg;
	   wm.mID  = title;
	   mEventsQueue.Enqueue(wm);
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
	public void OnPlayerMeleeAttacked(string victim_uuid)
	{
	   Debug.Log("WorldServer::OnPlayerMeleeAttacked!!!");
	   var p = new ProtoMeleeRequest(victim_uuid, CryptoHelper.Token);
	   SendMessage(p);
	}
	public void OnPlayerMoved(Vector3 newpos)
	{
	   //Debug.Log("WorldServer::OnPlayerMoved!!!");
	   var p = new ProtoMoveRequest(newpos, CryptoHelper.Token);
	   SendMessage(p);
	}
	public void OnPlayerOnEnterLoadScene(string scene, Vector3 newpos)
	{
		WorldMessage item;
		while (mEventsQueue.TryDequeue(out item));
	   	Debug.Log("WorldServer::OnPlayerMoved!!!");
	   	var p = new ProtoMapRequest(scene,newpos, CryptoHelper.Token);
	   	SendMessage(p);
	}
   	private void OnConnectionEstablished()
   	{
	   Debug.Log("WorldServer::OnConnectionEstablished!!!");
	   ProtoPlayCharacter play_char_msg = new ProtoPlayCharacter("Seneca", CryptoHelper.Token, "PLAY_CHARACTER");
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
            Debug.Log("WorldClient Application ending after " + Time.time + " seconds");
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
			Debug.Log("WorldClient::ListenForDataWorkload::Exception: " + e.Message);
			OnConnectionError("CONNECTION_ERROR_MSGBOX_TITLE","CONNECTION_CLOSED_BY_SERVER_TEXT");
		}

		Debug.Log("WorldClient::ListenForDataWorkload finished");
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
		Debug.Log("WorldClient::WaitAndSendMessageWorkload finished.");
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
	private bool					mSpawningPlayerCharacter;
	private bool					mSceneLoaded;
	// Called by OnEnterLoadScene to let know the WorldClient the scene loading is in progress
	// this is required knowledge to pause mActionQueue processing, specially SPAWN commands
	public  void					SetSceneLoaded(bool b) { mSceneLoaded = b;}
	private XmlCharacterParser 		mPlayerCharacter;
	// Construct a ConcurrentQueue for Sending messages to the server
    private ConcurrentQueue<ProtoBase> mSendQueue = new ConcurrentQueue<ProtoBase>();
	// Connection events queue
	struct WorldMessage {
		public	string		mErrorStr;
		public	string		mID;
		public	string		mUUID;
		public  int			mMeleeDamage;
		public	float		mX;
		public	float 		mY;
		public  string      mMap;
		public	XmlDocument mXml;
	};

	private ConcurrentQueue<WorldMessage> mEventsQueue = new ConcurrentQueue<WorldMessage>();
	private string mOperationUponSessionOpened = "NOOP";
	private static Dictionary<short, Func<WorldClient, byte[], int>> ProcessFunctions
        = new Dictionary<short, Func<WorldClient, byte[], int>>
    {
		{ ProtoBase.ProtocolNumbers["PLAY_CHARACTER_OKAY"], (@this, x) => @this.ProcessPlayCharacterOkay(x) },
		{ ProtoBase.ProtocolNumbers["PLAY_CHARACTER_ERROR"], (@this, x) => @this.ProcessPlayCharacterError(x) },
		{ ProtoBase.ProtocolNumbers["SPAWN_CHARACTER"], (@this, x) => @this.ProcessSpawnCharacter(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_LEFT_MAP"], (@this, x) => @this.ProcessCharacterLeftMap(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_MELEE"], (@this, x) => @this.ProcessCharacterMelee(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_NEWPOS"], (@this, x) => @this.ProcessCharacterNewPos(x) },
		{ ProtoBase.ProtocolNumbers["CHARACTER_MOVED"], (@this, x) => @this.ProcessCharacterMoved(x) }
	};
	private XmlDocument				mPlayerCharacterXml;



}
