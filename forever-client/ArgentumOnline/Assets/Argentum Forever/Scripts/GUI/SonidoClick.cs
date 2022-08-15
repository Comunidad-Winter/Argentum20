using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using UnityEngine;

public class SonidoClick : MonoBehaviour {

    public AudioSource fuente;
    public AudioClip clip;

    void Start() {
        fuente.clip = clip;   
    }

      
    public void Reproducir(){
            fuente.Play ();
    }
}
