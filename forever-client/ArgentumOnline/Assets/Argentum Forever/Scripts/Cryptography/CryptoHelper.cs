/*
		Argentum Forever - Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
		gulfas@gmail.com
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

using System.IO;
using System.Security.Cryptography;



public class CryptoHelper
{
		public static string PublicKey = null;
		public static string Token = null;

		public static byte[] PadArray(byte[] array){
			var al = array.Length;
			if( (al%16)!=0){
				Array.Resize(ref array, al + 100);
				for(int j=al; j < al+100; ++j){
					array[j]=0;
				}
			}
			return array;
		}

		public static byte[] Base64DecodeString(byte[] b64encoded){
			var d= System.Text.Encoding.ASCII.GetString(b64encoded).ToCharArray();
    		byte[] decodedByteArray = Convert.FromBase64CharArray(d, 0, d.Length);
    		return decodedByteArray;
		}

		public static byte[] DecryptBase64(byte[] data)
		{
     		FromBase64Transform tBase64 = new FromBase64Transform();
     		MemoryStream streamDecrypted = new MemoryStream();
     		CryptoStream stream = new CryptoStream(streamDecrypted, tBase64, CryptoStreamMode.Write);
     		stream.Write(data, 0, data.Length);
     		stream.FlushFinalBlock();
     		stream.Close();
     		return streamDecrypted.ToArray();
		}


		public static byte[] EncryptBase64(byte[] data)
		{
			ToBase64Transform tBase64 = new ToBase64Transform();
			MemoryStream streamDecrypted = new MemoryStream();
			CryptoStream stream = new CryptoStream(streamDecrypted, tBase64, CryptoStreamMode.Write);
			stream.Write(data, 0, data.Length);
			stream.FlushFinalBlock();
			stream.Close();
			return streamDecrypted.ToArray();
		}

		public static string Decrypt(byte[] input, byte[] key)
		{
			//TODO: Add mutex to ensure thread safety
			Debug.Assert(input.Length>0);
			Debug.Assert(key.Length>0);
			// Check arguments.
			if (input == null || input.Length <= 0)
				throw new ArgumentNullException("input");
			if (key == null || key.Length <= 0)
				throw new ArgumentNullException("Key");

			string plaintext = null;
			byte[] base64_decoded_array =  Base64DecodeString(input);
			var size_base64_decoded_array = base64_decoded_array.Length;
			base64_decoded_array = PadArray(base64_decoded_array);
			byte[] buffer = new byte[base64_decoded_array.Length];
			int offset =0;
			int num_read =0;
		  	using (Aes aesAlg = Aes.Create())
		  	{
				aesAlg.KeySize = 128;
				aesAlg.BlockSize = 128;
				aesAlg.FeedbackSize = 8;
				aesAlg.Mode = CipherMode.CFB;
				aesAlg.Padding = PaddingMode.Zeros;
				aesAlg.IV =  key;
				aesAlg.Key  = key;
				// Create a decryptor to perform the stream transform.
				ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
				// Create the streams used for decryption.
				using (MemoryStream memoryStream = new MemoryStream(base64_decoded_array)){
					using (CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read)){

						do {
							num_read = cryptoStream.Read(buffer,offset, 1);
							offset+=num_read;
						} while(offset<=size_base64_decoded_array-1);
						cryptoStream.Close();
					}

				}
			}
			// remove zeros padding which were added in the call above PadArray(base64_decoded_array);
			byte[] final_buffer = new byte[size_base64_decoded_array];
			Array.Copy(buffer, 0, final_buffer, 0, final_buffer.Length);
	    	plaintext = System.Text.Encoding.ASCII.GetString(final_buffer);
			return plaintext;
		}

		public static byte[] Encrypt(string plainText, byte[] Key)
		{
			//TODO: Add mutex to ensure thread safety
			Debug.Assert(plainText.Length>0);
			Debug.Assert(Key.Length>0);
			//Debug.Log("Encrypt plainText= " +plainText + " len " + plainText.Length);
            // Check arguments.
            if (plainText == null || plainText.Length <= 0)
                throw new ArgumentNullException("plainText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");
            byte[] encrypted;
            // Create an Aes object
            // with the specified key and IV.
            using (Aes aesAlg = Aes.Create())
            {
				aesAlg.KeySize = 128;
				aesAlg.BlockSize = 128;
				aesAlg.FeedbackSize = 8;
                aesAlg.Key = Key;
                aesAlg.Mode = CipherMode.CFB;
				aesAlg.Padding = PaddingMode.Zeros;
				aesAlg.IV =  Key;
                // Create an encryptor to perform the stream transform.
                ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
                // Create the streams used for encryption.
                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {
                            //Write all data to the stream.
                            swEncrypt.Write(plainText);
                        }
                        encrypted = msEncrypt.ToArray();
                    }
                }
            }
			//Debug.Log("encrypted.length = " + encrypted.Length);
            return EncryptBase64(encrypted);
		}
}
