using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public enum LightingMaskMode {Visible, Invisible};

[ExecuteInEditMode]
public class LightingCollider2D : MonoBehaviour {
	public enum MaskType {None, Sprite, Collider, SpriteCustomPhysicsShape, Mesh, SkinnedMesh};
	public enum ColliderType {None, Collider, SpriteCustomPhysicsShape, Mesh, SkinnedMesh};
	
	public delegate void LightCollision2DEvent(LightCollision2D collision);

	public LightingLayer lightingMaskLayer = LightingLayer.Layer1;
	public LightingLayer lightingCollisionLayer = LightingLayer.Layer1;

	public LightingMaskMode maskMode = LightingMaskMode.Visible;

	public event LightCollision2DEvent collisionEvents;

	public LightingColliderShape shape = new LightingColliderShape();

	private LightingColliderMovement movement = new LightingColliderMovement();

	public static List<LightingCollider2D> list = new List<LightingCollider2D>();

	public void Awake() {
		shape.SetGameObject(gameObject);
	}
	
	public void AddEvent(LightCollision2DEvent collisionEvent) {
		collisionEvents += collisionEvent;
	}

	public void CollisionEvent(LightCollision2D collision) {
		if (collisionEvents != null) {
			collisionEvents (collision);
		}
	}

	// 1.5f??
	public bool isVisibleForLight(LightingBuffer2D buffer) {
		if (Vector2.Distance(transform.position, buffer.lightSource.transform.position) > shape.GetFrustumDistance(transform) + buffer.lightSource.lightSize * 1.5f) {
			LightingDebug.culled ++;
			return(false);
		}

		return(true);
	}

	public bool InCamera(Camera camera) {
		float cameraSize = camera.orthographicSize;
		
		float distance = Vector2.Distance(transform.position, camera.transform.position);
		float size = Mathf.Sqrt((cameraSize * 2f) * (cameraSize * 2f)) + shape.GetFrustumDistance(transform);
		
        return (distance < size);
    }

	public void OnEnable() {
		list.Add(this);

		Initialize();

		UpdateNearbyLights();
	}

	public void OnDisable() {
		list.Remove(this);

		UpdateNearbyLights();
	}

	public void UpdateNearbyLights() {
		float distance = shape.GetFrustumDistance(transform);
		foreach (LightingSource2D id in LightingSource2D.GetList()) {
			bool draw = DrawOrNot(id);

			if (draw == false) {
				continue;
			}
			
			if (Vector2.Distance (id.transform.position, transform.position) < distance + id.lightSize) {
				id.movement.ForceUpdate();
			}
		}
	}

	static public List<LightingCollider2D> GetList() {
		return(list);
	}

	public void Initialize() {
		movement.Reset();
		movement.moved = true;

		shape.ResetLocal();
	}

	public bool DrawOrNot(LightingSource2D id) {
		if (id.layerSetting == null) {
			return(false);
		}

		for(int i = 0; i < id.layerSetting.Length; i++) {
			if (id.layerSetting[i] == null) {
				continue;
			}
			switch(id.layerSetting[i].type) {
				case LightingLayerType.Default:
					if (i == (int)lightingCollisionLayer || i == (int)lightingMaskLayer) {
						return(true);
					}
				break;

				case LightingLayerType.MaskOnly:
					if (i == (int)lightingMaskLayer) {
						return(true);
					}
				break;

				case LightingLayerType.ShadowOnly:
					if (i == (int)lightingCollisionLayer) {
						return(true);
					}
				break;
			}
		}
		return(false);
	}

	public void Update_Loop() {
		movement.Update(shape);

		if (movement.moved) {
			shape.ResetWorld();

			UpdateNearbyLights();
		}
	}
}