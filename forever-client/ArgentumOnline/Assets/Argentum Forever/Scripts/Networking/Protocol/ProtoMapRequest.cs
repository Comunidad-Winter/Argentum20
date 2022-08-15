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

public class ProtoMapRequest : ProtoBase
{
	public ProtoMapRequest(string newmap, Vector3 pos, string token){
		short header = EncodeShort(ProtoBase.ProtocolNumbers["CHARACTER_MAP_REQ"]);
        var bytes_nxny = new Byte[8];
        byte[] bytes_nx = BitConverter.GetBytes(pos.x);
        byte[] bytes_ny = BitConverter.GetBytes(pos.y);
        bytes_nx.CopyTo(bytes_nxny,0);
        bytes_ny.CopyTo(bytes_nxny,4);
        byte[] b64encoded_bytes_nxny = CryptoHelper.EncryptBase64(bytes_nxny);
        var str_b64encoded= System.Text.Encoding.ASCII.GetString(b64encoded_bytes_nxny);
        var encrypted_nxny = CryptoHelper.Encrypt(str_b64encoded, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
        var encrypted_map = CryptoHelper.Encrypt(newmap, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
        int buffer_size = /* header */ 4 + /* actual size of encrypted_nxny*/ encrypted_nxny.Length +
                2 + encrypted_map.Length;
        short encoded_total_size = (short)EncodeShort((short)buffer_size);
        short encoded_size_encrypted_nxny = (short)EncodeShort((short) encrypted_nxny.Length);
        mBytes = new Byte[buffer_size];
        ProtoBase.WriteShortToArray(mBytes,0,header);
        ProtoBase.WriteShortToArray(mBytes,2,encoded_total_size);
        ProtoBase.WriteShortToArray(mBytes,4,encoded_size_encrypted_nxny);
        Array.Copy(encrypted_nxny,0, mBytes,6,encrypted_nxny.Length);
        Array.Copy(encrypted_map,0, mBytes,6+encrypted_nxny.Length,encrypted_map.Length);
    }
}
