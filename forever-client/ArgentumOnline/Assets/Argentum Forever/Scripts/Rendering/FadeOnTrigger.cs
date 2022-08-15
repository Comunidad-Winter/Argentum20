using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeOnTrigger : MonoBehaviour
{
    private SpriteRenderer mRenderer;
    private bool mIsAlpha;

    private void Awake()
    {
        mRenderer = GetComponent<SpriteRenderer>();
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            mIsAlpha = true;
            mRenderer.DOFade(0.5f, 0.3f);
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            mIsAlpha = false;
            mRenderer.DOFade(1f, 0.3f);
        }
    }
}
