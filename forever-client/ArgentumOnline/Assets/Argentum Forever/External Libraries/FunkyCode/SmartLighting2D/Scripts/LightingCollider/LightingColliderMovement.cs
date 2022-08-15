using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class LightingColliderMovement {
	public bool moved = false;

	private Vector2 movedPosition = Vector2.zero;
	private Vector2 movedScale = Vector3.zero;
	private float movedRotation = 0;
	
	private bool flipX = false;
	private bool flipY = false;

	public void Reset() {
		movedPosition = Vector2.zero;
		movedRotation = 0;
		movedScale = Vector3.zero;
	}

	public void Update(LightingColliderShape shape) {
		Vector2 position = shape.gameObject.transform.position;
		Vector2 scale = shape.gameObject.transform.lossyScale;
		float rotation = shape.gameObject.transform.rotation.eulerAngles.z;
		SpriteRenderer spriteRenderer = shape.GetSpriteRenderer();

		moved = false;

		if (movedPosition != position) {
			movedPosition = position;
			moved = true;
		}
				
		if (movedScale != scale) {
			movedScale = scale;
			moved = true;
		}

		if (movedRotation != rotation) {
			movedRotation = rotation;
			moved = true;
		}

		if (shape.maskType == LightingCollider2D.MaskType.SpriteCustomPhysicsShape || shape.colliderType == LightingCollider2D.ColliderType.SpriteCustomPhysicsShape) {
			if (spriteRenderer != null) {
				if (spriteRenderer.flipX != flipX || spriteRenderer.flipY != flipY) {
					flipX = spriteRenderer.flipX;
					flipY = spriteRenderer.flipY;

					moved = true;
					
					shape.ResetWorld();
				}
				
				if (shape.GetOriginalSprite() != spriteRenderer.sprite) {
					shape.SetOriginalSprite(spriteRenderer.sprite);
					shape.SetAtlasSprite(null); // Only For Sprite Mask?

					moved = true;
					
					shape.ResetLocal();
				}
			}
		}

		if (shape.maskType == LightingCollider2D.MaskType.Sprite) {
			if (spriteRenderer != null && shape.GetOriginalSprite() != spriteRenderer.sprite) {
				shape.SetOriginalSprite(spriteRenderer.sprite);
				shape.SetAtlasSprite(null);

				moved = true;
			}
		}
	}
}