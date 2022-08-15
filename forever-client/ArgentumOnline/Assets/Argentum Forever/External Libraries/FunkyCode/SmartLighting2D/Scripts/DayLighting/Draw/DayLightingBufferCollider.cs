using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayLightingBufferCollider  {
    const float uv0 = 0;
	const float uv1 = 1;
	const float pi2 = Mathf.PI / 2;

    static float angleA, angleB, angleC;

    static Vector2D zA = Vector2D.Zero(), zB = Vector2D.Zero(), zC = Vector2D.Zero();
	static Vector2D pA = Vector2D.Zero(), pB = Vector2D.Zero();
	static Vector2D objectOffset = Vector2D.Zero();
	static Vector2D vecA, vecB, vecC;
    
	static Vector2 objectOffset2;
	static Vector2 scale = Vector2.zero;

	static LightingManager2D manager;
    static DayLightingCollider2D id;
    static List<DayLightingCollider2D> colliderList;
	static VirtualSpriteRenderer virtualSpriteRenderer = new VirtualSpriteRenderer();
	static List<DoublePair2D> polygonPairs;
	static DoublePair2D p;

	static public void ShadowSprites(Camera camera, Vector2D offset, float z, int layer) {
		Material material = Lighting2D.materials.GetBlackSprite();

		colliderList = DayLightingCollider2D.GetList();
	
		for(int idd = 0; idd < colliderList.Count; idd++) {
			id = colliderList[idd];

			if ((int)id.layer != layer) {
				continue;
			}
		
			if (id.shape.colliderType != DayLightingCollider2D.ColliderType.Sprite) {
				continue;
			}
	
			VirtualSpriteRenderer virtualSpriteRenderer = new VirtualSpriteRenderer();
			virtualSpriteRenderer.sprite = id.shape.GetSprite();

			if (virtualSpriteRenderer.sprite == null) {
				continue;
			}
								
			float x = id.transform.position.x + (float)offset.x;
			float y = id.transform.position.y + (float)offset.y;

			float rot = Lighting2D.dayLightingSettings.sunDirection * Mathf.Deg2Rad;

			x += Mathf.Cos(rot) * id.shape.height;
			y += Mathf.Sin(rot) * id.shape.height;

			material.mainTexture = virtualSpriteRenderer.sprite.texture;

			Vector2 scale = new Vector2(id.transform.lossyScale.x, id.transform.lossyScale.y);

			LightingGraphics.WithoutAtlas.DrawSprite(material, virtualSpriteRenderer, new Vector2(x, y), scale, id.transform.rotation.eulerAngles.z, z);
		}
	}

    static public void Shadow(Camera camera, Vector2D offset, float z, int layer) {
        manager = LightingManager2D.Get();
		
		colliderList = DayLightingCollider2D.GetList();
	
		Lighting2D.materials.GetShadowBlur().SetPass (0);

		for(int idd = 0; idd < colliderList.Count; idd++) {
			id = colliderList[idd];

			if ((int)id.layer != layer) {
				continue;
			}

			if (id.shape.height < 0) {
				continue;
			}

			if (id.shape.colliderType == DayLightingCollider2D.ColliderType.Sprite) {
				continue;
			}

			DayLighting.ShadowMesh shadow = id.shadowMesh;

			if (shadow == null) {
				continue;
			}

			objectOffset.x = id.transform.position.x + offset.x;
			objectOffset.y = id.transform.position.y + offset.y;

			GL.Color(Color.black);

			Matrix4x4 matrix = Matrix4x4.TRS(new Vector3((float)objectOffset.x, (float)objectOffset.y, z), Quaternion.Euler(0, 0, 0), Vector3.one);
		
			foreach(Mesh mesh in shadow.meshes) {
				Graphics.DrawMeshNow(mesh, matrix);
			}
			
			/*

            // Fill
			for (int i = 0; i < shadow.meshTriangles.Count; i = i + 3) {
				vecA = shadow.meshVertices [shadow.meshTriangles [i]];
				vecB = shadow.meshVertices [shadow.meshTriangles [i + 1]];
				vecC = shadow.meshVertices [shadow.meshTriangles [i + 2]];
	
				GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
				GL.Vertex3((float)(vecA.x + objectOffset.x), (float)(vecA.y + objectOffset.y), z);
				GL.TexCoord3(Max2DMatrix.c_x, Max2DMatrix.c_y, 0);
				GL.Vertex3((float)(vecB.x + objectOffset.x), (float)(vecB.y + objectOffset.y), z);
				GL.TexCoord3(Max2DMatrix.c_x,Max2DMatrix. c_y, 0);
				GL.Vertex3((float)(vecC.x + objectOffset.x), (float)(vecC.y + objectOffset.y), z);
			}

			*/

			
			GL.Begin(GL.TRIANGLES);

			GL.Color(Color.white);

            // Penumbra
			if (Lighting2D.commonSettings.drawSunPenumbra) {
			
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
			}

			GL.End();
		}

		
	}

	public class WithoutAtlas {

		static public void Mask(Camera camera, Vector2D offset, float z, int layer) {
			Material material = Lighting2D.materials.GetWhiteSprite();
		
			for(int idd = 0; idd < colliderList.Count; idd++) {
				id = colliderList[idd];

				if ((int)id.layer != layer) {
					continue;
				}

				// Distance Check?
				//if (id.InCamera(camera) == false) {
				//	continue;
				//}

				switch(id.shape.maskType) {
					case DayLightingCollider2D.MaskType.None:
						continue;

					case DayLightingCollider2D.MaskType.Sprite:
						SpriteRenderer spriteRenderer = id.shape.GetSpriteRenderer();

						if (spriteRenderer == null || spriteRenderer.sprite == null) {
							break;
						}
											
						objectOffset2.x = id.transform.position.x + (float)offset.x;
						objectOffset2.y = id.transform.position.y + (float)offset.y;

						material.mainTexture = spriteRenderer.sprite.texture;

						scale = new Vector2(id.transform.lossyScale.x, id.transform.lossyScale.y);

						LightingGraphics.WithoutAtlas.DrawSprite(material, spriteRenderer, objectOffset2, scale, id.transform.rotation.eulerAngles.z, z);
					
					break;
				}

			}
		}
	}
}


			//if (id.colliderType == LightingCollider2D.ColliderType.Mesh) {
			//	continue;
			//}

			// Distance Check?
			//if (id.InCamera(camera) == false) {
			//	continue;
			//
  /*

  static public void Mask(Camera camera, Vector2D offset, float z) {
        manager = LightingManager2D.Get();

      

		colliderList = LightingCollider2D.GetList();

		scale.x = 1;
		scale.y = 1;

		

		if (Lighting2D.atlasSettings.lightingSpriteAtlas && SpriteAtlasManager.GetAtlasPage() != null) {
			WithAtlas.Mask(camera, offset, z);
		} else {
			WithoutAtlas.Mask(camera, offset, z);
		} 
	}


*/   




    /*


	class WithAtlas {
		static public void Mask(Camera camera, Vector2D offset, float z) {
			Lighting2D.materials.GetAtlasMaterial().SetPass(0);

			GL.Begin(GL.TRIANGLES);
			GL.Color(Color.white);

			for(int idd = 0; idd < colliderList.Count; idd++) {
				id = colliderList[idd];
				
				if (id.generateDayMask == false) {
					continue;
				}

				// Distance Check?
				if (id.InCamera(camera) == false) {
					continue;
				}

				switch(id.shape.maskType) {
					case LightingCollider2D.MaskType.Sprite:
						SpriteRenderer spriteRenderer = id.shape.GetSpriteRenderer();

						if (spriteRenderer == null || spriteRenderer.sprite == null) {
							break;
						}
											
						objectOffset2.x = id.transform.position.x + (float)offset.x;
						objectOffset2.y = id.transform.position.y + (float)offset.y;

						Sprite sprite = id.shape.GetAtlasSprite();
						if (sprite == null) {
							Sprite reqSprite = SpriteAtlasManager.RequestSprite(id.shape.GetOriginalSprite(), SpriteAtlasRequest.Type.WhiteMask);
							if (reqSprite == null) {
								PartiallyBatchedCollider batched = new PartiallyBatchedCollider();

								batched.collider = id;

								//buffer.partiallyBatchedList_Collider.Add(batched);
								return;
							} else {
								id.shape.SetAtlasSprite(reqSprite);
								sprite = reqSprite;
							}
						}

						virtualSpriteRenderer.sprite = sprite;

						LightingGraphics.WithAtlas.DrawSpriteDay(virtualSpriteRenderer, objectOffset2, scale, id.transform.rotation.eulerAngles.z, z);
					
					break;
				}
			}

			GL.End();
		}

	}

	
    }*/