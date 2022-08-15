using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightingOcclusion2D : MonoBehaviour {
    public enum ColliderType {Collider, SpriteCustomPhysicsShape};
    public enum OcclusionType {Hard, Soft};

    public OcclusionType occlusionType = OcclusionType.Hard;
    public ColliderType colliderType = ColliderType.Collider;

	public float occlusionSize = 1f;

    private LightingOcclussionShape occlusionShape = null;

    private LightingColliderShape shape = new LightingColliderShape();

   	private LightingColliderMovement movement = new LightingColliderMovement();
       
	public LightingOcclussionShape GetOcclusionShape() {
		if (occlusionShape == null) {
			occlusionShape = new LightingOcclussionShape();
			occlusionShape.Init(shape, occlusionSize, colliderType);
		}
		return(occlusionShape);
	}

    private void Awake() {
        shape.SetGameObject(gameObject);

        switch(occlusionType) {
            case OcclusionType.Hard:
                GenerateMesh_Strict();
                break;
            case OcclusionType.Soft:
                GenerateMesh_Smooth();
                break;
        }
    }

	public void OnEnable() {
		Initialize();
	}

    public void Initialize() {
		movement.Reset();
		movement.moved = true;

		shape.ResetLocal();
	}

    public void Update() {
		movement.Update(shape);

		if (movement.moved) {
			shape.ResetWorld();	
		}
	}

    void GenerateMesh_Strict() {
        List<Pair2D> iterate1, iterate2;
        Vector2D first = null;
		Pair2D pA, pB;
        bool isEdgeCollider = shape.IsEdgeCollider();
		
        GameObject gameObject = new GameObject("Occlussion");
        gameObject.transform.parent = transform;

        MeshRenderer meshRenderer = gameObject.AddComponent<MeshRenderer>();
        MeshFilter meshFilter = gameObject.AddComponent<MeshFilter>();

        List<Vector3> vertices = new List<Vector3>();
        List<int> triangles = new List<int>();
        List<Vector2> uvs = new List<Vector2>();

        occlusionShape = GetOcclusionShape();

        int count = 0;

        for(int x = 0; x < occlusionShape.polygonPoints.Count; x++) {
            iterate1 = occlusionShape.polygonPoints[x];
            iterate2 = occlusionShape.outlinePoints[x];
    
            first = null;

            int i = 0;
            for(int y = 0; y < iterate1.Count; y++) {
                pA = iterate1[y];
                
                if (isEdgeCollider && first == null) {
                    first = pA.A;
                    continue;
                }

                if (i >= iterate2.Count) {
                    continue;
                }

                pB = iterate2[i];

                vertices.Add(pA.A.ToVector2());
                uvs.Add(new Vector2(0, 0));

                vertices.Add(pA.B.ToVector2());
                uvs.Add(new Vector2(1, 0));

                vertices.Add(pB.B.ToVector2());
                uvs.Add(new Vector2(1, 1));

                vertices.Add(pB.A.ToVector2());
                uvs.Add(new Vector2(0, 1));

                triangles.Add(count + 0);
                triangles.Add(count + 1);
                triangles.Add(count + 2);

                triangles.Add(count + 2);
                triangles.Add(count + 3);
                triangles.Add(count + 0);

                count += 4;

                i ++;
            }

            Mesh mesh = new Mesh();
            mesh.vertices = vertices.ToArray();
            mesh.uv = uvs.ToArray();
            mesh.triangles = triangles.ToArray();

            mesh.RecalculateBounds();
            mesh.RecalculateNormals();

            meshFilter.mesh = mesh;

            meshRenderer.sharedMaterial = Lighting2D.materials.GetOcclusionBlur();
		}
    }

    void GenerateMesh_Smooth() {
        double angleA, angleB, angleC;

        List<DoublePair2D> iterate3;

		DoublePair2D p;

        GameObject gameObject = new GameObject("Occlussion");
        gameObject.transform.parent = transform;

        MeshRenderer meshRenderer = gameObject.AddComponent<MeshRenderer>();
        MeshFilter meshFilter = gameObject.AddComponent<MeshFilter>();

        List<Vector3> vertices = new List<Vector3>();
        List<int> triangles = new List<int>();
        List<Vector2> uvs = new List<Vector2>();

        occlusionShape = GetOcclusionShape();

        Vector2D vA = Vector2D.Zero(), vB = Vector2D.Zero(), vC = Vector2D.Zero(), pA = Vector2D.Zero(), pB = Vector2D.Zero();

        int count = 0;
        
        for(int x = 0; x < occlusionShape.polygonPairs.Count; x++) {
            iterate3 = occlusionShape.polygonPairs[x];

            for(int y = 0; y < iterate3.Count; y++) {
                p = iterate3[y];
            
                vA.x = p.A.x;
                vA.y = p.A.y;

                vB.x = p.B.x;
                vB.y = p.B.y;

                pA.x = p.A.x;
                pA.y = p.A.y;

                pB.x = p.B.x;
                pB.y = p.B.y;

                vC.x = p.B.x;
                vC.y = p.B.y;

                angleA = Vector2D.Atan2 (p.A, p.B) - Mathf.PI / 2;
                angleB = Vector2D.Atan2 (p.A, p.B) - Mathf.PI / 2;
                angleC = Vector2D.Atan2 (p.B, p.C) - Mathf.PI / 2;

                vA.Push (angleA, occlusionSize);
                vB.Push (angleB, occlusionSize);
                vC.Push (angleC, occlusionSize);

                Vector2D ps = (vB + vC) / 2;

                float distance = (float)Vector2D.Distance(p.B, vB) - 180f * Mathf.Deg2Rad;
                float rot = (float)Vector2D.Atan2(p.B, ps);

                ps = p.B.Copy();
                ps.Push(rot, distance);

                vertices.Add(pA.ToVector2());
                uvs.Add(new Vector2(0f, 0f));

                vertices.Add(pB.ToVector2());
                uvs.Add(new Vector2(0.5f, 0f));

                vertices.Add(vB.ToVector2());
                uvs.Add(new Vector2(0.5f, 1f));

                vertices.Add(vA.ToVector2());
                uvs.Add(new Vector2(0f, 1f));

                vertices.Add(ps.ToVector2());
                uvs.Add(new Vector2(1f, 1f));

                vertices.Add(vC.ToVector2());
                uvs.Add(new Vector2(0.5f, 1f));

               

                triangles.Add(count + 0);
                triangles.Add(count + 1);
                triangles.Add(count + 2);

                triangles.Add(count + 2);
                triangles.Add(count + 3);
                triangles.Add(count + 0);


                triangles.Add(count + 1);
                triangles.Add(count + 2);
                triangles.Add(count + 4);

                triangles.Add(count + 4);
                triangles.Add(count + 5);
                triangles.Add(count + 1);

                count += 6;
            }
        }

        Mesh mesh = new Mesh();
        mesh.vertices = vertices.ToArray();
        mesh.uv = uvs.ToArray();
        mesh.triangles = triangles.ToArray();

        mesh.RecalculateBounds();
        mesh.RecalculateNormals();

        meshFilter.mesh = mesh;

        meshRenderer.sharedMaterial = Lighting2D.materials.GetOcclusionEdge();
    }
}