using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteAtlasRequest {
    static public List<SpriteAtlasRequest> requestList = new List<SpriteAtlasRequest>();

    // Normal = Black Alpha
    public enum Type {Normal, WhiteMask, BlackMask};
    public Sprite sprite;
    public Type type;

    public SpriteAtlasRequest (Sprite s, Type t) {
        sprite = s;
        type = t;
    }

    static public void Update() {
        foreach(SpriteAtlasRequest req in requestList) {
            float timer = Time.realtimeSinceStartup;

            SpriteAtlasManager.RequestAccess(req.sprite, req.type);

            LightingDebug.atlasTimer += (Time.realtimeSinceStartup - timer);
        }

        requestList.Clear();
    }
}