using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class CustomPhysicsShapeManager {
	static public Dictionary<Sprite, CustomPhysicsShape> dictionary_CustomPhysicsShape = new Dictionary<Sprite, CustomPhysicsShape>();

	static public CustomPhysicsShape RequesCustomShape(Sprite originalSprite) {
		CustomPhysicsShape shape = null;

		bool exist = dictionary_CustomPhysicsShape.TryGetValue(originalSprite, out shape);

		if (exist) {
			if (shape == null || shape.GetSprite().texture == null) {
                shape = RequestCustomShapeAccess(originalSprite);
			} 
			return(shape);
		} else {
            shape = RequestCustomShapeAccess(originalSprite);
			return(shape);
		}
    }

    static public CustomPhysicsShape RequestCustomShapeAccess(Sprite originalSprite) {
		CustomPhysicsShape shape = null;

		bool exist = dictionary_CustomPhysicsShape.TryGetValue(originalSprite, out shape);

		if (exist) {
			if (shape == null || shape.GetSprite().texture == null) {
				dictionary_CustomPhysicsShape.Remove(originalSprite);

				shape = AddShape(originalSprite);

				dictionary_CustomPhysicsShape.Add(originalSprite, shape);
			} 
			return(shape);
		} else {		
			shape = AddShape(originalSprite);

			dictionary_CustomPhysicsShape.Add(originalSprite, shape);

			return(shape);
		}
    }

   static private CustomPhysicsShape AddShape(Sprite sprite) {
        if (sprite == null || sprite.texture == null) {
            return(null);
        }

        CustomPhysicsShape shape = new CustomPhysicsShape();
        shape.SetSprite(sprite);

        return(shape);
    }
}