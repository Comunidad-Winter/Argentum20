/*
		Argentum Forever - Copyright 2020, Pablo Ignacio Marquez Tello aka Morgolock, All rights reserved.
		gulfas@gmail.com
*/
﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Xml;
using System.Xml.Linq;
using System.Globalization;

public class XmlCharacterParser
{

    public XmlCharacterParser(){
        mSkinColor = "10";
    }

    public void CreateFromXml(XmlDocument xml_doc,string selectnode){
        var nodes = xml_doc.SelectNodes(selectnode);
        Debug.Assert(nodes.Count>0);
        foreach (XmlNode nod in nodes)
        {
            mName   = nod["name"].InnerText;
            mUUID   = nod["uuid"].InnerText;
            mPrefab   = nod["prefab"].InnerText;
            var isNpc = nod.SelectSingleNode("npc");
            if (isNpc != null)
                mIsNPC = isNpc.InnerText;
            mMap = nod["position"]["map"].InnerText;
            string xstr = nod["position"]["x"].InnerText;
            string ystr = nod["position"]["y"].InnerText;
            float fx = float.Parse(xstr, CultureInfo.InvariantCulture.NumberFormat);
            float fy = float.Parse(ystr, CultureInfo.InvariantCulture.NumberFormat);
            mPos = Tuple.Create(fx,fy);
            var skinColor = nod.SelectSingleNode("skincolor");
            if (skinColor != null){
                mSkinColor = skinColor.InnerText;
            }
            var maxPhys = nod.SelectSingleNode("maxphysiological");
            if (maxPhys != null){
                mPhysMax[PhysiologicalTrait.HEALTH]  = System.UInt16.Parse(maxPhys["health"].InnerText);
                mPhysMax[PhysiologicalTrait.STAMINA]  = System.UInt16.Parse(maxPhys["stamina"].InnerText);
                mPhysMax[PhysiologicalTrait.MANA]  = System.UInt16.Parse(maxPhys["mana"].InnerText);
                mPhysMax[PhysiologicalTrait.THIRST]  = System.UInt16.Parse(maxPhys["thirst"].InnerText);
                mPhysMax[PhysiologicalTrait.HUNGER]  = System.UInt16.Parse(maxPhys["hunger"].InnerText);
            }
            var Phys = nod.SelectSingleNode("physiological");
            if (Phys != null){
                mPhysActual[PhysiologicalTrait.HEALTH]  = System.UInt16.Parse(Phys["health"].InnerText);
                mPhysActual[PhysiologicalTrait.STAMINA]  = System.UInt16.Parse(Phys["stamina"].InnerText);
                mPhysActual[PhysiologicalTrait.MANA]  = System.UInt16.Parse(Phys["mana"].InnerText);
                mPhysActual[PhysiologicalTrait.THIRST]  = System.UInt16.Parse(Phys["thirst"].InnerText);
                mPhysActual[PhysiologicalTrait.HUNGER]  = System.UInt16.Parse(Phys["hunger"].InnerText);
            }
        }
    }

    public ushort GetPhysiologicalTrait(PhysiologicalTrait t, bool max=false){
        if(max){
            return mPhysMax[t];
        }
        else{
            return mPhysActual[t];
        }
    }

    public Tuple<string,float,float> Position(){
        return Tuple.Create(mMap,mPos.Item1, mPos.Item2);
    }

    public string Name(){
        return mName;
    }
    public string Map(){
        return mMap;
    }
    public string UUID(){
        return mUUID;
    }
    public string SkinColor()
    {
        return mSkinColor;
    }
    public string Prefab(){
        return mPrefab;
    }
    private string mName;
    private string mUUID;
    private string mIsNPC;
    private string mPrefab;
    private Tuple<float,float> mPos;
    private string mMap;
    private string mSkinColor;
    private string mSize;

    public enum PhysiologicalTrait {
        HEALTH      = 1,
        STAMINA     = 2,
        MANA        = 3,
        THIRST      = 4,
        HUNGER      = 5
    };

    private Dictionary<PhysiologicalTrait,ushort> mPhysMax
            = new Dictionary<PhysiologicalTrait,ushort>
    {
		{ PhysiologicalTrait.HEALTH, 10 },
		{ PhysiologicalTrait.STAMINA, 10 },
		{ PhysiologicalTrait.MANA, 10 },
		{ PhysiologicalTrait.THIRST, 10 },
		{ PhysiologicalTrait.HUNGER, 10 }
	};
    private Dictionary<PhysiologicalTrait,ushort> mPhysActual
            = new Dictionary<PhysiologicalTrait,ushort>
    {
		{ PhysiologicalTrait.HEALTH, 10 },
		{ PhysiologicalTrait.STAMINA, 10 },
		{ PhysiologicalTrait.MANA, 10 },
		{ PhysiologicalTrait.THIRST, 10 },
		{ PhysiologicalTrait.HUNGER, 10 }
	};



}
