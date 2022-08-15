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

public class ProtoMoveRequest : ProtoBase
{
	public ProtoMoveRequest(Vector3 pos, string token){
		//Debug.Log("ProtoMoveRequest x:" + pos.x + " y:" + pos.y);
		short header = EncodeShort(ProtoBase.ProtocolNumbers["CHARACTER_MOVE_REQ"]);
        var bytes_nxny = new Byte[8];
        byte[] bytes_nx = BitConverter.GetBytes(pos.x);
        byte[] bytes_ny = BitConverter.GetBytes(pos.y);
        bytes_nx.CopyTo(bytes_nxny,0);
        bytes_ny.CopyTo(bytes_nxny,4);
        byte[] b64encoded_bytes_nxny = CryptoHelper.EncryptBase64(bytes_nxny);
        //Debug.Log("b64encoded nxny : " + Encoding.ASCII.GetString(b64encoded_bytes_nxny));
        var str_b64encoded= System.Text.Encoding.ASCII.GetString(b64encoded_bytes_nxny);
        var encrypted_nxny = CryptoHelper.Encrypt(str_b64encoded, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
        //Debug.Log("encrypted nxny : " + Encoding.ASCII.GetString(encrypted_nxny));
        int buffer_size = /* header */ 4 + /* actual size of encrypted_nxny*/ encrypted_nxny.Length;
        short encoded_size = (short)EncodeShort((short)buffer_size);
        mBytes = new Byte[buffer_size];
        ProtoBase.WriteShortToArray(mBytes,0,header);
        ProtoBase.WriteShortToArray(mBytes,2,encoded_size);
        Array.Copy(encrypted_nxny,0, mBytes,4,encrypted_nxny.Length);
	}
}
