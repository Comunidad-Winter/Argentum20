using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;

[CustomEditor(typeof(LightingRoom2D))]
public class LightingRoom2DEditor :Editor {
    	override public void OnInspectorGUI() {
		LightingRoom2D script = target as LightingRoom2D;

		script.roomType = (LightingRoom2D.RoomType)EditorGUILayout.EnumPopup("Room Type", script.roomType);

 		script.color = EditorGUILayout.ColorField("Color", script.color);

		if (GUILayout.Button("Update")) {
			script.Initialize();
		}

		if (GUI.changed && EditorApplication.isPlaying == false) {
			EditorUtility.SetDirty(script);
			EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
		}
	}
}
