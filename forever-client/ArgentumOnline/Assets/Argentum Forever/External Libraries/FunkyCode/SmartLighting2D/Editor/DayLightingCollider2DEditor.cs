using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;

[CanEditMultipleObjects]
[CustomEditor(typeof(DayLightingCollider2D))]
public class DayLightingCollider2DEditor : Editor {

	override public void OnInspectorGUI() {
		DayLightingCollider2D script = target as DayLightingCollider2D;

		script.layer = (DayLightingLayer)EditorGUILayout.EnumPopup("Layer", script.layer);

		script.shape.colliderType = (DayLightingCollider2D.ColliderType)EditorGUILayout.EnumPopup("Collision Type", script.shape.colliderType);
		
		
		script.shape.maskType = (DayLightingCollider2D.MaskType)EditorGUILayout.EnumPopup("Mask Type", script.shape.maskType);

		script.shape.height = EditorGUILayout.FloatField("Height", script.shape.height);
		
		if (GUILayout.Button("Update")) {
			script.shape.Reset();

			script.Generate();
		}

		if (GUI.changed && EditorApplication.isPlaying == false) {
            EditorUtility.SetDirty(target);
            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
		}
	}
}
