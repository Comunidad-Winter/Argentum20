using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EXPERIMENTAL_SceneLoader : MonoBehaviour {
    //[SerializeField] private Collider2D _collider1;
    //[SerializeField] private Collider2D _collider2;

    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        //if (!_collider1.bounds.Intersects(_collider2.bounds)) {
        //    Debug.Log("intersecting!");
        //}
    }

    private void OnTriggerExit2D(Collider2D collision) {
        if (collision.CompareTag("Player")) {
            Debug.Log("triggered!");
            SceneManager.LoadSceneAsync("Scenes/35", LoadSceneMode.Additive);
        }
    }
}
