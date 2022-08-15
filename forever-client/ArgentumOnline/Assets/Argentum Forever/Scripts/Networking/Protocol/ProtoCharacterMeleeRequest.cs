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

public class ProtoMeleeRequest : ProtoBase
{
	public ProtoMeleeRequest(string vuuid, string token){
		//Debug.Log("ProtoMoveRequest x:" + pos.x + " y:" + pos.y);
		short header = EncodeShort(ProtoBase.ProtocolNumbers["CHARACTER_MELEE_REQ"]);
        var encrypted_vuuid = CryptoHelper.Encrypt(vuuid, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
        int buffer_size = /* header */ 4 + /* size of encrypted_vuuid*/ encrypted_vuuid.Length;
        short encoded_size = (short)EncodeShort((short)buffer_size);
        mBytes = new Byte[buffer_size];
        ProtoBase.WriteShortToArray(mBytes,0,header);
        ProtoBase.WriteShortToArray(mBytes,2,encoded_size);
        Array.Copy(encrypted_vuuid,0, mBytes,4,encrypted_vuuid.Length);
	}
}
