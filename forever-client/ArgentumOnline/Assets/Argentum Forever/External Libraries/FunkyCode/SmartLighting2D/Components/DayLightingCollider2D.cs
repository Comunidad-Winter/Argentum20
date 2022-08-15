using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DayLighting;

public enum DayLightingLayer {
	Layer1,
	Layer2,
	Layer3,
	Layer4
}

[ExecuteInEditMode]
public class DayLightingCollider2D : MonoBehaviour {
	public enum MaskType {None, Sprite};
    public enum ColliderType {None, SpriteCustomPhysicsShape, Collider, Sprite};

	public DayLightingLayer layer = DayLightingLayer.Layer1;
	
	public DayLightingColliderShape shape = new DayLightingColliderShape();
	public DayLightingColliderMovement movement = new DayLightingColliderMovement();

	public ShadowMesh shadowMesh = new ShadowMesh();
 
	public static List<DayLightingCollider2D> list = new List<DayLightingCollider2D>();

	public void OnEnable() {
		list.Add(this);

		shape.Reset();
		Generate();
	}

	public void OnDisable() {
		list.Remove(this);

		shape.Reset();
		Generate();
	}

	static public List<DayLightingCollider2D> GetList() {
		return(list);
	}

	void Awake() {
		shape.transform = transform;
	}

    void Update() {
		movement.Update(shape);

		if (movement.moved == true) {
			Generate();
		}
    }

	public void Generate() {
		shadowMesh.Generate(transform, shape, shape.height);
	}
}
