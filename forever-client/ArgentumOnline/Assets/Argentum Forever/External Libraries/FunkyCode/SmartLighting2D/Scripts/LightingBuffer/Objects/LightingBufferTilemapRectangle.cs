using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_2018_1_OR_NEWER

public class LightingBufferTilemapRectangle : LightingBufferBase {

	static public void Shadow(LightingBuffer2D buffer, LightingTilemapCollider2D id, float lightSizeSquared, float z) {
		if (id.mapType != LightingTilemapCollider2D.MapType.UnityEngineTilemapRectangle) {
			return;
		}

		if (id.colliderType == LightingTilemapCollider2D.ColliderType.None) {
			return;
		}

		if (id.colliderType == LightingTilemapCollider2D.ColliderType.Collider) {
			return;
		}

		if (id.rectangleMap == null) {
			return;
		}
		
		if (id.rectangleMap.map == null) {
			return;
		}

		SetupLocation(buffer, id);

		Vector3 rot2 = Math2D.GetPitchYawRollRad(id.transform.rotation);
		float rotationXScale = Mathf.Sin(rot2.y + Mathf.PI / 2);
		float rotationYScale = Mathf.Sin(rot2.x + Mathf.PI / 2);

		posScale.x = id.properties.cellSize.x * id.transform.lossyScale.x * rotationXScale;
		posScale.y = id.properties.cellSize.y * id.transform.lossyScale.y * rotationYScale;

		scale.x = id.transform.lossyScale.x;
		scale.y = id.transform.lossyScale.y;

		for(int x = newPositionInt.x - sizeInt; x < newPositionInt.x + sizeInt; x++) {
			for(int y = newPositionInt.y - sizeInt; y < newPositionInt.y + sizeInt; y++) {
				if (x < 0 || y < 0 || x >= id.properties.arraySize.x || y >= id.properties.arraySize.y) {
					continue;
				}

				tile = id.rectangleMap.map[x, y];
				if (tile == null) {
					continue;
				}
			
				polygons = tile.GetPolygons(id);

				if (polygons == null || polygons.Count < 1) {
					continue;
				}

				polyOffset.x = (x + tilemapOffset.x) * posScale.x;
				polyOffset.y = (y + tilemapOffset.y) * posScale.y;
		
				polyOffset2.x = (float)polyOffset.x;
				polyOffset2.y = (float)polyOffset.y;

				if (tile.InRange(polyOffset2, buffer.lightSource.transform.position, 2 + buffer.lightSource.lightSize)) {
					LightingDebug.culled ++;
					continue;
				}

				if (x-1 > 0 && y-1 > 0 && x + 1 < id.properties.area.size.x && y + 1 < id.properties.area.size.y) {
					if (polyOffset2.x > buffer.lightSource.transform.position.x && polyOffset2.y > buffer.lightSource.transform.position.y) {
						LightingTile tileA = id.rectangleMap.map[x-1, y];
						LightingTile tileB = id.rectangleMap.map[x, y-1];
						LightingTile tileC = id.rectangleMap.map[x-1, y-1];
						if (tileA != null && tileB != null && tileC != null) {
							continue;
						}
					} else if (polyOffset2.x < buffer.lightSource.transform.position.x && polyOffset2.y > buffer.lightSource.transform.position.y) {
						LightingTile tileA = id.rectangleMap.map[x+1, y];
						LightingTile tileB = id.rectangleMap.map[x, y-1];
						LightingTile tileC = id.rectangleMap.map[x+1, y-1];
						if (tileA != null && tileB != null && tileC != null) {
							continue;
						}
					} else if (polyOffset2.x > buffer.lightSource.transform.position.x && polyOffset2.y < buffer.lightSource.transform.position.y) {
						LightingTile tileA = id.rectangleMap.map[x-1, y];
						LightingTile tileB = id.rectangleMap.map[x, y+1];
						LightingTile tileC = id.rectangleMap.map[x-1, y+1];
						if (tileA != null && tileB != null && tileC != null) {
							continue;
						}
					} else if (polyOffset2.x < buffer.lightSource.transform.position.x && polyOffset2.y < buffer.lightSource.transform.position.y) {
						LightingTile tileA = id.rectangleMap.map[x+1, y];
						LightingTile tileB = id.rectangleMap.map[x, y+1];
						LightingTile tileC = id.rectangleMap.map[x+1, y+1];
						if (tileA != null && tileB != null && tileC != null) {
							continue;
						}
					}
				}

				polyOffset.x += offset.x;
				polyOffset.y += offset.y;

				polygonPairs = tile.GetPairs(id);
			
				LightingBufferShadow.Draw(buffer, polygons, polygonPairs, lightSizeSquared, z, polyOffset, scale);
			} 
		}
	}

	public class WithAtlas {
		static public void MaskSprite(LightingBuffer2D buffer, LightingTilemapCollider2D id, float z) {
			if (id.mapType != LightingTilemapCollider2D.MapType.UnityEngineTilemapRectangle) {
				return;
			}

			if (id.maskType != LightingTilemapCollider2D.MaskType.Sprite) {
				return;
			}
			
			if (id.rectangleMap.map == null) {
				return;
			}

			SetupLocation(buffer, id);

			Vector3 rot2 = Math2D.GetPitchYawRollRad(id.transform.rotation);
			float rotationXScale = Mathf.Sin(rot2.y + Mathf.PI / 2);
			float rotationYScale = Mathf.Sin(rot2.x + Mathf.PI / 2);

			posScale.x = id.properties.cellSize.x * id.transform.lossyScale.x * rotationXScale;
			posScale.y = id.properties.cellSize.y * id.transform.lossyScale.y * rotationYScale;
	
			scale.x = id.transform.lossyScale.x;
			scale.y = id.transform.lossyScale.y;

			offset.x = -buffer.lightSource.transform.position.x;
			offset.y = -buffer.lightSource.transform.position.y;

			for(int x = newPositionInt.x - sizeInt; x < newPositionInt.x + sizeInt; x++) {
				for(int y = newPositionInt.y - sizeInt; y < newPositionInt.y + sizeInt; y++) {
					if (x < 0 || y < 0 || x >= id.properties.arraySize.x || y >= id.properties.arraySize.y) {
						continue;
					}

					tile = id.rectangleMap.map[x, y];
					if (tile == null) {
						continue;
					}

					if (tile.GetOriginalSprite() == null) {
						continue;
					}

					polyOffset.x = (x + tilemapOffset.x) * posScale.x;
					polyOffset.y = (y + tilemapOffset.y) * posScale.y;

					polyOffset2.x = (float)polyOffset.x;
					polyOffset2.y = (float)polyOffset.y;

					if (tile.InRange(polyOffset2, buffer.lightSource.transform.position, 2 + buffer.lightSource.lightSize)) {
						LightingDebug.culled ++;
						continue;
					}

					polyOffset.x += offset.x;
					polyOffset.y += offset.y;
					
					virtualSpriteRenderer.sprite = tile.GetAtlasSprite();

					if (virtualSpriteRenderer.sprite == null) {
						reqSprite = SpriteAtlasManager.RequestSprite(tile.GetOriginalSprite(), SpriteAtlasRequest.Type.WhiteMask);
						if (reqSprite == null) {
							// Add Partialy Batched
							batched = new PartiallyBatchedTilemap();

							batched.virtualSpriteRenderer = new VirtualSpriteRenderer();
							batched.virtualSpriteRenderer.sprite = tile.GetOriginalSprite();

							batched.polyOffset = polyOffset.ToVector2();

							batched.tileSize = scale;

							buffer.partiallyBatchedList_Tilemap.Add(batched);
							continue;
						} else {
							tile.SetAtlasSprite(reqSprite);
							virtualSpriteRenderer.sprite = reqSprite;
						}
					}

					polyOffset2.x = (float)polyOffset.x;
					polyOffset2.y = (float)polyOffset.y;

					LightingGraphics.WithAtlas.DrawSprite(virtualSpriteRenderer, buffer.lightSource.layerSetting[0], id.maskMode, polyOffset2, scale, 0, z);
					
					LightingDebug.maskGenerations ++;
				}	
			}
		}
	}

	public class WithoutAtlas {
		static public void MaskSprite(LightingBuffer2D buffer, LightingTilemapCollider2D id, Material materialA, Material materialB, float z) {
			if (id.mapType != LightingTilemapCollider2D.MapType.UnityEngineTilemapRectangle) {
				return;
			}

			if (id.maskType != LightingTilemapCollider2D.MaskType.Sprite) {
				return;
			}

			if (id.rectangleMap == null) {
				return;
			}
			
			if (id.rectangleMap.map == null) {
				return;
			}

			Material material;

			SetupLocation(buffer, id);

			Vector3 rot2 = Math2D.GetPitchYawRollRad(id.transform.rotation);
			float rotationXScale = Mathf.Sin(rot2.y + Mathf.PI / 2);
			float rotationYScale = Mathf.Sin(rot2.x + Mathf.PI / 2);

			posScale.x = id.properties.cellSize.x * id.transform.lossyScale.x * rotationXScale;
			posScale.y = id.properties.cellSize.y * id.transform.lossyScale.y * rotationYScale;

			scale.x = id.transform.lossyScale.x;
			scale.y = id.transform.lossyScale.x;

			bool maskEffect = (buffer.lightSource.layerSetting[0].effect == LightingLayerEffect.InvisibleBellow);
			bool invisible = (id.maskMode == LightingMaskMode.Invisible);

			offset.x = -buffer.lightSource.transform.position.x;
			offset.y = -buffer.lightSource.transform.position.y;

			for(int x = newPositionInt.x - sizeInt; x < newPositionInt.x + sizeInt; x++) {
				for(int y = newPositionInt.y - sizeInt; y < newPositionInt.y + sizeInt; y++) {
					if (x < 0 || y < 0 || x >= id.properties.arraySize.x || y >= id.properties.arraySize.y) {
						continue;
					}

					tile = id.rectangleMap.map[x, y];
					if (tile == null) {
						continue;
					}

					if (tile.GetOriginalSprite() == null) {
						return;
					}

					polyOffset.x = x + tilemapOffset.x;
					polyOffset.y = y + tilemapOffset.y;

					polyOffset.x *= posScale.x;
					polyOffset.y *= posScale.y;

					polyOffset2.x = (float)polyOffset.x;
					polyOffset2.y = (float)polyOffset.y;
					
					if (tile.InRange(polyOffset2, buffer.lightSource.transform.position, 2 + buffer.lightSource.lightSize)) {
						LightingDebug.culled ++;
						continue;
					}

					polyOffset.x += offset.x;
					polyOffset.y += offset.y;

					virtualSpriteRenderer.sprite = tile.GetOriginalSprite();

					polyOffset2.x = (float)polyOffset.x;
					polyOffset2.y = (float)polyOffset.y;

					if (invisible || (maskEffect && polyOffset2.y < 0)) {
						material = materialB;
					} else {
						material = materialA;
					}
					
					material.mainTexture = virtualSpriteRenderer.sprite.texture;
		
					LightingGraphics.WithoutAtlas.DrawSprite(material, virtualSpriteRenderer, polyOffset2, scale, 0, z);
					
					material.mainTexture = null;

					LightingDebug.maskGenerations ++;
				}	
			}
		}
	}

	static public void MaskShape(LightingBuffer2D buffer, LightingTilemapCollider2D id, float z) {
		if (id.mapType != LightingTilemapCollider2D.MapType.UnityEngineTilemapRectangle) {
			return;
		}
		
		if (false == (id.maskType == LightingTilemapCollider2D.MaskType.SpriteCustomPhysicsShape || id.maskType == LightingTilemapCollider2D.MaskType.Grid)) {
			return;
		}

		if (id.rectangleMap == null) {
			return;
		}

		if (id.rectangleMap.map == null) {
			return;
		}

		SetupLocation(buffer, id);

		Vector2 vecA, vecB, vecC;

		tileMesh = null;	

		int triangleCount;

		Vector3 rot2 = Math2D.GetPitchYawRollRad(id.transform.rotation);
		float rotationXScale = Mathf.Sin(rot2.y + Mathf.PI / 2);
		float rotationYScale = Mathf.Sin(rot2.x + Mathf.PI / 2);
		
		posScale.x = id.properties.cellSize.x * id.transform.lossyScale.x * rotationXScale;
		posScale.y = id.properties.cellSize.y * id.transform.lossyScale.y * rotationYScale;

		if (id.maskType == LightingTilemapCollider2D.MaskType.SpriteCustomPhysicsShape) {
			scale2D.x = id.transform.lossyScale.x;
			scale2D.y = id.transform.lossyScale.x;
		} else {
			scale2D.x = id.properties.cellSize.x * id.transform.lossyScale.x;
			scale2D.y = id.properties.cellSize.y * id.transform.lossyScale.x;
		}

		if (id.maskType == LightingTilemapCollider2D.MaskType.Grid) {
			tileMesh = LightingTile.GetStaticTileMesh(id);
		}

		GL.Color(Color.white);

		offset.x = -buffer.lightSource.transform.position.x;
		offset.y = -buffer.lightSource.transform.position.y;

		for(int x = newPositionInt.x - sizeInt; x < newPositionInt.x + sizeInt; x++) {
			for(int y = newPositionInt.y - sizeInt; y < newPositionInt.y + sizeInt; y++) {
				if (x < 0 || y < 0 || x >= id.properties.arraySize.x || y >= id.properties.arraySize.y) {
					continue;
				}

				tile = id.rectangleMap.map[x, y];
				if (tile == null) {
					continue;
				}
				
				polyOffset.x = x + tilemapOffset.x;
				polyOffset.y = y + tilemapOffset.y;

				polyOffset.x *= posScale.x;
				polyOffset.y *= posScale.y;

				polyOffset2.x = (float)polyOffset.x;
				polyOffset2.y = (float)polyOffset.y;

				if (tile.InRange(polyOffset2, buffer.lightSource.transform.position, 2 + buffer.lightSource.lightSize)) {
					LightingDebug.culled ++;
					continue;
				}

				polyOffset.x += offset.x;
				polyOffset.y += offset.y;

				if (id.maskType == LightingTilemapCollider2D.MaskType.SpriteCustomPhysicsShape) {
					tileMesh = null;
					tileMesh = tile.GetTileDynamicMesh();
				}

				if (tileMesh == null) {
					continue;
				}

				polyOffset2.x = (float)polyOffset.x;
				polyOffset2.y = (float)polyOffset.y;

				// Batch and Optimize???
				triangleCount = tileMesh.triangles.GetLength (0);
				for (int i = 0; i < triangleCount; i = i + 3) {
					vecA = tileMesh.vertices [tileMesh.triangles [i]];
					vecB = tileMesh.vertices [tileMesh.triangles [i + 1]];
					vecC = tileMesh.vertices [tileMesh.triangles [i + 2]];

					Max2DMatrix.DrawTriangle(vecA, vecB, vecC, polyOffset2, z, scale2D);
				}

				LightingDebug.maskGenerations ++;				
			}
		}
	}
	


















	static public void SetupLocation(LightingBuffer2D buffer, LightingTilemapCollider2D id) {
		sizeInt = LightTilemapSize(id, buffer);

		LightTilemapOffset(id, buffer);
		
		offset.x = -buffer.lightSource.transform.position.x;
		offset.y = -buffer.lightSource.transform.position.y;

		tilemapOffset.x = id.transform.position.x + id.properties.area.position.x + id.properties.cellAnchor.x;
		tilemapOffset.y = id.transform.position.y + id.properties.area.position.y + id.properties.cellAnchor.y;
	}

	static public int LightTilemapSize(LightingTilemapCollider2D id, LightingBuffer2D buffer) {
		Vector3 rot = Math2D.GetPitchYawRollRad(id.transform.rotation);

		float rotationXScale = Mathf.Sin(rot.y + Mathf.PI / 2);
		float rotationYScale = Mathf.Sin(rot.x + Mathf.PI / 2);
	
		float sx = 1f;
		sx /= id.properties.cellSize.x;
		sx /= id.transform.lossyScale.x;
		sx /= rotationXScale;

		float sy = 1f;
		sy /= id.properties.cellSize.y;
		sy /= id.transform.localScale.y;
		sy /= rotationYScale;

		float size = buffer.lightSource.lightSize + 1;
		size *= Mathf.Max(sx, sy);

		return((int) size);
	}

	static public void LightTilemapOffset(LightingTilemapCollider2D id, LightingBuffer2D buffer) {
		Vector2 newPosition = Vector2.zero;
		newPosition.x = buffer.lightSource.transform.position.x;
		newPosition.y = buffer.lightSource.transform.position.y;

		Vector3 rot = Math2D.GetPitchYawRollRad(id.transform.rotation);

		float rotationXScale = Mathf.Sin(rot.y + Mathf.PI / 2);
		float rotationYScale = Mathf.Sin(rot.x + Mathf.PI / 2);
	

		float sx = 1; 
		sx /= id.properties.cellSize.x;
		sx /= id.transform.lossyScale.x;
		sx /= rotationXScale;


		float sy = 1;
		sy /= id.properties.cellSize.y;
		sy /= id.transform.lossyScale.y;
		sy /= rotationYScale;


		newPosition.x *= sx;
		newPosition.y *= sy;

		Vector2 tilemapPosition = Vector2.zero;

		tilemapPosition.x -= id.properties.area.position.x;
		tilemapPosition.y -= id.properties.area.position.y;
		
		tilemapPosition.x -= id.transform.position.x;
		tilemapPosition.y -= id.transform.position.y;
			
		tilemapPosition.x -= id.properties.cellAnchor.x;
		tilemapPosition.y -= id.properties.cellAnchor.y;

		// Cell Size Is Not Calculated Correctly
		tilemapPosition.x += 1;
		tilemapPosition.y += 1;
		
		newPosition.x += tilemapPosition.x;
		newPosition.y += tilemapPosition.y;

		newPositionInt.x = (int)newPosition.x;
		newPositionInt.y = (int)newPosition.y;
	}
}

#endif
