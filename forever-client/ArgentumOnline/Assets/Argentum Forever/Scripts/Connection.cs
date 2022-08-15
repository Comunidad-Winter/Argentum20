using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Connection : NetworkBehaviour
{
    [SerializeField] private GameObject mConnectionPrefab;
    [SerializeField] private AudioManager mAudioManager;

    private static Connection _instance;
    public static Connection Instance { get { return _instance; } }

    private void InitializeSingleton()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    private void Awake()
    {

        InitializeSingleton();
    }

    public void PlaySound(int soundID)
    {
        //TODO delegar al audio manager
    }

    public void PlaySpellFX(Spell spell, Vector2 position, Transform attachedTo)
    {
        int spellIndex = VisualEffectsManager.Instance.GetIndexFromSpell(spell);
        RpcPlaySpellFX(spellIndex, position, attachedTo);
    }

    [ClientRpc]
    private void RpcPlaySpellFX(int spellIndex, Vector2 position, Transform attachedTo)
    {
        GameObject spellVFX = VisualEffectsManager.Instance.GetSpellFromIndex(spellIndex)._visualEffectPrefab;
        VisualEffectsManager.Instance.PlaySpellFX(spellVFX, position, attachedTo);
    }
}
