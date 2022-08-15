using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class DayLightingColliderShape {
	public DayLightingCollider2D.MaskType maskType = DayLightingCollider2D.MaskType.Sprite;
    public DayLightingCollider2D.ColliderType colliderType = DayLightingCollider2D.ColliderType.SpriteCustomPhysicsShape;

    public float height = 1;

	///// Shape in Polygons /////
	public List<Polygon2D> shapePolygons = null;

	private CustomPhysicsShape customPhysicsShape = null;

    private SpriteRenderer spriteRenderer;

	public Transform transform;

    private Sprite sprite;

    public void Reset() {
        shapePolygons = null;

        sprite = null;

        spriteRenderer = null;

        customPhysicsShape = null;
    }

	public List<Polygon2D> GetPolygons() {
		if (shapePolygons == null) {
			switch(colliderType) {
				case DayLightingCollider2D.ColliderType.SpriteCustomPhysicsShape:
                    SpriteRenderer spriteRenderer = GetSpriteRenderer();

					CustomPhysicsShape shape = GetPhysicsShape();
					shapePolygons = new List<Polygon2D>();

                    foreach(Polygon2D poly in shape.Get()) {
                        Polygon2D p = poly.Copy();

                        if (spriteRenderer.flipX) {
                            p.ToScaleItself(new Vector2(-1, 1));
                        }

                        if (spriteRenderer.flipY) {
                            p.ToScaleItself(new Vector2(1, -1));
                        }

                        shapePolygons.Add(p);
                    }

				break;

				case DayLightingCollider2D.ColliderType.Collider:
					shapePolygons = Polygon2DList.CreateFromGameObject(transform.gameObject);
				break;
			}
		}

		return(shapePolygons);
	}

    public Sprite GetSprite() {
        if (sprite == null) {
            sprite = GetSpriteRenderer().sprite;
        }
        return(sprite);
    }

    public SpriteRenderer GetSpriteRenderer() {
        if (spriteRenderer == null) {
            spriteRenderer = transform.GetComponent<SpriteRenderer>();
        }

        return(spriteRenderer);
    }
	
	public CustomPhysicsShape GetPhysicsShape() {
		if (customPhysicsShape == null) {
			SpriteRenderer spriteRenderer = GetSpriteRenderer();

			customPhysicsShape = CustomPhysicsShapeManager.RequesCustomShape(spriteRenderer.sprite);
		}
		return(customPhysicsShape);
	}
}
