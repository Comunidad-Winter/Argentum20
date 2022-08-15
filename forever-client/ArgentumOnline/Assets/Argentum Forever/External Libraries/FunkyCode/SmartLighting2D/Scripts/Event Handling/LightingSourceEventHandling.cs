using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightingSourceEventHandling {
    public LightingSource2D lightingSource = null;

   	public List<LightingCollider2D> lightignEventCache = new List<LightingCollider2D>();

	public void UpdateEventHandling() {
		if (lightingSource == null) {
			return;
		}
		
		List<LightCollision2D> collisions = EventHandling_GetCollisions();
		EventHandling_RemoveHiddenCollisions(collisions);

		if (collisions.Count < 1) {
			for(int i = 0; i < lightignEventCache.Count; i++) {
				LightingCollider2D collider = lightignEventCache[i];
				
				LightCollision2D collision = new LightCollision2D();
				collision.lightSource = lightingSource;
				collision.collider = collider;
				collision.pointsColliding = null;
				collision.lightingEventState = LightingEventState.OnCollisionExit;

				collider.CollisionEvent(collision);
			}

			lightignEventCache.Clear();

			return;
		}
			
		List<LightingCollider2D> eventColliders = new List<LightingCollider2D>();

		foreach(LightCollision2D collision in collisions) {
			eventColliders.Add(collision.collider);
		}

		for(int i = 0; i < lightignEventCache.Count; i++) {
			LightingCollider2D collider = lightignEventCache[i];
			if (eventColliders.Contains(collider) == false) {
				
				LightCollision2D collision = new LightCollision2D();
				collision.lightSource = lightingSource;
				collision.collider = collider;
				collision.pointsColliding = null;
				collision.lightingEventState = LightingEventState.OnCollisionExit;

				collider.CollisionEvent(collision);
				
				lightignEventCache.Remove(collider);
			}
		}
		
		foreach(LightCollision2D collision in collisions) {
			if (lightignEventCache.Contains(collision.collider)) {
				collision.lightingEventState = LightingEventState.OnCollision;
			} else {
				collision.lightingEventState = LightingEventState.OnCollisionEnter;
				lightignEventCache.Add(collision.collider);
			}
		
			collision.collider.CollisionEvent(collision);
		}









	}

	public void UpdateTilemapEventHandling() {
		/*
		List<LightTilemapCollision2D> collisions = EventHandling_GetCollisions();
		EventHandling_RemoveHiddenCollisions(collisions);

		if (collisions.Count < 1) {
			for(int i = 0; i < lightignEventCache.Count; i++) {
				LightingCollider2D collider = lightignEventCache[i];
				
				LightCollision2D collision = new LightCollision2D();
				collision.lightSource = this;
				collision.collider = collider;
				collision.pointsColliding = null;
				collision.lightingEventState = LightingEventState.OnCollisionExit;

				collider.CollisionEvent(collision);
			}

			lightignEventCache.Clear();

			return;
		}
			
		List<LightingCollider2D> eventColliders = new List<LightingCollider2D>();

		foreach(LightCollision2D collision in collisions) {
			eventColliders.Add(collision.collider);
		}

		for(int i = 0; i < lightignEventCache.Count; i++) {
			LightingCollider2D collider = lightignEventCache[i];
			if (eventColliders.Contains(collider) == false) {
				
				LightCollision2D collision = new LightCollision2D();
				collision.lightSource = this;
				collision.collider = collider;
				collision.pointsColliding = null;
				collision.lightingEventState = LightingEventState.OnCollisionExit;

				collider.CollisionEvent(collision);
				
				lightignEventCache.Remove(collider);
			}
		}
		
		foreach(LightCollision2D collision in collisions) {
			if (lightignEventCache.Contains(collision.collider)) {
				collision.lightingEventState = LightingEventState.OnCollision;
			} else {
				collision.lightingEventState = LightingEventState.OnCollisionEnter;
				lightignEventCache.Add(collision.collider);
			}
		
			collision.collider.CollisionEvent(collision);
		}*/
	}

	public List<LightCollision2D> EventHandling_GetCollisions() {
		List<LightCollision2D> collisions = new List<LightCollision2D>();
		List<LightingCollider2D> colliderList = LightingCollider2D.GetList();

		List<Vector2D> removePointsColliding = new List<Vector2D>();

		foreach (LightingCollider2D id in colliderList) {
			if (id.shape.colliderType == LightingCollider2D.ColliderType.None) {
				continue;
			}

			if (id.transform == null) {
				continue;
			}

			if (lightingSource == null) {
				continue;
			}

			if (Vector2.Distance(id.transform.position, lightingSource.transform.position) > id.shape.GetFrustumDistance(id.transform) + lightingSource.lightSize) {
				continue;
			}

			Polygon2D poly = id.shape.GetPolygons_Local_ColliderType(id.transform)[0].ToWorldSpace(id.transform);
			poly.ToOffsetItself(new Vector2D (-lightingSource.transform.position));

			LightCollision2D collision = new LightCollision2D();
			collision.lightSource = lightingSource;
			collision.collider = id;
			collision.pointsColliding = poly.pointsList;
			
			foreach(Vector2D point in collision.pointsColliding) {
				if (point.ToVector2().magnitude > lightingSource.lightSize) {
					removePointsColliding.Add(point);
				}
			}

			foreach(Vector2D point in removePointsColliding) {
				collision.pointsColliding.Remove(point);
			}
			removePointsColliding.Clear();

			collisions.Add(collision);
		}

		return(collisions);
	}

	public List<LightCollision2D> EventHandling_RemoveHiddenCollisions(List<LightCollision2D> collisions ) {
		List<LightingCollider2D> colliderList = LightingCollider2D.GetList();
		Vector2D zero = Vector2D.Zero();	
		float lightSizeSquared = Mathf.Sqrt(lightingSource.lightSize * lightingSource.lightSize + lightingSource.lightSize * lightingSource.lightSize);
		double rot;	
		
		Polygon2D triPoly = EventHandling_GetPolygon();

		Vector2D scale = new Vector2D(lightingSource.transform.lossyScale.x, lightingSource.transform.localScale.y);

		Pair2D p;
		Vector2D offset = Vector2D.Zero();
		VirtualSpriteRenderer virtualSpriteRenderer = new VirtualSpriteRenderer();

		List<Vector2D> removePointsColliding = new List<Vector2D>();
		List<LightCollision2D> removeCollisions = new List<LightCollision2D>();

		List<List<Pair2D>> pairs;

		foreach (LightingCollider2D id in colliderList) {
			if (Vector2.Distance(id.transform.position, lightingSource.transform.position) > id.shape.GetFrustumDistance(id.transform) + lightingSource.lightSize) {
				continue;
			}

			if (id.shape.colliderType == LightingCollider2D.ColliderType.None) {
				continue;
			}

			pairs = id.shape.GetPolygons_Pair_World_ColliderType(id.transform, virtualSpriteRenderer);

			if (pairs.Count < 1) {
				continue;
			}

			offset.x = - lightingSource.transform.position.x;
			offset.y = - lightingSource.transform.position.y;

			removePointsColliding.Clear();
			removeCollisions.Clear();

			for(int i = 0; i < pairs.Count; i++) {
				for(int x = 0; x < pairs[i].Count; x++) {
					p = pairs[i][x];

					vA.x = p.A.x * scale.x + offset.x;
					vA.y = p.A.y * scale.y + offset.y;

					vB.x = p.B.x * scale.x + offset.x;
					vB.y = p.B.y * scale.y + offset.y;

					vC.x = p.A.x * scale.x + offset.x;
					vC.y = p.A.y * scale.y + offset.y;

					vD.x = p.B.x * scale.x + offset.x;
					vD.y = p.B.y * scale.y + offset.y;
					
					rot = System.Math.Atan2 (vA.y, vA.x);
					vA.x += System.Math.Cos(rot) * lightSizeSquared;
					vA.y += System.Math.Sin(rot) * lightSizeSquared;

					rot = System.Math.Atan2 (vB.y, vB.x);
					vB.x += System.Math.Cos(rot) * lightSizeSquared;
					vB.y += System.Math.Sin(rot) * lightSizeSquared;

					triPoly.pointsList[0].x = vA.x;
					triPoly.pointsList[0].y = vA.y;

					triPoly.pointsList[1].x = vB.x;
					triPoly.pointsList[1].y = vB.y;

					triPoly.pointsList[2].x = vD.x;
					triPoly.pointsList[2].y = vD.y;

					triPoly.pointsList[3].x = vC.x;
					triPoly.pointsList[3].y = vC.y;

					foreach(LightCollision2D col in collisions) {
						if (col.collider == id) {
							continue;
						}

						foreach(Vector2D point in col.pointsColliding) {
							if (triPoly.PointInPoly(point)) {
								removePointsColliding.Add(point);
							}
						}

						foreach(Vector2D point in removePointsColliding) {
							col.pointsColliding.Remove(point);
						}

						removePointsColliding.Clear();
						
						if (col.pointsColliding.Count < 1) {
							removeCollisions.Add(col);
						}
					}

					foreach(LightCollision2D col in removeCollisions) {
						collisions.Remove(col);
					}

					removeCollisions.Clear();
				}
			}
		}
		return(collisions);
	}

	static Vector2D vA = Vector2D.Zero(), vB = Vector2D.Zero();
	static Vector2D vC = Vector2D.Zero(), vD = Vector2D.Zero();
	static Polygon2D eventPoly = null;

	static public Polygon2D EventHandling_GetPolygon() {
		if (eventPoly == null) {
			eventPoly = new Polygon2D();
			eventPoly.AddPoint(Vector2D.Zero());
			eventPoly.AddPoint(Vector2D.Zero());
			eventPoly.AddPoint(Vector2D.Zero());
			eventPoly.AddPoint(Vector2D.Zero());
		}
		return(eventPoly);
	}
}
