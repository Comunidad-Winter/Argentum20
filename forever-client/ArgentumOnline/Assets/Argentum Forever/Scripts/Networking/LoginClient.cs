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

public class LoginClient : MonoBehaviour {
	#region private members
	private TcpClient 	mLoginClient;
	private WorldClient mWorldClient;
	/*
		NetworkStream stream = mLoginClient.GetStream() will be accesed from two different threads: Receive and Send workloads.
		According to MS Documentation there is no need for a mutex as this is supposed to be thread safe when using just 2 threads:
		Read and write operations can be performed simultaneously on an instance of the NetworkStream class without the need
		for synchronization. As long as there is one unique thread for the write operations and one unique thread for the read
		operations, there will be no cross-interference between read and write threads and no synchronization is required.
	*/
	private List<byte>	mIncommingData;
	private Thread 		mReceiveThread;
	private Thread 		mSendThread;
	private string 		mServerIP;
	private string 		mServerPort;
	private string		mUsername;
	private string		mPassword;
	private string		mCode;
	private IDictionary<string,string>  mSignupData;
	private MainMenu	mMainMenu;
	private bool		mAppQuit;

	public bool IsSessionOpen(){
		return CryptoHelper.PublicKey.Length > 0;
	}

	public bool IsConnected(){
		if(mLoginClient == null){
			return false;
		}
		else {
			return mLoginClient.Connected;
		}
	}
	// Construct a ConcurrentQueue for Sending messages to the server
    private ConcurrentQueue<ProtoBase> mSendQueue = new ConcurrentQueue<ProtoBase>();
	// Connection events queue
	private ConcurrentQueue<Tuple<string, string>> mEventsQueue = new ConcurrentQueue<Tuple<string, string>>();
	#endregion

	private string mOperationUponSessionOpened = "NOOP";

	static Dictionary<short, Func<LoginClient, byte[], int>> ProcessFunctions
        = new Dictionary<short, Func<LoginClient, byte[], int>>
    {
        { ProtoBase.ProtocolNumbers["SESSION_OPENED"], (@this, x) => @this.ProcessSessionOpened(x) },
		{ ProtoBase.ProtocolNumbers["SESSION_ERROR"], (@this, x) => @this.ProcessSessionError(x) },
		{ ProtoBase.ProtocolNumbers["LOGIN_OKAY"], (@this, x) => @this.ProcessLoginOkay(x) },
		{ ProtoBase.ProtocolNumbers["LOGIN_ERROR"], (@this, x) => @this.ProcessLoginError(x) },
		{ ProtoBase.ProtocolNumbers["SIGNUP_OKAY"], (@this, x) => @this.ProcessSignupOkay(x) },
		{ ProtoBase.ProtocolNumbers["SIGNUP_ERROR"], (@this, x) => @this.ProcessSignupError(x) },
		{ ProtoBase.ProtocolNumbers["ACTIVATE_OKAY"], (@this, x) => @this.ProcessActivationOkay(x) },
		{ ProtoBase.ProtocolNumbers["ACTIVATE_ERROR"], (@this, x) => @this.ProcessActivationError(x) },
        { ProtoBase.ProtocolNumbers["CODE_REQ_OKAY"], (@this, x) => @this.ProcessCodeReqOk(x) },
        { ProtoBase.ProtocolNumbers["CODE_REQ_ERROR"], (@this, x) => @this.ProcessCodeReqError(x) }
    };
	public void SetActivationCode(string code){
		mCode = code;
	}
	public void SetUsernameAndPassword(string u, string p){
		mUsername = u;
		mPassword = p;
	}
	public void SetSignupData(IDictionary<string,string> data){
		mSignupData = data;
	}
	public int ProcessSessionOpened(byte[] encrypted_token){
		Debug.Log("ProcessOpenSession");
		/*
			We got the ENCRYPTED_SESSION_TOKEN.
			ENCRYPTED_SESSION_TOKEN looks like 9gGYkcl6LsVbz2NfdJBJzKJQWHEZmEj4wY6RuWyDBTiNOrwia4X5gyTzCZsGQc4ds5rO/SU637+hNyKphm6vaFB0NdKLPfBuIt3Qc1L65msjWdYwuVuUuqmeuIHrIQtl
			The ENCRYPTED_SESSION_TOKEN must be decrypted with the 'private key' and decoded as shown below:

			cipher = AES.new( "pablomarquezARG1" )
			DECRYPTED_SESSION_TOKEN = cipher.decrypt(base64.b64decode(ENCRYPTED_SESSION_TOKEN)).rstrip(PADDING)
			DECRYPTED_SESSION_TOKEN will be a 64 chars string like A84XWygJIoH8bAiaiRn9N/S2DObSpZvMuXxE5A0opGY5dzkjrjCRBTmoh7/PnUTmsO4gh9nLouzEiQQsIZS68g==

			The 'public key' is the first 16 chars of the DECRYPTED_SESSION_TOKEN. The 'public key' will be used to encrypt the username and password in the next and last step of the
		 */
		Debug.Assert(encrypted_token.Length>0);
		Debug.Log("ProcessSessionOpened data.len " + encrypted_token.Length + " " + encrypted_token);
		Debug.Log("encrypted_token(" + encrypted_token.Length + ") " + Encoding.ASCII.GetString(encrypted_token));
		CryptoHelper.Token	= CryptoHelper.Decrypt(encrypted_token,Encoding.ASCII.GetBytes(ProtoBase.PrivateKey));
		Debug.Log("Decrypted Token : " + CryptoHelper.Token);
		CryptoHelper.PublicKey = CryptoHelper.Token.Substring(0,16);

		{ //DEBUGGING, to be removed
			string golden = Encoding.ASCII.GetString(encrypted_token);
			var test_encrypted_token = CryptoHelper.Encrypt(CryptoHelper.Token, Encoding.ASCII.GetBytes(ProtoBase.PrivateKey));
			string silver = Encoding.ASCII.GetString(test_encrypted_token);
			Debug.Log("silver_token(" + silver.Length + ") " + silver);
			Debug.Log("golden_token(" + encrypted_token.Length + ") " + Encoding.ASCII.GetString(encrypted_token));
	    	Debug.Assert(silver == golden);
		}

		switch(mOperationUponSessionOpened)
		{
			 case "LOGIN_REQUEST":
			 	Debug.Log("Session opened, attempting to login into account.");
			 	var login_request = new ProtoLoginRequest(mUsername, mPassword, CryptoHelper.PublicKey);
			 	SendMessage(login_request);
				break;
		 	 case "SIGNUP_REQUEST":
			 	Debug.Log("Session opened, attempting to signup.");
			    var signup_request = new ProtoSignupRequest(mSignupData, CryptoHelper.PublicKey);
			    SendMessage(signup_request);
			   	break;
			case "ACTIVATE_REQUEST":
   			 	Debug.Log("Session opened, attempting to activate.");
   			    var activate_request = new ProtoActivateRequest(mUsername, mCode, CryptoHelper.PublicKey);
   			    SendMessage(activate_request);
   			   	break;
            case "CODE_REQUEST":
                Debug.Log("Session opened, attempting to resend activation code.");
                var code_request = new ProtoCodeRequest(mSignupData["USERNAME"], mSignupData["EMAIL"], CryptoHelper.PublicKey);
                SendMessage(code_request);
                break;
            default:
			  	break;
		}
		mOperationUponSessionOpened = "NOOP";
		return 1;
	}
	public int ProcessSessionError(byte[] data){
		Debug.Log("ProcessSessionError");
		var error_string = ProtoBase.LoginErrorCodeToString(data[0]);
		mEventsQueue.Enqueue(Tuple.Create("Cannot open session",error_string));
		return 1;
	}

	public int ProcessLoginOkay(byte[] data){
		Debug.Log("ProcessLoginOkay");
		mEventsQueue.Enqueue(Tuple.Create("LOGIN_OKAY",""));
		return 1;
	}
	public int ProcessLoginError(byte[] data){
		Debug.Log("ProcessLoginError");
		short error_code = ProtoBase.DecodeShort(data);
		var error_string = ProtoBase.LoginErrorCodeToString(error_code);
		mEventsQueue.Enqueue(Tuple.Create("LOGIN_ERROR_MSG_BOX_TITLE",error_string));
		return 1;
	}
	public int ProcessActivationOkay(byte[] data){
		Debug.Log("ProcessActivationOkay");
		mEventsQueue.Enqueue(Tuple.Create("ACTIVATE_OKAY",""));
		return 1;
	}
	public int ProcessActivationError(byte[] data){
		Debug.Log("ProcessActivationError");
		short error_code = ProtoBase.DecodeShort(data);
		var error_string = ProtoBase.LoginErrorCodeToString(error_code);
		mEventsQueue.Enqueue(Tuple.Create("LOGIN_ERROR_MSG_BOX_TITLE",error_string));
		return 1;
	}
    public int ProcessCodeReqOk(byte[] data)
    {
        Debug.Log("ProcessCodeReqOk");
        mEventsQueue.Enqueue(Tuple.Create("RESEND_CODE_OK", ""));
        return 1;
    }
    public int ProcessCodeReqError(byte[] data)
    {
        Debug.Log("ProcessCodeReqError");
        short error_code = ProtoBase.DecodeShort(data);
        var error_string = ProtoBase.LoginErrorCodeToString(error_code);
        mEventsQueue.Enqueue(Tuple.Create("ACTIVATE_MSG_BOX_TITLE", error_string));
        return 1;
    }
    public int ProcessSignupOkay(byte[] data){
		Debug.Log("ProcessSignupOkay");
		mEventsQueue.Enqueue(Tuple.Create("SIGNUP_OKAY",""));
		return 1;
	}
	public int ProcessSignupError(byte[] data){
		Debug.Log("ProcessSignupError");
		short error_code = ProtoBase.DecodeShort(data);
		var error_string = ProtoBase.LoginErrorCodeToString(error_code);
		mEventsQueue.Enqueue(Tuple.Create("SIGNUP_ERROR_MSG_BOX_TITLE",error_string));
		return 1;
	}
	void Start (){
		Debug.Log("Initializing ");
		mIncommingData = new List<byte>();
		mAppQuit = false;
	}
	public void SetMainMenu(MainMenu m){
		Debug.Assert(m!=null);
		mMainMenu = m;
	}
	void ShowMessageBox(string title, string message){
		Debug.Log("ShowMessageBox " + title + " " + message);
		mMainMenu.ShowMessageBox(title,message,true);
	}
	void Update(){
		try {
			if (mEventsQueue.Count > 0){
				Tuple<string, string> e;
				if (mEventsQueue.TryDequeue(out e)){

					if(e.Item1 == "SIGNUP_OKAY"){
						mMainMenu.OnAccountCreated();
					}
					else if(e.Item1 == "ACTIVATE_OKAY") {
						mMainMenu.OnAccountActivated();
					}
					else if(e.Item1 == "LOGIN_OKAY"){
						mMainMenu.OnLoginOkay();
					}
					else { // normal message box
						if(e.Item2 !=null){
							Debug.Log("Event {" + e.Item2 + "}");
							ShowMessageBox(e.Item1,e.Item2);
						}
						else{
							ShowMessageBox(e.Item1,"Whatever");
						}
					}
				}
			}
		}
		catch (Exception e) {
			Debug.Log("Failed to read events" + e.Message);
		}
	}

   private void OnConnectionError(string title, string msg){
	   Debug.Log("LoginServer::OnConnectionError " + msg);
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
			Debug.Log("LoginServer::On client connect exception " + e);
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
			Debug.Log("LoginServer::On client connect exception " + e);
			OnConnectionError("Error", "CreateListenWorkload");
		}
	}

	public void AttemptToLogin()
	{
		mOperationUponSessionOpened = "LOGIN_REQUEST";
		ProtoOpenSession open_session = new ProtoOpenSession();
 	  	SendMessage(open_session);
	}

	public void AttemptToActivate()
	{
		mOperationUponSessionOpened = "ACTIVATE_REQUEST";
		ProtoOpenSession open_session = new ProtoOpenSession();
 	  	SendMessage(open_session);
	}

	public void AttemptToSignup()
	{
		mOperationUponSessionOpened = "SIGNUP_REQUEST";
		ProtoOpenSession open_session = new ProtoOpenSession();
		SendMessage(open_session);
	}

    public void AttemptToReSendCode()
    {
        mOperationUponSessionOpened = "CODE_REQUEST";
        ProtoOpenSession open_session = new ProtoOpenSession();
        SendMessage(open_session);
    }

    private void OnConnectionEstablished()
   	{
	   Debug.Log("LoginServer::OnConnectionEstablished!!!");
	   ProtoOpenSession open_session = new ProtoOpenSession();
	   SendMessage(open_session);
   }
	public void ConnectToTcpServer (string remote_ip, string remote_port, string operation="NOOP") {
		mOperationUponSessionOpened = operation;
		mAppQuit = false;
		if( mLoginClient!=null && mLoginClient.Connected )
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
		if(mLoginClient!=null){
			mLoginClient.Close();
			mLoginClient = null;
		}
		if(mReceiveThread!=null){
			mReceiveThread.Abort();
			mReceiveThread.Join();
			mReceiveThread = null;
		}
		if(mSendThread!=null){
			mSendThread.Abort();
			mSendThread.Join();
			mSendThread =null;
		}

	}
	public void OnApplicationQuit(){
            Debug.Log("LoginClient Application ending after " + Time.time + " seconds");
			mAppQuit = true;
			StopNetworkWorkloads();
    }
	private void ListenForDataWorkload() {
		try {
			mLoginClient = new TcpClient();
			mLoginClient.LingerState = new LingerOption(true,0);
			mLoginClient.ReceiveTimeout = 1000;
			mLoginClient.SendTimeout = 1000;
			mLoginClient.NoDelay = true;
			mLoginClient.Connect(mServerIP, Convert.ToInt32(mServerPort));
			if(mLoginClient.Connected){
				OnConnectionEstablished();
			}
			Byte[] bytes = new Byte[1024];
			while (!mAppQuit) {
				// Get a stream object for reading
				using (NetworkStream stream = mLoginClient.GetStream()){
					int length;
					if(stream.CanRead){
							try {
									while ((length = stream.Read(bytes, 0, bytes.Length)) != 0){
										// Copy the bytes received from the network to the array incommingData
										var incommingData = new byte[length];
										Array.Copy(bytes, 0, incommingData, 0, length);
										Debug.Log("Read " + length + " bytes from server. " + incommingData + "{" + incommingData + "}");
										// Apprend the bytes to any excisting data previously received
										mIncommingData.AddRange(incommingData);
										//Attempt to build as many packets and process them
										bool failed_to_build_packet = false;
										// We consume the packets
										while( mIncommingData.Count>=4 && !failed_to_build_packet){
											var msg_size 	= mIncommingData.GetRange(2, 2).ToArray();
											var header	 	= mIncommingData.GetRange(0, 2).ToArray();
											short decoded_size = ProtoBase.DecodeShort(msg_size);
											short message_id = ProtoBase.DecodeShort(header);
											failed_to_build_packet = (decoded_size > 1024);
											//Drop the heade and size fields
											var message_data	 	= mIncommingData.GetRange(4,decoded_size-4).ToArray();
											mIncommingData.RemoveRange(0,decoded_size);
											ProcessPacket(message_id, message_data);
										}
									}
							}
							catch(IOException e){
								Debug.Log("Login::stream.read() Timeout: (" + e.Message  + ") " );
							}
					}
				}
			}
			Debug.Log("ListenForDataWorkload thread finished due to OnApplicationQuit event!");
		}
		catch (SocketException socketException){
			Debug.Log("Socket exception (" + socketException.ErrorCode  + ") " + socketException);
			switch(socketException.ErrorCode){
				case 10061:
					OnConnectionError("CONNECTION_ERROR_MSGBOX_TITLE","CONNECTION_ERROR_CANNOT_REACH_SERVER");
					break;
				default:
					break;
			}
			//OnConnectionError(socketException);
		}
		catch(ThreadAbortException e) {
            Debug.Log("Thread - caught ThreadAbortException - resetting.");
            Debug.Log("Exception message: {0}" + e.Message);
        }
		catch(Exception e){
			Debug.Log("Socket exception: " + e);
			//OnConnectionError(e);
		}

		Debug.Log("LoginClient::ListenForDataWorkload finished");
	}

	private void WaitAndSendMessageWorkload() {
		while (!mAppQuit) {
			try {
				if( mLoginClient!=null && mLoginClient.Connected )
				{
					// Get a stream object for writing.
					NetworkStream stream = mLoginClient.GetStream();
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
    								Debug.Log("Login::stream.write() Timeout: (" + e.Message  + ") " );
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
		Debug.Log("LoginCliet::WaitAndSendMessageWorkload finished.");
	}

	/// <summary>
	/// Send message to server using socket connection.
	/// </summary>
	private void SendMessage(ProtoBase msg) {
		mSendQueue.Enqueue(msg);
	}
}
