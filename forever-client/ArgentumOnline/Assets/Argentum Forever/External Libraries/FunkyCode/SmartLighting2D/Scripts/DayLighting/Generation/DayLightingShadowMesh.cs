using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DayLighting {
    
    public class ShadowMesh {
        public List<Polygon2D> polygons = new List<Polygon2D>();
        public List<List<DoublePair2D>> polygonsPairs = new List<List<DoublePair2D>>();

        public List<Vector2D> meshVertices = new List<Vector2D>();
        public List<int> meshTriangles = new List<int>();

        public List<Mesh> meshes = new List<Mesh>();

        public List<Mesh> blurMeshes = new List<Mesh>();

        public void Clear() {
            polygons.Clear();

            foreach(Mesh mesh in meshes) {
                UnityEngine.Object.DestroyImmediate(mesh);
            }

            foreach(Mesh mesh in blurMeshes) {
                UnityEngine.Object.DestroyImmediate(mesh);
            }
            
            meshes.Clear();
            blurMeshes.Clear();
            polygonsPairs.Clear();
            meshVertices.Clear();
            meshTriangles.Clear();
        }

        public void Generate(Transform transform, DayLightingColliderShape shape, float height) {
            List<Polygon2D> polys = shape.GetPolygons();

           
            Clear();

            
			if (shape.colliderType == DayLightingCollider2D.ColliderType.Sprite) {
                return;
			}

            if (polys == null) {
                return;
            }

            float direction = Lighting2D.dayLightingSettings.sunDirection * Mathf.Deg2Rad;

            foreach(Polygon2D polygon in polys) {
                if (polygon.pointsList.Count < 2) {
                    continue;
                }

                Polygon2D worldPolygon = polygon.ToScale(new Vector2(transform.localScale.x, transform.localScale.y)); 

                Sprite sprite = shape.GetSprite();

                if (sprite == null) {
                    continue;
                }

                worldPolygon.ToRotationItself(transform.rotation.eulerAngles.z * Mathf.Deg2Rad);

                Polygon2D polygonShadow = Polygon2D.GenerateShadow(worldPolygon, direction, height);

                List<DoublePair2D> polygonPairs = DoublePair2D.GetList(polygonShadow.pointsList);

                polygons.Add(polygonShadow.Copy());
                polygonsPairs.Add(polygonPairs);

                Polygon2D newPoly = polygonShadow.Copy();

                for(int i = 0; i < newPoly.pointsList.Count; i++) {
                    Vector2D a = newPoly.pointsList[(i - 1 + newPoly.pointsList.Count) % newPoly.pointsList.Count];
                    Vector2D b = newPoly.pointsList[i];
                    Vector2D c = newPoly.pointsList[(i + 1) % newPoly.pointsList.Count];

                   	float angle_a = (float)System.Math.Atan2 (a.y - b.y, a.x - b.x) + pi2;
                    float angle_c = (float)System.Math.Atan2 (b.y - c.y, b.x - c.x) + pi2;

                    b.x += System.Math.Cos(angle_a) * 0.001f;
                    b.y += System.Math.Sin(angle_a) * 0.001f;

                    b.x += System.Math.Cos(angle_c) * 0.001f;
                    b.y += System.Math.Sin(angle_c) * 0.001f;
                }

                Mesh mesh = newPoly.CreateMesh(Vector2.zero, Vector2.zero);
                meshes.Add(mesh);

                LightingDebug.ConvexHullGenerations ++;
            }


            foreach(Mesh m in meshes) {						
                for (int i = 0; i < m.vertices.GetLength (0); i ++) {
                    meshVertices.Add(new Vector2D(m.vertices [i]));
                }

                for (int i = 0; i < m.triangles.GetLength (0); i ++) {
                    meshTriangles.Add(m.triangles [i]);
                }
            }

    /*
                const float uv0 = 0;
	            const float uv1 = 1;


                for(int i = 0; i < shadow.polygonsPairs.Count; i++) {
					polygonPairs = shadow.polygonsPairs[i];

					for(int x = 0; x < polygonPairs.Count; x++) {
						p = polygonPairs[x];

						zA.x = p.A.x + objectOffset.x;
						zA.y = p.A.y + objectOffset.y;

						zB.x = p.B.x + objectOffset.x;
						zB.y = p.B.y + objectOffset.y;

						zC.x = zB.x;
						zC.y = zB.y;

						pA.x = zA.x;
						pA.y = zA.y;

						pB.x = zB.x;
						pB.y = zB.y;					

						float angleA = (float)System.Math.Atan2 (p.A.y - p.B.y, p.A.x - p.B.x) + pi2;
						float angleB = (float)System.Math.Atan2 (p.A.y - p.B.y, p.A.x - p.B.x) + pi2;
						float angleC = (float)System.Math.Atan2 (p.B.y - p.C.y, p.B.x - p.C.x) + pi2;

						zA.x += System.Math.Cos(angleA) * Lighting2D.dayLightingSettings.sunPenumbra;
						zA.y += System.Math.Sin(angleA) * Lighting2D.dayLightingSettings.sunPenumbra;

						zB.x += System.Math.Cos(angleB) * Lighting2D.dayLightingSettings.sunPenumbra;
						zB.y += System.Math.Sin(angleB) * Lighting2D.dayLightingSettings.sunPenumbra;

						zC.x += System.Math.Cos(angleC) * Lighting2D.dayLightingSettings.sunPenumbra;
						zC.y += System.Math.Sin(angleC) * Lighting2D.dayLightingSettings.sunPenumbra;

						GL.TexCoord3(uv0, uv0, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)pB.x, (float)pB.y, z);
						GL.TexCoord3(0.5f - uv0, uv0, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)pA.x, (float)pA.y, z);
						GL.TexCoord3(0.5f - uv0, uv1, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)zA.x, (float)zA.y, z);
					
						GL.TexCoord3(uv0, uv1, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)zA.x, (float)zA.y, z);
						GL.TexCoord3(0.5f - uv0, uv1, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)zB.x, (float)zB.y, z);
						GL.TexCoord3 (0.5f - uv0, uv0, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)pB.x, (float)pB.y, z);

						GL.TexCoord3(uv0, uv1, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)zB.x, (float)zB.y, z);
						GL.TexCoord3(0.5f - uv0, uv0, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)pB.x, (float)pB.y, z);
						GL.TexCoord3(0.5f - uv0, uv1, 0);
                        //GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
						GL.Vertex3((float)zC.x, (float)zC.y, z);

						
					}
				}


                */
        }

        // Unnecessary
        const float pi2 = Mathf.PI / 2;

        static Vector2D zA = Vector2D.Zero(), zB = Vector2D.Zero(), zC = Vector2D.Zero();
        static Vector2D pA = Vector2D.Zero(), pB = Vector2D.Zero();
        static Vector2D objectOffset = Vector2D.Zero();
        static Vector2D vecA, vecB, vecC;
    }     
}

