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


// We send this OPEN_SESSION msg to the server to get the session TOKEN
public class ProtoOpenSession : ProtoBase
{
	public ProtoOpenSession() : base(4) {
		short header = EncodeShort(ProtoBase.ProtocolNumbers["OPEN_SESSION"]);
		mBytes = new byte[] { GetLowByte(header), GetHighByte(header), 0x00, 0x04 };
		Debug.Log("Ecoded " + mBytes);
	}
}
