/*
		Argentum Forever - Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
		gulfas@gmail.com
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Text;
using UnityEngine;

public class ProtoSignupRequest : ProtoBase
{
	private string Dictionary2Json(IDictionary<string,string> user_data){
		string json_account = "{ \"username\": \"" + user_data["USERNAME"] + "\",";
		json_account += "\"password\": \"" + user_data["PASSWORD"]+ "\",";
		json_account += "\"language\": \"" + user_data["LANGUAGE"]+ "\",";
		json_account += "\"personal\": [{";
		json_account += "\"dob\": \"" + user_data["DOB"]+ "\",";
		json_account += "\"pob\": \"" + user_data["POB"]+ "\",";
		json_account += "\"email\": \"" + user_data["EMAIL"]+ "\",";
		json_account += "\"firstname\": \"" + user_data["FIRST_NAME"]+ "\",";
		json_account += "\"lastname\": \"" + user_data["LAST_NAME"]+ "\",";
		json_account += "\"lastname\": \"" + user_data["LAST_NAME"]+ "\",";
		json_account += "\"mobile\": \"" + user_data["MOBILE"]+ "\"}],";
		json_account += "\"passwordrecovery\": [{";
		json_account += "\"secretanswer1\": \"" + user_data["SECRETA1"]+ "\",";
		json_account += "\"secretanswer2\": \"" + user_data["SECRETA2"]+ "\",";
		json_account += "\"secretquestion1\": \"" + user_data["SECRETQ1"]+ "\",";
		json_account += "\"secretquestion2\": \"" + user_data["SECRETQ2"]+ "\"}]}";

		return json_account;
	}
	public ProtoSignupRequest(IDictionary<string,string> user_data, string token){
		Debug.Log("ProtoSignupRequest: " + user_data["USERNAME"]);
		Debug.Assert(user_data["USERNAME"].Length>0);
		Debug.Assert(user_data["PASSWORD"].Length>0);
		short header = EncodeShort(ProtoBase.ProtocolNumbers["SIGNUP_REQUEST"]);
		string json_account = Dictionary2Json(user_data);
		Debug.Log("Account :" + json_account);
		var encrypted_data = CryptoHelper.Encrypt(json_account, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
		Debug.Log("encrypted account : " + Encoding.ASCII.GetString(encrypted_data));

		int buffer_size = /* header */ 4 + encrypted_data.Length;
		short encoded_size = (short)EncodeShort((short)buffer_size);
		mBytes = new Byte[buffer_size];
		ProtoBase.WriteShortToArray(mBytes,0,header);
		ProtoBase.WriteShortToArray(mBytes,2,encoded_size);
		Array.Copy(encrypted_data, 0, mBytes, 4, encrypted_data.Length);
	}

}
