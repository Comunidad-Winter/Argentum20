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

public class ProtoCodeRequest : ProtoBase
{
    public ProtoCodeRequest(string username, string email, string token)
    {
        Debug.Log("ProtoCodeRequest: " + username + " " + email);
        Debug.Assert(username.Length > 0);
        Debug.Assert(email.Length > 0);
        short header = EncodeShort(ProtoBase.ProtocolNumbers["CODE_REQUEST"]);
        var encrypted_username = CryptoHelper.Encrypt(username, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
        var encrypted_email = CryptoHelper.Encrypt(email, Encoding.ASCII.GetBytes(CryptoHelper.PublicKey));
        Debug.Log("encrypted username : " + Encoding.ASCII.GetString(encrypted_username));
        Debug.Log("Decrypted Token : " + CryptoHelper.Token);
        Debug.Log("encrypted email : " + Encoding.ASCII.GetString(encrypted_email));

        int buffer_size = /* header */ 4 + /* len(encrypted_username) */ 2 +
                           /* actual size of encrypted_username*/ encrypted_username.Length +
                           /* len(encrypted_password) */ 2 +
                           /* actual size of encrypted_email*/ encrypted_email.Length;

        short encoded_size = (short)EncodeShort((short)buffer_size);
        short encoded_len_username = (short)EncodeShort((short)encrypted_username.Length);
        short encoded_len_email = (short)EncodeShort((short)encrypted_email.Length);
        mBytes = new Byte[buffer_size];
        ProtoBase.WriteShortToArray(mBytes, 0, header);
        ProtoBase.WriteShortToArray(mBytes, 2, encoded_size);

        byte[] tmp = new byte[4 + encrypted_username.Length + encrypted_email.Length];
        // Write username and size to the tmp buffer
        ProtoBase.WriteShortToArray(tmp, 0, encoded_len_username);
        Array.Copy(encrypted_username, 0, tmp, 2, encrypted_username.Length);
        // Write password and size to the tmp buffer
        ProtoBase.WriteShortToArray(tmp, 2 + encrypted_username.Length, encoded_len_email);
        Array.Copy(encrypted_email, 0, tmp, 4 + encrypted_username.Length, encrypted_email.Length);
        Array.Copy(tmp, 0, mBytes, 4, tmp.Length);
    }
}
