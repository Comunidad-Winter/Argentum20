using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class DayLightingColliderMovement {
	public bool moved = false;

	private Vector2 movedScale = Vector3.zero;
	private float movedRotation = 0;
	
	private bool flipX = false;
	private bool flipY = false;

	private float height = 0;

	private float sunDirection = 0;

	public void Reset() {
		movedRotation = 0;
		movedScale = Vector3.zero;
	}

	public void Update(DayLightingColliderShape shape) {
		Vector2 scale = shape.transform.lossyScale;
		float rotation = shape.transform.rotation.eulerAngles.z;
		SpriteRenderer spriteRenderer = shape.GetSpriteRenderer();

		moved = false;

		if (sunDirection != Lighting2D.dayLightingSettings.sunDirection) {
			sunDirection = Lighting2D.dayLightingSettings.sunDirection;

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

		if (height != shape.height) {
			height = shape.height;

			moved = true;
		}

		// Unnecesary check
		if (shape.height < 0.01f) {
			shape.height = 0.01f;
		}

		if (shape.colliderType == DayLightingCollider2D.ColliderType.SpriteCustomPhysicsShape) {
			if (spriteRenderer != null) {
				if (spriteRenderer.flipX != flipX || spriteRenderer.flipY != flipY) {
					flipX = spriteRenderer.flipX;
					flipY = spriteRenderer.flipY;

					moved = true;
					
					shape.Reset(); // World
				}
				
				/* Sprite frame change
				if (shape.GetOriginalSprite() != spriteRenderer.sprite) {
					shape.SetOriginalSprite(spriteRenderer.sprite);
					shape.SetAtlasSprite(null); // Only For Sprite Mask?

					moved = true;
					
					shape.Reset(); // Local
				}
				*/
			}
		}

		/* Sprite Frame Change
		if (shape.maskType == LightingCollider2D.MaskType.Sprite) {
			if (spriteRenderer != null && shape.GetOriginalSprite() != spriteRenderer.sprite) {
				shape.SetOriginalSprite(spriteRenderer.sprite);
				shape.SetAtlasSprite(null);

				moved = true;
			}
		}
		/*/
	}
}
