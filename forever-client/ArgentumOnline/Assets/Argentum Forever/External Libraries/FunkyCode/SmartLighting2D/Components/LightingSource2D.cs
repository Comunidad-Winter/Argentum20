using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

// Light Source
public enum LightingSourceTextureSize {px2048, px1024, px512, px256, px128};
public enum LightingEventState {OnCollision, OnCollisionEnter, OnCollisionExit, None}

[ExecuteInEditMode]
public class LightingSource2D : MonoBehaviour {
	public enum LightSprite {Default, Custom};
	public enum WhenInsideCollider {DrawAbove, DrawInside}; // Draw Bellow / Do Not Draw

	// Settings
	public Color lightColor = new Color(.5f,.5f, .5f, 1);
	public float lightAlpha = 1f;
	public float lightSize = 5f;
	public float lightCoreSize = 0.5f;
	public LightingSourceTextureSize textureSize = LightingSourceTextureSize.px1024;
	public bool enableCollisions = true;
	public bool rotationEnabled = false;
	public bool eventHandling = false;

	public bool additive = false;
	public float additive_alpha = 0.25f;

	public WhenInsideCollider whenInsideCollider = WhenInsideCollider.DrawAbove;

	public bool disableWhenInvisible = false;

	public LightSprite lightSprite = LightSprite.Default;
	public Sprite sprite;
	public bool spriteFlipX = false;
	public bool spriteFlipY = false;

	public LayerSetting[] layerSetting = new LayerSetting[1];

	private bool inScreen = false;

	public LightingBuffer2D buffer = null;

	public int sortingOrder;
	public string sortingLayer;

	///// Movemnt ////
	public LightingSource2DMovement movement = new LightingSource2DMovement();

	//public bool staticUpdated = false; // Not Necessary

	public float occlusionSize = 15;

	public static Sprite defaultSprite = null;

	public static List<LightingSource2D> list = new List<LightingSource2D>();

	private LightingSourceEventHandling eventHandlingObject = new LightingSourceEventHandling();

	public void OnBecameVisible() {
		if (disableWhenInvisible) {
			if (this.enabled == false) {
				this.enabled = true;
			}
		}	
	}

	public void OnBecameInvisible() {
		if (disableWhenInvisible) {
			if (this.enabled == true) {
				this.enabled = false;
			}
		}
	}

	static public Sprite GetDefaultSprite() {
		if (defaultSprite == null || defaultSprite.texture == null) {
			defaultSprite = Resources.Load <Sprite> ("Sprites/gfx_light");
		}
		return(defaultSprite);
	}

	public void OnEnable() {
		list.Add(this);
	}

	public void OnDisable() {
		list.Remove(this);

		Free();
	}

	public void Free() {
		///// Free Buffer!
		FBOManager.FreeBuffer(buffer);

		buffer = null;
		inScreen = false;
	}

	static public List<LightingSource2D> GetList() {
		return(list);
	}

	public bool InCamera(Camera camera) {
		if (camera == null) {
			return(false);
		} else {
			float cameraSize = camera.orthographicSize;
			return(Vector2.Distance(transform.position, camera.transform.position) < Mathf.Sqrt((cameraSize * 2f) * (cameraSize * 2f)) + lightSize );
		}	
	}

	public bool InAnyCamera() {
		CameraSettings[] cameraSettings = LightingManager2D.Get().cameraSettings;
		for(int i = 0; i < cameraSettings.Length; i++) {
			Camera camera = LightingManager2D.Get().GetCamera(i);
			if (InCamera(camera)) {
				return(true);
			}
		}

		return(false);
	}

	void Start () {
		movement.ForceUpdate();

		for(int i = 0; i < layerSetting.Length; i++) {
			if (layerSetting[i] == null) {
				layerSetting[i] = new LayerSetting();
				layerSetting[i].layerID = LightingLayer.Layer1;
				layerSetting[i].type = LightingLayerType.Default;
				layerSetting[i].renderingOrder = LightingLayerOrder.Default;
			}
		}

		eventHandlingObject.lightingSource = this;
	}

	public Sprite GetSprite() {
		if (sprite == null || sprite.texture == null) {
			sprite = GetDefaultSprite();
		}
		return(sprite);
	}
		
	public LightingBuffer2D GetBuffer() {
		buffer = FBOManager.PullBuffer (LightingRender.GetTextureSize(textureSize), this);
		return(buffer);
	}

	void BufferUpdate() {
		movement.update = false;
		if (buffer != null) {
			if (Lighting2D.disable == false) {
				buffer.bufferCamera.enabled = true; // //UpdateLightBuffer(True)
				buffer.bufferCamera.orthographicSize = lightSize;
			}
		}
	}

	public void Update_Loop() {
		movement.Update(this);

		if (InAnyCamera()) {
			if (movement.update == true) {
				if (inScreen == false) {
					if (GetBuffer() != null) {
						BufferUpdate();

						inScreen = true;
					}
				} else {
					BufferUpdate();
				}
			} else {
				if (buffer == null) {
					if (GetBuffer() != null) {
						BufferUpdate();

						inScreen = true;
					}
				}
			}
		} else {
			///// Free Buffer!
			if (buffer != null) {
				FBOManager.FreeBuffer(buffer);
				buffer = null;
			}
			inScreen = false;
		}
		
		if (eventHandling) {
			eventHandlingObject.UpdateEventHandling();
			//.UpdateTilemapEventHandling();
		}
	}
}
