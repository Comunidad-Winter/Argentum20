using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightingRoomCollider {

    static MeshVertice vertice;
    
    static public void Mask(Camera camera, LightingRoom2D id, Vector2D offset, float z) {
        MeshVertices vertices = id.shape.GetMesh_Vertices_MaskType(id.transform);

        if (vertices == null || vertices.veclist == null || vertices.veclist.Count < 1) {
           return;
        }

        Debug.Log("draw");

        GL.Color(id.color); // id.color

        Debug.Log(vertices.veclist.Count);

        for (int i = 0; i < vertices.veclist.Count; i ++) {
            vertice = vertices.veclist[i];
            Max2DMatrix.DrawTriangle(vertice.a, vertice.b, vertice.c, offset, z);
        }
    }
}
