/*
		Argentum Forever - Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
		gulfas@gmail.com
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
//Base class for all protocol messages
public class ProtoBase
{
	static public IDictionary<string,short> LoginProtocolErrors = new Dictionary<string,short>()
						{
							{"ACCOUNT_ALREADY_EXISTS"				, 0x00},
							{"ACCOUNT_DOESNT_EXIST"					, 0x01},
							{"CANNOT_OPEN_ACCOUNT_FILE"				, 0x02},
							{"CORRUPT_ACCOUNT_FILE"					, 0x03},
							{"USER_ALREADY_HOLDS_ACTIVE_SESSION"    , 0x04},
							{"WRONG_PASSWORD"						, 0x05},
							{"USER_IS_BANNED"						, 0x06},
							{"REACHED_MAX_USER_COUNT"				, 0x07},
							{"VALIDATION_METHOD_FAILED"				, 0x08},
							{"MUST_ACTIVATE_ACCOUNT"				, 0x09},
							{"INVALID_ACTIVATION_CODE"				, 0x0A},
							{"ACCOUNT_ALREADY_ACTIVE"				, 0x0B},
							{"INVALID_EMAIL"						, 0x0C},
							{"INVALID_PUBLIC_KEY"					, 0x0D},
							{"PASSWORD_TOO_SHORT"					, 0x0E},
							{"PASSWORD_TOO_LONG"					, 0x0F},
							{"PASSWORD_IS_NOT_ALNUM"				, 0x10},
							{"OLD_PASSWORD_IS_NOT_VALID"			, 0x11},
							{"USERNAME_TOO_SHORT"					, 0x12},
							{"USERNAME_TOO_LONG"					, 0x13},
							{"USERNAME_IS_NOT_ALNUM"				, 0x14},
							{"INVALID_PASSWORD_RESET_CODE"			, 0x15},
							{"INVALID_PASSWORD_RESET_HOST"			, 0x16},
							{"TRY_LATER"							, 0x17},
							{"PASSWORD_CANNOT_CONTAIN_USERNAME"		, 0x18},
							{"INVALID_DELETE_CODE"					, 0x19},
							{"USERNAME_CANNOT_START_WITH_NUMBER"	, 0x20},
							{"PASSWORD_MUST_HAVE_ONE_UPPERCASE"		, 0x21},
							{"PASSWORD_MUST_HAVE_ONE_LOWERCASE"		, 0x22},
							{"PASSWORD_MUST_HAVE_TWO_NUMBERS"		, 0x23},
							{"CLOSED_MAINTENANCE"					, 0x24},
							{"CLOSED_BETA_TESTING"					, 0x25},
							{"NO_ERROR"								, 0xFF}
						};

	static public IDictionary<string,short> ProtocolNumbers = new Dictionary<string,short>()
                        {
							// Account
                        	{"OPEN_SESSION"			, unchecked((short)0x00AA)},
							{"SESSION_OPENED"		, unchecked((short)0xBBBB)},
							{"SESSION_ERROR"		, unchecked((short)0xBBB1)},
							{"LOGIN_REQUEST"		, unchecked((short)0xDEAD)},
							{"LOGIN_OKAY"       	, unchecked((short)0xAFA1)},
							{"LOGIN_ERROR"			, unchecked((short)0xAFA0)},
							{"SIGNUP_REQUEST"   	, unchecked((short)0xBEEF)},
							{"SIGNUP_OKAY"			, unchecked((short)0xBFB1)},
							{"SIGNUP_ERROR"			, unchecked((short)0xBFB0)},
							{"ACTIVATE_REQUEST"		, unchecked((short)0xBAAD)},
							{"ACTIVATE_OKAY"		, unchecked((short)0x7777)},
							{"ACTIVATE_ERROR"		, unchecked((short)0x8888)},
							{"CODE_REQUEST"			, unchecked((short)0xDAAB)},
						    {"CODE_REQ_OKAY"		, unchecked((short)0x1111)},
							{"CODE_REQ_ERROR"		, unchecked((short)0x2222)},
							{"NEW_PASSWORD"			, unchecked((short)0xFAAA)},
							{"NEW_PASSWORD_OKAY"	, unchecked((short)0x3333)},
							{"NEW_PASSWORD_ERROR"   , unchecked((short)0x4444)},
							{"FORGOT_PASSWORD"		, unchecked((short)0xCBCB)},
							{"FORGOT_PASSWORD_OKAY"	, unchecked((short)0x2014)},
							{"FORGOT_PASSWORD_ERROR", unchecked((short)0x2015)},
							{"RESET_PASSWORD"		, unchecked((short)0xFBFB)},
							{"RESET_PASSWORD_OKAY"	, unchecked((short)0x2016)},
							// WORLD
							{"PLAY_CHARACTER"		, unchecked((short)0xF001)},
							{"PLAY_CHARACTER_OKAY" 	, unchecked((short)0xF002)},
							{"PLAY_CHARACTER_ERROR"	, unchecked((short)0xF003)},
							{"SPAWN_CHARACTER"		, unchecked((short)0xF004)},
							{"CHARACTER_LEFT_MAP"	, unchecked((short)0xF005)},
							{"CHARACTER_MOVE_REQ"	, unchecked((short)0xF006)},
							{"CHARACTER_MOVED"		, unchecked((short)0xF007)},
							{"CHARACTER_MAP_REQ"	, unchecked((short)0xF008)},
							{"CHARACTER_MELEE_REQ"	, unchecked((short)0xF009)},
							{"CHARACTER_MELEE"		, unchecked((short)0xF00A)},
							{"CHARACTER_NEWPOS"		, unchecked((short)0xF00B)},
							// CHAT
							{"CHAT_JOIN"			, unchecked((short)0x1001)},
							{"CHAT_JOIN_ERROR" 		, unchecked((short)0x2003)},
							{"CHAT_JOIN_OKAY"		, unchecked((short)0x3002)},
							{"CHARACTER_JOINED"		, unchecked((short)0x4004)},
							{"CHARACTER_LEFT_CHAT"	, unchecked((short)0x5005)},
							{"CHARACTER_SAYS"		, unchecked((short)0x6006)},
							{"CHARACTER_SAID"		, unchecked((short)0x6007)},
							{"QOTD"					, unchecked((short)0x6008)}

						};

	static public string LoginErrorCodeToString(short code){
		foreach(var pair in LoginProtocolErrors)
		{
    		if(pair.Value == code) return pair.Key;
		}
		Debug.Assert(false);
		return "TRY_LATER";
	}
	static public string PrivateKey = "pablomarquezARG1";
	public ProtoBase(){}
	public ProtoBase(uint size) {
		mBytes = new Byte[size];
	}
	protected byte[] mBytes;
	public byte[] Data() { return mBytes; }
	public int Size() { return mBytes.Length; }
	static public byte GetHighByte(short s){
		byte ret = (byte)((s>>8)&0xFF);
		return ret;
	}
	static public byte GetLowByte(short s){
		byte ret = (byte)(s&0xFF);
		return ret;
	}
	static public void WriteShortToArray(byte[] dst, int index, short s){
		Debug.Assert(dst!=null);
		dst[index] = GetLowByte(s);
		dst[1+index] = GetHighByte(s);
	}
	static public short EncodeShort(short s){
		 /*
		 	Different computers use different conventions for ordering the bytes within multibyte integer values. Some computers put
			the most significant byte first (known as big-endian order) and others put the least-significant byte first (known as little-endian order).
			To work with computers that use different byte ordering, all integer values that are sent over the network are sent
			in network byte order which has the most significant byte first.

			The HostToNetworkOrder method converts multibyte integer values that are stored on the host system from the byte order
			used by the host to the byte order used by the network
		 */
		 return System.Net.IPAddress.HostToNetworkOrder(s);
	}
	static public short DecodeShort(byte[] bytes){
		Debug.Assert(bytes.Length==2);
		short in_as_short = BitConverter.ToInt16(bytes, 0);
		short i = System.Net.IPAddress.NetworkToHostOrder(in_as_short);
		return i;
	}
	static public byte[] SliceArray(byte[] source,int offset, int length)
	{
		var dst = new byte[length];
		Array.Copy(source, offset, dst, 0, length);
		return dst;
	}
	static public void print_bytes(byte[] array){}
}
